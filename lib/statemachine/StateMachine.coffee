
###
Stand-alone or mixed-in class (via StateMachineMixin)

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  class RC::StateMachine extends RC::HookedObject
    @inheritProtected()

    @Module: RC

    @public name: String,
      default: null

    @public state: String,
      default: null

    ipsBeforeAllEvents = @private beforeAllEvents: String,
      default: null

    ipsAfterAllEvents = @private afterAllEvents: String,
      default: null

    ipsAfterAllTransitions = @private afterAllTransitions: String,
      default: null

    ipsAfterAllErrors = @private afterAllErrors: String,
      default: null

    @public doBeforeAllEvents: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsBeforeAllEvents], args, 'Specified "beforeAllEvents" not found', args

    @public doAfterAllEvents: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsAfterAllEvents], args, 'Specified "afterAllEvents" not found', args

    @public doAfterAllTransitions: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsAfterAllTransitions], args, 'Specified "afterAllTransitions" not found', args

    @public doAfterAllErrors: Function,
      default: (args...) ->
        @[Symbol.for 'doHook'] @[ipsAfterAllErrors], args, 'Specified "afterAllErrors" not found', args


    constructor: (@name, anchor, ..., config = {})->
      super arguments...
      {
        beforeAllEvents: @[ipsBeforeAllEvents]
        afterAllEvents: @[ipsAfterAllEvents]
        afterAllTransitions: @[ipsAfterAllTransitions]
        afterAllErrors: @[ipsAfterAllErrors]
      } = config


  return RC::StateMachine.initialize()
