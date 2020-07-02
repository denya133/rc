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
    FuncG, DictG, MaybeG
    EventInterface
    TransitionInterface
    StateMachineInterface
    HookedObjectInterface
    StateInterface: StateInterfaceDefinition
  } = Module::

  class StateInterface extends HookedObjectInterface
    @inheritProtected()
    @module Module

    @virtual getEvents: FuncG [], DictG String, EventInterface

    @virtual initial: Boolean

    @virtual getEvent: FuncG String, MaybeG EventInterface

    @virtual defineTransition: FuncG [String, StateInterfaceDefinition, TransitionInterface, MaybeG Object], EventInterface

    @virtual removeTransition: FuncG String, NilT

    @virtual @async doBeforeEnter: Function

    @virtual @async doEnter: Function

    @virtual @async doAfterEnter: Function

    @virtual @async doBeforeExit: Function

    @virtual @async doExit: Function

    @virtual @async doAfterExit: Function

    @virtual @async send: FuncG String, NilT


    @initialize()
