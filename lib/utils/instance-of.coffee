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

module.exports = (Module) ->
  {
    Utils: { _ }
  } = Module::

  Module.util instanceOf: (x, Type)->
    return no unless x?
    switch Type
      when String
        _.isString x
      when Number
        _.isNumber x
      when Boolean
        _.isBoolean x
      when Array
        _.isArray x
      when Object
        _.isPlainObject x
      when Date
        _.isDate x
      else
        do (a = x)->
          while a = a.__proto__
            if a is Type.prototype
              return yes
          return no
