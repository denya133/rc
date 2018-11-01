

module.exports = (Module)->
  {
    NilT
    MaybeG, DictG, FuncG
    Interface
    StateInterface
  } = Module::

  class StateMachineInterface extends Interface
    @inheritProtected()
    @module Module

    @virtual name: String

    @virtual currentState: MaybeG StateInterface

    @virtual initialState: MaybeG StateInterface

    @public states: DictG String, StateInterface

    @virtual @async doBeforeReset: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsBeforeReset], args, 'Specified "beforeReset" not found', args

    @virtual @async doAfterReset: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterReset], args, 'Specified "afterReset" not found', args

    @virtual @async doBeforeAllEvents: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsBeforeAllEvents], args, 'Specified "beforeAllEvents" not found', args

    @virtual @async doAfterAllEvents: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterAllEvents], args, 'Specified "afterAllEvents" not found', args

    @virtual @async doAfterAllTransitions: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterAllTransitions], args, 'Specified "afterAllTransitions" not found', args

    @virtual @async doErrorOnAllEvents: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterAllErrors], args, 'Specified "errorOnAllEvents" not found', args

    @virtual @async doWithAnchorUpdateState: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsWithAnchorUpdateState], args, 'Specified "withAnchorUpdateState" not found', args

    @virtual @async doWithAnchorRestoreState: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsWithAnchorRestoreState], args, 'Specified "withAnchorRestoreState" not found', args

    @virtual @async doWithAnchorSave: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsWithAnchorSave], args, 'Specified "withAnchorSave" not found', args

    @virtual registerState: Function,
      default: (name, config = {}) ->
        if @states[name]?
          throw new Error "State with specified name #{name} is already registered"
        vpoAnchor = @[Symbol.for '~anchor']
        @states[name] = state = Module::State.new name, vpoAnchor, @, config
        if state.initial
          @initialState = state
        state

    @virtual removeState: Function,
      default: (name) ->
        if (removedState = @states[name])?
          delete @states[name]
          if @initialState is removedState
            @initialState = null
          if @currentState is removedState
            @currentState = null
          return yes
        no

    @virtual registerEvent: Function,
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

    @virtual @async reset: Function,
      default: ->
        yield @doBeforeReset()
        restoredState = @states[yield @doWithAnchorRestoreState()]
        @currentState = restoredState ? @initialState
        yield @doWithAnchorUpdateState @currentState.name  if @currentState?
        yield @doAfterReset()
        yield return

    @virtual @async send: Function,
      default: (asEvent, args...) ->
        stateMachine = @
        try
          yield stateMachine.doBeforeAllEvents args...
          yield stateMachine.currentState.send asEvent, args...
          yield stateMachine.doAfterAllEvents args...
        catch err
          yield stateMachine.doErrorOnAllEvents err
        yield return

    @virtual @async transitionTo: Function,
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

    @virtual init: FuncG [String, Object, Object], NilT

    # Mixin intializer methods
    @virtual beforeAllEvents: Function,
      default: (asMethod) ->
        @[ipsBeforeAllEvents] = asMethod

    @virtual afterAllTransitions: Function,
      default: (asMethod) ->
        @[ipsAfterAllTransitions] = asMethod

    @virtual afterAllEvents: Function,
      default: (asMethod) ->
        @[ipsAfterAllEvents] = asMethod

    @virtual errorOnAllEvents: Function,
      default: (asMethod) ->
        @[ipsAfterAllErrors] = asMethod

    @virtual withAnchorUpdateState: Function,
      default: (asMethod) ->
        @[ipsWithAnchorUpdateState] = asMethod

    @virtual withAnchorSave: Function,
      default: (asMethod) ->
        @[ipsWithAnchorSave] = asMethod

    @virtual withAnchorRestoreState: Function,
      default: (asMethod) ->
        @[ipsWithAnchorRestoreState] = asMethod

    @virtual state: Function,
      default: (asState, ahConfig) ->
        @registerState asState, ahConfig

    @virtual event: Function,
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

    @virtual transition: Function,
      default: (previousStates, nextState, ahConfig) ->
        (@constructor[iplTransitionConfigs] ?= []).push
          previousStates: previousStates
          nextState: nextState
          config: ahConfig
        return


    @initialize()
