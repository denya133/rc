

###
Transition instances for StateMachine class

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
  } = Module::

  class Transition extends HookedObject
    @inheritProtected()
    @implements TransitionInterface
    @module Module

    @public name: String

    ipmDoHook = @instanceMethods['~doHook'].pointer

    ipsGuard = @private _guard: MaybeG String

    ipsIf = @private _if: MaybeG String

    ipsUnless = @private _unless: MaybeG String

    ipsAfter = @private _after: MaybeG String

    ipsSuccess = @private _success: MaybeG String

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

    @public init: FuncG([String, Object, Object], NilT),
      default: (@name, anchor, ..., config = {})->
        @super arguments...
        {
          guard: @[ipsGuard]
          if: @[ipsIf]
          unless: @[ipsUnless]
          after: @[ipsAfter]
          success: @[ipsSuccess]
        } = config


    @initialize()
