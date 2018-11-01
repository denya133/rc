

###
Event instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (Module)->
  {
    NilT
    MaybeG, FuncG
    HookedObject
    TransitionInterface
    StateInterface
    EventInterface
    Utils: { _ }
  } = Module::

  class Event extends HookedObject
    @inheritProtected()
    @implements EventInterface
    @module Module

    @public name: String

    @public transition: TransitionInterface

    @public target: StateInterface

    ipmDoHook = @instanceMethods['~doHook'].pointer

    ipsGuard = @private _guard: MaybeG String

    ipsIf = @private _if: MaybeG String

    ipsUnless = @private _unless: MaybeG String

    ipsBefore = @private _before: MaybeG String

    ipsAfter = @private _after: MaybeG String

    ipsSuccess = @private _success: MaybeG String

    ipsError = @private _error: MaybeG String

    @public @async testGuard: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsGuard], args, 'Specified "guard" not found', yes

    @public @async testIf: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsIf], args, 'Specified "if" not found', yes

    @public @async testUnless: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsUnless], args, 'Specified "unless" not found', no

    @public @async doBefore: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsBefore], args, 'Specified "before" not found', args

    @public @async doAfter: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfter], args, 'Specified "after" not found', args

    @public @async doSuccess: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsSuccess], args, 'Specified "success" not found', args

    @public @async doError: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsError], args, 'Specified "error" not found', args

    @public init: FuncG([String, Object, Object], NilT),
      default: (@name, anchor, ..., config = {})->
        @super arguments...
        {
          transition: @transition
          target: @target
          guard: @[ipsGuard]
          if: @[ipsIf]
          unless: @[ipsUnless]
          before: @[ipsBefore]
          success: @[ipsSuccess]
          after: @[ipsAfter]
          error: @[ipsError]
        } = config


    @initialize()
