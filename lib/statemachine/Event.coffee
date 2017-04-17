_ = require 'lodash'

###
Event instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  class RC::Event extends RC::HookedObject
    @inheritProtected()

    @Module: RC

    @public name: String,
      default: null

    @public transition: RC::Transition,
      default: null

    @public target: RC::State,
      default: null

    ipsGuard = @private _guard: String,
      default: null

    ipsIf = @private _if: String,
      default: null

    ipsUnless = @private _unless: String,
      default: null

    ipsBefore = @private _before: String,
      default: null

    ipsAfter = @private _after: String,
      default: null

    ipsSuccess = @private _success: String,
      default: null

    ipsError = @private _error: String,
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

    @public doBefore: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsBefore], args, 'Specified "before" not found', args

    @public doAfter: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsAfter], args, 'Specified "after" not found', args

    @public doSuccess: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsSuccess], args, 'Specified "success" not found', args

    @public doError: Function,
      default: (args...) ->
        @[Symbol.for '~doHook'] @[ipsError], args, 'Specified "error" not found', args

    @public init: Function,
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


  return RC::Event.initialize()
