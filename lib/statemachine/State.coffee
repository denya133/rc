

###
State instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (Module)->
  {
    NilT, PointerT
    MaybeG, FuncG, DictG
    HookedObject
    EventInterface
    TransitionInterface
    StateInterface
    StateMachineInterface
    Utils: { co, _ }
  } = Module::

  class State extends HookedObject
    @inheritProtected()
    @implements StateInterface
    @module Module

    ipmDoHook = PointerT @instanceMethods['~doHook'].pointer

    ipoStateMachine = PointerT @private _stateMachine: StateMachineInterface

    iphEvents = PointerT @private _events: DictG String, EventInterface

    ipsBeforeEnter = PointerT @private _beforeEnter: MaybeG String

    ipsEnter = PointerT @private _enter: MaybeG String

    ipsAfterEnter = PointerT @private _afterEnter: MaybeG String

    ipsBeforeExit = PointerT @private _beforeExit: MaybeG String

    ipsExit = PointerT @private _exit: MaybeG String

    ipsAfterExit = PointerT @private _afterExit: MaybeG String

    @public getEvents: FuncG([], DictG String, EventInterface),
      default: -> @[iphEvents]

    # @public name: String

    @public initial: Boolean,
      default: no

    @public getEvent: FuncG(String, MaybeG EventInterface),
      default: (asEvent) ->
        @[iphEvents][asEvent]

    @public defineTransition: FuncG([String, StateInterface, TransitionInterface, MaybeG Object], EventInterface),
      default: (asEvent, aoTarget, aoTransition, config = {}) ->
        unless @[iphEvents][asEvent]?
          vpoAnchor = @[Symbol.for '~anchor']
          vhEventConfig = _.assign {}, config,
            target: aoTarget
            transition: aoTransition
          vsEventName = "#{@name}_#{asEvent}"
          @[iphEvents][asEvent] = Module::Event.new vsEventName, vpoAnchor, vhEventConfig
        @[iphEvents][asEvent]

    @public removeTransition: FuncG(String, NilT),
      default: (asEvent) ->
        if @[iphEvents][asEvent]?
          delete @[iphEvents][asEvent]
        return

    @public @async doBeforeEnter: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsBeforeEnter], args, 'Specified "beforeEnter" not found', args

    @public @async doEnter: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsEnter], args, 'Specified "enter" not found', args

    @public @async doAfterEnter: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfterEnter], args, 'Specified "afterEnter" not found', args

    @public @async doBeforeExit: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsBeforeExit], args, 'Specified "beforeExit" not found', args

    @public @async doExit: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsExit], args, 'Specified "exit" not found', args

    @public @async doAfterExit: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfterExit], args, 'Specified "afterExit" not found', args

    @public @async send: FuncG(String, NilT),
      default: (asEvent, args...) ->
        oldState = @
        if (event = oldState[iphEvents][asEvent])?
          try
            yield event.doBefore args...
            eventGuard = yield event.testGuard args...
            eventIf = yield event.testIf args...
            eventUnless = yield event.testUnless args...
            if eventGuard and eventIf and not eventUnless
              { transition } = event
              transitionGuard = yield transition.testGuard args...
              transitionIf = yield transition.testIf args...
              transitionUnless = yield transition.testUnless args...
              if transitionGuard and transitionIf and not transitionUnless
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

    @public init: FuncG([String, Object, StateMachineInterface, MaybeG Object], NilT),
      default: (@name, anchor, aoStateMachine, ..., config = {})->
        @super arguments...
        @[iphEvents] = {}
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
        return


    @initialize()
