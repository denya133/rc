# This file is part of RC.
#
# RC is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with RC.  If not, see <https://www.gnu.org/licenses/>.

###
Event instances for StateMachine class

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
    StateInterface
    EventInterface
    Utils: { _ }
  } = Module::

  class Event extends HookedObject
    @inheritProtected()
    @implements EventInterface
    @module Module

    # @public name: String

    @public transition: TransitionInterface

    @public target: StateInterface

    ipmDoHook = PointerT @instanceMethods['~doHook'].pointer

    ipsGuard = PointerT @private _guard: MaybeG String

    ipsIf = PointerT @private _if: MaybeG String

    ipsUnless = PointerT @private _unless: MaybeG String

    ipsBefore = PointerT @private _before: MaybeG String

    ipsAfter = PointerT @private _after: MaybeG String

    ipsSuccess = PointerT @private _success: MaybeG String

    ipsError = PointerT @private _error: MaybeG String

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

    @public init: FuncG([String, Object, MaybeG Object], NilT),
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
        return


    @initialize()
