

###
Transition instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (Module)->
  {
    NilT, PointerT
    MaybeG, FuncG
    HookedObject
    TransitionInterface
  } = Module::

  class Transition extends HookedObject
    @inheritProtected()
    @implements TransitionInterface
    @module Module

    # @public name: String

    ipmDoHook = PointerT @instanceMethods['~doHook'].pointer

    ipsGuard = PointerT @private _guard: MaybeG String

    ipsIf = PointerT @private _if: MaybeG String

    ipsUnless = PointerT @private _unless: MaybeG String

    ipsAfter = PointerT @private _after: MaybeG String

    ipsSuccess = PointerT @private _success: MaybeG String

    @public @async testGuard: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsGuard], args, 'Specified "guard" not found', yes

    @public @async testIf: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsIf], args, 'Specified "if" not found', yes

    @public @async testUnless: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsUnless], args, 'Specified "unless" not found', no

    @public @async doAfter: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsAfter], args, 'Specified "after" not found', args

    @public @async doSuccess: Function,
      default: (args...) ->
        return yield @[ipmDoHook] @[ipsSuccess], args, 'Specified "success" not found', args

    @public init: FuncG([String, Object, MaybeG Object], NilT),
      default: (@name, anchor, ..., config = {})->
        @super arguments...
        {
          guard: @[ipsGuard]
          if: @[ipsIf]
          unless: @[ipsUnless]
          after: @[ipsAfter]
          success: @[ipsSuccess]
        } = config
        return


    @initialize()
