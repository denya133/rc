_ = require 'lodash'

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

    ipsWithAnchorSave = @private _withAnchorSave: String,
      default: null

    @public doBeforeReset: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsBeforeReset], args, 'Specified "beforeReset" not found', args

    @public doAfterReset: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsAfterReset], args, 'Specified "afterReset" not found', args

    @public doBeforeAllEvents: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsBeforeAllEvents], args, 'Specified "beforeAllEvents" not found', args

    @public doAfterAllEvents: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsAfterAllEvents], args, 'Specified "afterAllEvents" not found', args

    @public doAfterAllTransitions: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsAfterAllTransitions], args, 'Specified "afterAllTransitions" not found', args

    @public doErrorOnAllEvents: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsAfterAllErrors], args, 'Specified "errorOnAllEvents" not found', args

    @public doWithAnchorUpdateState: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsWithAnchorUpdateState], args, 'Specified "withAnchorUpdateState" not found', args

    @public doWithAnchorSave: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsWithAnchorSave], args, 'Specified "withAnchorSave" not found', args

    @public registerState: Function,
      default: (name, config = {}) ->
        if @states[name]?
          throw new Error "State with specified name #{name} is already registered"
        vpoAnchor = @[Symbol.for '~anchor']
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

    @public registerEvent: Function,
      default: (asEvent, alDepartures, asTarget, ahEventConfig = {}, ahTransitionConfig = {}) ->
        vlDepartues = _.castArray alDepartures
        voNextState = @states[asTarget]
        voAnchor = @[Symbol.for '~anchor']
        for vsState in vlDepartues then do (voState = @states[vsState]) ->
          if voState?
            vsTransitionName = "#{voState.name}_#{asEvent}"
            voTransition = RC::Transition.new vsTransitionName, voAnchor, ahTransitionConfig
            voState.defineTransition asEvent, voNextState,  voTransition, ahEventConfig
          return
        return

    @public reset: Function,
      default: ->
        { co } = RC::Utils
        co =>
          yield @doBeforeReset()
          @currentState = @initialState
          yield @doAfterReset()
          yield return

    @public send: Function,
      default: (asEvent, args...) ->
        { co } = RC::Utils
        stateMachine = @
        co ->
          try
            yield stateMachine.doBeforeAllEvents args...
            yield stateMachine.currentState.send asEvent, args...
            yield stateMachine.doAfterAllEvents args...
          catch err
            yield stateMachine.doErrorOnAllEvents err
          yield return

    @public transitionTo: Function,
      default: (nextState, transition, args...) ->
        { co } = RC::Utils
        stateMachine = @
        co ->
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

    @public state: Function,
      default: (asState, ahConfig) ->
        @registerState asState, ahConfig

    @public event: Function,
      default: (asEvent, ahConfig, amTransitionInitializer) ->
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

  return RC::StateMachine.initialize()
