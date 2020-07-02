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

# здесь должна быть синхронная реализация Промиса. А в ноде будет использоваться нативный класс с тем же интерфейсом.
# внутри этой реализации надо в приватное свойство положить синхронный промис с предпроверкой (если нативный определен - то должен быть положен нативный)

module.exports = (RC)->
  {
    isArangoDB
  } = RC::
  isArango = isArangoDB()

  if isArango
    RC::Promise = require 'promise-polyfill'
    RC::Promise.new = (args...) -> Reflect.construct RC::Promise, args

    RC::Promise._immediateFn = (fn) -> fn()

    RC::Promise._unhandledRejectionFn = ->
  else
    class RC::Promise extends global.Promise
      @new: (args...) -> Reflect.construct RC::Promise, args

  RC::Promise
