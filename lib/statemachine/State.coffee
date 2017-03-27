
###
State instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  class RC::State extends RC::HookedObject
    @inheritProtected()

    @Module: RC

    iphTransitions = @private transitions: Object,
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

    @public getTransitions: Function,
      default: -> @[iphTransitions]

    @public name: String,
      default: null

    @public getTransition: Function,
      default: (asEvent) ->
        @[iphTransitions][asEvent]

    @public defineTransition: Function,
      default: (asEvent, aoTarget, aoTransition) ->
        unless @[iphTransitions][asEvent]?
          @[iphTransitions][asEvent] =
            target: aoTarget
            transition: aoTransition
        @[iphTransitions][asEvent]

    @public removeTransition: Function,
      default: (asEvent) ->
        if @[iphTransitions][asEvent]?
          delete @[iphTransitions][asEvent].transition
          delete @[iphTransitions][asEvent].target
          delete @[iphTransitions][asEvent]
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

    constructor: (@name, anchor, ..., config = {})->
      super arguments...
      {
        beforeEnter: @[ipsBeforeEnter]
        enter: @[ipsEnter]
        afterEnter: @[ipsAfterEnter]
        beforeExit: @[ipsBeforeExit]
        exit: @[ipsExit]
        afterExit: @[ipsAfterExit]
      } = config


  return RC::State.initialize()
