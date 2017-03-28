
###
Stand-alone or mixed-in class (via StateMachineMixin)

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  { co } = RC::Utils

  class RC::StateMachine extends RC::HookedObject
    @inheritProtected()

    @Module: RC

    @public name: String,
      default: null

    @public currentState: String,
      default: null

    @public initialState: String,
      default: null

    @public states: String,
      default: {}

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

    @public registerState: Function,
      default: (name, config = {}) ->
        if @states[name]?
          throw new Error "State with specified name #{name} is already registered"
        vpoAnchor = @[Symbol.for 'anchor']
        @states[name] = state = RC::State.new name, vpoAnchor, @, config
        if state.initial
          @initialState = state
        state

    @public removeState: Function,
      default: (name) ->
        if (removedState = @states[name])?
          delete @states[name]
          if @initialState is removedState
            @initialState = null
          if @currentState is removedState
            @currentState = null
          return yes
        no

    @public send: Function,
      default: (asEvent, args...) ->
        stateMachine = @
        co ->
          try
            yield stateMachine.doBeforeAllEvents args...
            yield stateMachine.currentState?.send asEvent, args...
            yield stateMachine.doAfterAllEvents args...
          catch err
            yield stateMachine.doAfterAllErrors err
          yield return

    @public transitionTo: Function,
      default: (nextState, transition, args...) ->
        stateMachine = @
        co ->
          oldState = @currentState
          @currentState = nextState
          try
            yield stateMachine.doAfterAllTransitions args...
            yield transition.doAfter args...
            yield nextState.doBeforeEnter args...
            yield nextState.doEnter args...
            yield transition.doSuccess args...
            yield oldState.doAfterExit args...
            yield nextState.doAfterEnter args...
          yield return

    constructor: (@name, anchor, ..., config = {})->
      super arguments...
      {
        beforeAllEvents: @[ipsBeforeAllEvents]
        afterAllEvents: @[ipsAfterAllEvents]
        afterAllTransitions: @[ipsAfterAllTransitions]
        afterAllErrors: @[ipsAfterAllErrors]
      } = config


  return RC::StateMachine.initialize()
