_ = require 'lodash'

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
      @initial = config.initial is yes


  return RC::State.initialize()
