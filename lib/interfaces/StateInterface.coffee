

module.exports = (Module)->
  {
    NilT
    FuncG
    Interface
    StateMachineInterface
  } = Module::

  class StateInterface extends Interface
    @inheritProtected()
    @module Module

    @virtual getEvents: Function,
      default: -> @[iphEvents]

    @virtual name: String

    @virtual initial: Boolean

    @virtual getEvent: Function,
      default: (asEvent) ->
        @[iphEvents][asEvent]

    @virtual defineTransition: Function,
      default: (asEvent, aoTarget, aoTransition, config = {}) ->
        unless @[iphEvents][asEvent]?
          vpoAnchor = @[Symbol.for '~anchor']
          vhEventConfig = _.assign {}, config,
            target: aoTarget
            transition: aoTransition
          vsEventName = "#{@name}_#{asEvent}"
          @[iphEvents][asEvent] = Module::Event.new vsEventName, vpoAnchor, vhEventConfig
        @[iphEvents][asEvent]

    @virtual removeTransition: Function,
      default: (asEvent) ->
        if @[iphEvents][asEvent]?
          delete @[iphEvents][asEvent]
        return

    @virtual @async doBeforeEnter: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsBeforeEnter], args, 'Specified "beforeEnter" not found', args

    @virtual @async doEnter: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsEnter], args, 'Specified "enter" not found', args

    @virtual @async doAfterEnter: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterEnter], args, 'Specified "afterEnter" not found', args

    @virtual @async doBeforeExit: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsBeforeExit], args, 'Specified "beforeExit" not found', args

    @virtual @async doExit: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsExit], args, 'Specified "exit" not found', args

    @virtual @async doAfterExit: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfterExit], args, 'Specified "afterExit" not found', args

    @virtual @async send: Function,
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

    @virtual init: FuncG [String, Object, StateMachineInterface, Object], NilT


    @initialize()
