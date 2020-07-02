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

module.exports = (Module)->
  {
    NilT
    MaybeG, DictG, FuncG, ListG, UnionG
    HookedObjectInterface
    StateInterface, TransitionInterface
  } = Module::

  class StateMachineInterface extends HookedObjectInterface
    @inheritProtected()
    @module Module

    @virtual currentState: MaybeG StateInterface

    @virtual initialState: MaybeG StateInterface

    @public states: DictG String, StateInterface

    @virtual @async doBeforeReset: Function

    @virtual @async doAfterReset: Function

    @virtual @async doBeforeAllEvents: Function

    @virtual @async doAfterAllEvents: Function

    @virtual @async doAfterAllTransitions: Function

    @virtual @async doErrorOnAllEvents: Function

    @virtual @async doWithAnchorUpdateState: Function

    @virtual @async doWithAnchorRestoreState: Function

    @virtual @async doWithAnchorSave: Function

    @virtual registerState: FuncG [String, MaybeG Object], StateInterface

    @virtual removeState: FuncG String, Boolean

    @virtual registerEvent: FuncG [String, UnionG(String, ListG String), String, MaybeG(Object), MaybeG Object], NilT

    @virtual @async reset: Function

    @virtual @async send: FuncG String, NilT

    @virtual @async transitionTo: FuncG [StateInterface, TransitionInterface], NilT

    @virtual beforeAllEvents: FuncG String, NilT

    @virtual afterAllTransitions: FuncG String, NilT

    @virtual afterAllEvents: FuncG String, NilT

    @virtual errorOnAllEvents: FuncG String, NilT

    @virtual withAnchorUpdateState: FuncG String, NilT

    @virtual withAnchorSave: FuncG String, NilT

    @virtual withAnchorRestoreState: FuncG String, NilT

    @virtual state: FuncG [String, MaybeG Object], NilT

    @virtual event: FuncG [String, UnionG(Object, Function), MaybeG Function], NilT

    @virtual transition: FuncG [ListG(String), String, MaybeG Object], NilT


    @initialize()
