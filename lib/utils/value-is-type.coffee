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
    PRODUCTION
    CACHE
    Utils: { _, uuid, t: { assert }, instanceOf }
  } = Module::

  resultsCache = new Map()

  Module.util valueIsType: (x, Type)->
    if Module.environment is PRODUCTION
      return yes

    _ids = []
    unless (id = CACHE.get x)?
      id = uuid.v4()
      CACHE.set x, id
    _ids.push id
    unless (id = CACHE.get Type)?
      id = uuid.v4()
      CACHE.set Type, id
    _ids.push id
    ID = _ids.join()
    # ID = id#Type.ID ? uuid.v4()

    if (cachedResult = resultsCache.get ID)?
      return cachedResult

    assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to valueIsType(x, Type) (expected a function)"

    if Module::TypeT.is Type
      result = Type.is x

    else if (nonCustomType = Module::AccordG Type) isnt Type
      result = nonCustomType.is x
    else
      result = instanceOf x, Type

    resultsCache.set ID, result
    return result
