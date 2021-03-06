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

# по задумке это тип всех типов (интерфейсов от AnyT до SymbolT)
# он нужен для того, чтобы при вызове метода можно было проверить аргумент, в качестве которого передан один из существующих типов.

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'TypeT', (x)->
    _.isFunction(x) and _.isPlainObject(x.meta) and x.meta.kind not in [
      'generic', 'class', 'module', 'mixin'
    ]
