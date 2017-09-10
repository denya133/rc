_ = require 'lodash'

###
Transition instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (Module)->
  {
    HookedObject
    State
  } = Module::

  class Transition extends HookedObject
    @inheritProtected()
    @module Module

    @public name: String,
      default: null

    @public state: State,
      default: null

    ipsGuard = @private _guard: String,
      default: null

    ipsIf = @private _if: String,
      default: null

    ipsUnless = @private _unless: String,
      default: null

    ipsAfter = @private _after: String,
      default: null

    ipsSuccess = @private _success: String,
      default: null

    @public @async testGuard: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsGuard], args, 'Specified "guard" not found', yes

    @public @async testIf: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsIf], args, 'Specified "if" not found', yes

    @public @async testUnless: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsUnless], args, 'Specified "unless" not found', no

    @public @async doAfter: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfter], args, 'Specified "after" not found', args

    @public @async doSuccess: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsSuccess], args, 'Specified "success" not found', args

    @public init: Function,
      default: (@name, anchor, ..., config = {})->
        @super arguments...
        {
          guard: @[ipsGuard]
          if: @[ipsIf]
          unless: @[ipsUnless]
          after: @[ipsAfter]
          success: @[ipsSuccess]
        } = config


  Transition.initialize()
