_ = require 'lodash'

###
State instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  { co } = RC::Utils

  class RC::State extends RC::HookedObject
    @inheritProtected()

    @Module: RC

    ipoStateMachine = @private stateMachine: Object,
      default: {}

    iphEvents = @private events: Object,
      default: {}

    ipsBeforeEnter = @private beforeEnter: String,
      default: null

    ipsEnter = @private enter: String,
      default: null

    ipsAfterEnter = @private afterEnter: String,
      default: null

    ipsBeforeExit = @private beforeExit: String,
      default: null

    ipsExit = @private exit: String,
      default: null

    ipsAfterExit = @private afterExit: String,
      default: null

    @public getEvents: Function,
      default: -> @[iphEvents]

    @public name: String,
      default: null

    @public getEvent: Function,
      default: (asEvent) ->
        @[iphEvents][asEvent]

    @public defineTransition: Function,
      default: (asEvent, aoTarget, aoTransition, config = {}) ->
        unless @[iphEvents][asEvent]?
          vpoAnchor = @[Symbol.for 'anchor']
          vhEventConfig = _.assign {}, config,
            target: aoTarget
            transition: aoTransition
          vsEventName = "#{@name}_#{asEvent}"
          @[iphEvents][asEvent] = RC::Event.new vsEventName, vpoAnchor, vhEventConfig
        @[iphEvents][asEvent]

    @public removeTransition: Function,
      default: (asEvent) ->
        if @[iphEvents][asEvent]?
          delete @[iphEvents][asEvent]
        return

    @public doBeforeEnter: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsBeforeEnter], args, 'Specified "beforeEnter" not found', args

    @public doEnter: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsEnter], args, 'Specified "enter" not found', args

    @public doAfterEnter: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsAfterEnter], args, 'Specified "afterEnter" not found', args

    @public doBeforeExit: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsBeforeExit], args, 'Specified "beforeExit" not found', args

    @public doExit: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsExit], args, 'Specified "exit" not found', args

    @public doAfterExit: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsAfterExit], args, 'Specified "afterExit" not found', args

    @public send: Function,
      default: (asEvent, args...) ->
        oldState = @
        co ->
          if asEvent of @[iphEvents]
            event = @[iphEvents][asEvent]
            try
              yield event.doBefore()
              if (yield event.testGuard args...) and
                  (yield event.testIf args...) and
                  not (yield event.testUnless args...)
                { transition } = event
                if (yield transition.testGuard args...) and
                    (yield transition.testIf args...) and
                    not (yield transition.testUnless args...)
                  yield oldState.doBeforeExit args...
                  yield oldState.doExit args...
                  stateMachine = oldState[ipoStateMachine]
                  yield stateMachine.transitionTo event.target, transition, args...
                yield event.doSuccess args...
              yield event.doAfter args...
            catch err
              yield event.doError err
              throw err
          yield return

    constructor: (@name, anchor, aoStateMachine, ..., config = {})->
      super arguments...
      @[ipoStateMachine] = aoStateMachine
      {
        beforeEnter: @[ipsBeforeEnter]
        enter: @[ipsEnter]
        afterEnter: @[ipsAfterEnter]
        beforeExit: @[ipsBeforeExit]
        exit: @[ipsExit]
        afterExit: @[ipsAfterExit]
      } = config
      @initial = config.initial is yes


  return RC::State.initialize()
