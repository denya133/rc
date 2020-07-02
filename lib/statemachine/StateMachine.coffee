# This file is part of RC.
#
# RC is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with RC.  If not, see <https://www.gnu.org/licenses/>.

###
Stand-alone or mixed-in class (via StateMachineMixin)

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (Module)->
  {
    NilT, PointerT
    MaybeG, FuncG, DictG, ListG, StructG, UnionG
    HookedObject
    StateInterface, TransitionInterface
    StateMachineInterface
    Utils: { co, _ }
  } = Module::

  class StateMachine extends HookedObject
    @inheritProtected()
    @implements StateMachineInterface
    @module Module

    # @public name: String

    @public currentState: MaybeG StateInterface

    @public initialState: MaybeG StateInterface

    @public states: DictG String, StateInterface

    ipmDoHook = PointerT @instanceMethods['~doHook'].pointer

    iplTransitionConfigs = PointerT @private _transitionConfigs: MaybeG ListG StructG {
      previousStates: ListG String
      nextState: String
      config: MaybeG Object
    }

    ipsBeforeReset = PointerT @private _beforeReset: MaybeG String

    ipsAfterReset = PointerT @private _afterReset: MaybeG String

    ipsBeforeAllEvents = PointerT @private _beforeAllEvents: MaybeG String

    ipsAfterAllEvents = PointerT @private _afterAllEvents: MaybeG String

    ipsAfterAllTransitions = PointerT @private _afterAllTransitions: MaybeG String

    ipsAfterAllErrors = PointerT @private _errorOnAllEvents: MaybeG String

    ipsWithAnchorUpdateState = PointerT @private _withAnchorUpdateState: MaybeG String

    ipsWithAnchorRestoreState = PointerT @private _withAnchorRestoreState: MaybeG String

    ipsWithAnchorSave = PointerT @private _withAnchorSave: MaybeG String

    @public @async doBeforeReset: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsBeforeReset], args, 'Specified "beforeReset" not found', args

    @public @async doAfterReset: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfterReset], args, 'Specified "afterReset" not found', args

    @public @async doBeforeAllEvents: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsBeforeAllEvents], args, 'Specified "beforeAllEvents" not found', args

    @public @async doAfterAllEvents: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfterAllEvents], args, 'Specified "afterAllEvents" not found', args

    @public @async doAfterAllTransitions: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfterAllTransitions], args, 'Specified "afterAllTransitions" not found', args

    @public @async doErrorOnAllEvents: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfterAllErrors], args, 'Specified "errorOnAllEvents" not found', args

    @public @async doWithAnchorUpdateState: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsWithAnchorUpdateState], args, 'Specified "withAnchorUpdateState" not found', args

    @public @async doWithAnchorRestoreState: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsWithAnchorRestoreState], args, 'Specified "withAnchorRestoreState" not found', args

    @public @async doWithAnchorSave: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsWithAnchorSave], args, 'Specified "withAnchorSave" not found', args

    @public registerState: FuncG([String, MaybeG Object], StateInterface),
      default: (name, config = {}) ->
        if @states[name]?
          throw new Error "State with specified name #{name} is already registered"
        vpoAnchor = @[Symbol.for '~anchor']
        @states[name] = state = Module::State.new name, vpoAnchor, @, config
        if state.initial
          @initialState = state
        state

    @public removeState: FuncG(String, Boolean),
      default: (name) ->
        if (removedState = @states[name])?
          delete @states[name]
          if @initialState is removedState
            @initialState = null
          if @currentState is removedState
            @currentState = null
          return yes
        no

    @public registerEvent: FuncG([String, UnionG(String, ListG String), String, MaybeG(Object), MaybeG Object], NilT),
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

    @public @async send: FuncG(String, NilT),
      default: (asEvent, args...) ->
        stateMachine = @
        try
          yield stateMachine.doBeforeAllEvents args...
          yield stateMachine.currentState.send asEvent, args...
          yield stateMachine.doAfterAllEvents args...
        catch err
          yield stateMachine.doErrorOnAllEvents err
        yield return

    @public @async transitionTo: FuncG([StateInterface, TransitionInterface], NilT),
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

    @public init: FuncG([String, Object, MaybeG Object], NilT),
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
        return

    # Mixin intializer methods
    @public beforeAllEvents: FuncG(String, NilT),
      default: (asMethod) ->
        @[ipsBeforeAllEvents] = asMethod
        return

    @public afterAllTransitions: FuncG(String, NilT),
      default: (asMethod) ->
        @[ipsAfterAllTransitions] = asMethod
        return

    @public afterAllEvents: FuncG(String, NilT),
      default: (asMethod) ->
        @[ipsAfterAllEvents] = asMethod
        return

    @public errorOnAllEvents: FuncG(String, NilT),
      default: (asMethod) ->
        @[ipsAfterAllErrors] = asMethod
        return

    @public withAnchorUpdateState: FuncG(String, NilT),
      default: (asMethod) ->
        @[ipsWithAnchorUpdateState] = asMethod
        return

    @public withAnchorSave: FuncG(String, NilT),
      default: (asMethod) ->
        @[ipsWithAnchorSave] = asMethod
        return

    @public withAnchorRestoreState: FuncG(String, NilT),
      default: (asMethod) ->
        @[ipsWithAnchorRestoreState] = asMethod
        return

    @public state: FuncG([String, MaybeG Object], NilT),
      default: (asState, ahConfig) ->
        @registerState asState, ahConfig
        return

    @public event: FuncG([String, UnionG(Object, Function), MaybeG Function], NilT),
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

    @public transition: FuncG([ListG(String), String, MaybeG Object], NilT),
      default: (previousStates, nextState, ahConfig) ->
        (@constructor[iplTransitionConfigs] ?= []).push
          previousStates: previousStates
          nextState: nextState
          config: ahConfig
        return


    @initialize()
