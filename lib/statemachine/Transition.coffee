_ = require 'lodash'

###
Transition instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  class RC::Transition extends RC::HookedObject
    @inheritProtected()

    @Module: RC

    @public name: String,
      default: null

    @public state: RC::State,
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

    @public testGuard: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsGuard], args, 'Specified "guard" not found', yes

    @public testIf: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsIf], args, 'Specified "if" not found', yes

    @public testUnless: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsUnless], args, 'Specified "unless" not found', no

    @public doAfter: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsAfter], args, 'Specified "after" not found', args

    @public doSuccess: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsSuccess], args, 'Specified "success" not found', args

    constructor: (@name, anchor, ..., config = {})->
      super arguments...
      {
        guard: @[ipsGuard]
        if: @[ipsIf]
        unless: @[ipsUnless]
        after: @[ipsAfter]
        success: @[ipsSuccess]
      } = config


  return RC::Transition.initialize()
