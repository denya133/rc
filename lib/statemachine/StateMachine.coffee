

###
Stand-alone or mixed-in class (via StateMachineMixin)

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (Module)->
  {
    HookedObject
    Utils: { co, _ }
  } = Module::

  class StateMachine extends HookedObject
    @inheritProtected()
    @module Module

    @public name: String,
      default: null

    @public currentState: String,
      default: null

    @public initialState: String,
      default: null

    @public states: Object,
      default: null

    iplTransitionConfigs = @private _transitionConfigs: String,
      default: null

    ipsBeforeReset = @private _beforeReset: String,
      default: null

    ipsAfterReset = @private _afterReset: String,
      default: null

    ipsBeforeAllEvents = @private _beforeAllEvents: String,
      default: null

    ipsAfterAllEvents = @private _afterAllEvents: String,
      default: null

    ipsAfterAllTransitions = @private _afterAllTransitions: String,
      default: null

    ipsAfterAllErrors = @private _errorOnAllEvents: String,
      default: null

    ipsWithAnchorUpdateState = @private _withAnchorUpdateState: String,
      default: null

    ipsWithAnchorRestoreState = @private _withAnchorRestoreState: String,
      default: null

    ipsWithAnchorSave = @private _withAnchorSave: String,
      default: null

    @public @async doBeforeReset: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsBeforeReset], args, 'Specified "beforeReset" not found', args

    @public @async doAfterReset: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterReset], args, 'Specified "afterReset" not found', args

    @public @async doBeforeAllEvents: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsBeforeAllEvents], args, 'Specified "beforeAllEvents" not found', args

    @public @async doAfterAllEvents: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterAllEvents], args, 'Specified "afterAllEvents" not found', args

    @public @async doAfterAllTransitions: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterAllTransitions], args, 'Specified "afterAllTransitions" not found', args

    @public @async doErrorOnAllEvents: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterAllErrors], args, 'Specified "errorOnAllEvents" not found', args

    @public @async doWithAnchorUpdateState: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsWithAnchorUpdateState], args, 'Specified "withAnchorUpdateState" not found', args

    @public @async doWithAnchorRestoreState: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsWithAnchorRestoreState], args, 'Specified "withAnchorRestoreState" not found', args

    @public @async doWithAnchorSave: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsWithAnchorSave], args, 'Specified "withAnchorSave" not found', args

    @public registerState: Function,
      default: (name, config = {}) ->
        if @states[name]?
          throw new Error "State with specified name #{name} is already registered"
        vpoAnchor = @[Symbol.for '~anchor']
        @states[name] = state = Module::State.new name, vpoAnchor, @, config
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

    @public registerEvent: Function,
      default: (asEvent, alDepartures, asTarget, ahEventConfig = {}, ahTransitionConfig = {}) ->
        vlDepartues = _.castArray alDepartures
        voNextState = @states[asTarget]
        voAnchor = @[Symbol.for '~anchor']
        for vsState in vlDepartues then do (voState = @states[vsState]) ->
          if voState?
            vsTransitionName = "#{voState.name}_#{asEvent}"
            voTransition = Module::Transition.new vsTransitionName, voAnchor, ahTransitionConfig
            voState.defineTransition asEvent, voNextState,  voTransition, ahEventConfig
          return
        return

    @public @async reset: Function,
      default: ->
        yield @doBeforeReset()
        restoredState = @states[yield @doWithAnchorRestoreState()]
        @currentState = restoredState ? @initialState
        yield @doWithAnchorUpdateState @currentState.name  if @currentState?
        yield @doAfterReset()
        yield return

    @public @async send: Function,
      default: (asEvent, args...) ->
        stateMachine = @
        try
          yield stateMachine.doBeforeAllEvents args...
          yield stateMachine.currentState.send asEvent, args...
          yield stateMachine.doAfterAllEvents args...
        catch err
          yield stateMachine.doErrorOnAllEvents err
        yield return

    @public @async transitionTo: Function,
      default: (nextState, transition, args...) ->
        stateMachine = @
        oldState = stateMachine.currentState
        stateMachine.currentState = nextState
        yield stateMachine.doWithAnchorUpdateState nextState.name
        yield stateMachine.doAfterAllTransitions args...
        yield transition.doAfter args...
        yield nextState.doBeforeEnter args...
        yield nextState.doEnter args...
        yield stateMachine.doWithAnchorSave()
        yield transition.doSuccess args...
        yield oldState.doAfterExit args...
        yield nextState.doAfterEnter args...
        yield return

    @public init: Function,
      default: (@name, anchor, ..., config = {})->
        @super arguments...
        @states = {}
        {
          beforeReset: @[ipsBeforeReset]
          afterReset: @[ipsAfterReset]
          beforeAllEvents: @[ipsBeforeAllEvents]
          afterAllEvents: @[ipsAfterAllEvents]
          afterAllTransitions: @[ipsAfterAllTransitions]
          errorOnAllEvents: @[ipsAfterAllErrors]
          withAnchorUpdateState: @[ipsWithAnchorUpdateState]
          withAnchorSave: @[ipsWithAnchorSave]
          withAnchorRestoreState: @[ipsWithAnchorRestoreState]
        } = config

    # Mixin intializer methods
    @public beforeAllEvents: Function,
      default: (asMethod) ->
        @[ipsBeforeAllEvents] = asMethod

    @public afterAllTransitions: Function,
      default: (asMethod) ->
        @[ipsAfterAllTransitions] = asMethod

    @public afterAllEvents: Function,
      default: (asMethod) ->
        @[ipsAfterAllEvents] = asMethod

    @public errorOnAllEvents: Function,
      default: (asMethod) ->
        @[ipsAfterAllErrors] = asMethod

    @public withAnchorUpdateState: Function,
      default: (asMethod) ->
        @[ipsWithAnchorUpdateState] = asMethod

    @public withAnchorSave: Function,
      default: (asMethod) ->
        @[ipsWithAnchorSave] = asMethod

    @public withAnchorRestoreState: Function,
      default: (asMethod) ->
        @[ipsWithAnchorRestoreState] = asMethod

    @public state: Function,
      default: (asState, ahConfig) ->
        @registerState asState, ahConfig

    @public event: Function,
      default: (asEvent, ahConfig, amTransitionInitializer) ->
        if _.isFunction ahConfig
          amTransitionInitializer = ahConfig
          ahConfig = {}
        unless _.isFunction amTransitionInitializer
          amTransitionInitializer = ->
        @constructor[iplTransitionConfigs] = null
        amTransitionInitializer.call @
        transitionConfigs = @constructor[iplTransitionConfigs]
        @constructor[iplTransitionConfigs] = null
        for transitionConf in transitionConfigs
          { previousStates, nextState, config: transitionConfig } = transitionConf
          @registerEvent asEvent, previousStates, nextState, ahConfig, transitionConfig
        @[Symbol.for '~anchor']?.constructor[Symbol.for '~defineSpecialMethods']? asEvent, @
        return

    @public transition: Function,
      default: (previousStates, nextState, ahConfig) ->
        (@constructor[iplTransitionConfigs] ?= []).push
          previousStates: previousStates
          nextState: nextState
          config: ahConfig
        return

  StateMachine.initialize()
