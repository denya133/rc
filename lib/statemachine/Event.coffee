_ = require 'lodash'

###
Event instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (Module)->
  {
    HookedObject
    Transition
    State
  } = Module::

  class Event extends HookedObject
    @inheritProtected()
    @module Module

    @public name: String,
      default: null

    @public transition: Transition,
      default: null

    @public target: State,
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

    @public @async testGuard: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsGuard], args, 'Specified "guard" not found', yes

    @public @async testIf: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsIf], args, 'Specified "if" not found', yes

    @public @async testUnless: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsUnless], args, 'Specified "unless" not found', no

    @public @async doBefore: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsBefore], args, 'Specified "before" not found', args

    @public @async doAfter: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsAfter], args, 'Specified "after" not found', args

    @public @async doSuccess: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsSuccess], args, 'Specified "success" not found', args

    @public @async doError: Function,
      default: (args...) ->
        return yield @[Symbol.for '~doHook'] @[ipsError], args, 'Specified "error" not found', args

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


  Event.initialize()
