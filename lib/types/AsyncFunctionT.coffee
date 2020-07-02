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

# этот тип нужен для описания асинхронной функции - созданной через async funcName() {}
# возможно нужно так же создать AsyncFuncG чтобы более подробно указывать типы аргументов и тип выходного значения в then который будет.
# для проверки нужно заиспользовать Object.getPrototypeOf(async function(){}).constructor
# НО используемая версия ноды 6.10 не поддерживает async/await, поддержка начинается с 7.6 - поэтому пока что этот тип остается не реализованным.

module.exports = (Module)->
  {
    NON
    SubtypeG
    FunctionT
  } = Module::

  Module.defineType SubtypeG FunctionT, 'AsyncFunctionT', (x)->
    # NOTE: только функции созданные через co.wrap пока что являются асинковыми
    x.__generatorFunction__?
  , NON
