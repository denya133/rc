

module.exports = (Module)->
  {
    NilT
    FuncG
    Interface
  } = Module::

  class TransitionInterface extends Interface
    @inheritProtected()
    @module Module

    @virtual name: String

    @virtual @async testGuard: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsGuard], args, 'Specified "guard" not found', yes

    @virtual @async testIf: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsIf], args, 'Specified "if" not found', yes

    @virtual @async testUnless: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsUnless], args, 'Specified "unless" not found', no

    @virtual @async doAfter: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfter], args, 'Specified "after" not found', args

    @virtual @async doSuccess: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsSuccess], args, 'Specified "success" not found', args

    @virtual init: FuncG [String, Object, Object], NilT


    @initialize()
