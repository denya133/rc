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
    PRODUCTION
    CACHE
    SOFT
    Generic
    Utils: {
      _
      # uuid
      t: { assert }
      getTypeName
      valueIsType
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'IntersectionG', (Types...) ->
    if Module.environment isnt PRODUCTION
      assert Types.length > 0, 'IntersectionG must be call with Array or many arguments'
    if Types.length is 1
      Types = Types[0]
    if Module.environment isnt PRODUCTION
      assert _.isArray(Types) and Types.length >= 2, "Invalid argument Types #{assert.stringify Types} supplied to IntersectionG(Types) (expected an array of at least 2 types)"
    # _ids = []
    Types = Types.map (Type)->
      t = Module::AccordG Type
      # unless (id = CACHE.get t)?
      #   id = uuid.v4()
      #   CACHE.set t, id
      # _ids.push id
      # t
    # IntersectionID = _ids.join()
    if Module.environment isnt PRODUCTION
      assert Types.every(_.isFunction), "Invalid argument Types #{assert.stringify Types} supplied to IntersectionG(Types) (expected an array of functions)"

    displayName = Types.map(getTypeName).join ' & '

    IntersectionID = Types.map((T)-> T.ID).join ' & '

    if (cachedType = typesCache.get IntersectionID)?
      return cachedType

    Intersection = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Intersection.isNotSample @
      if Intersection.has value
        return value
      path ?= [Intersection.displayName]
      assert Intersection.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      Intersection.keep value
      return value

    # Reflect.defineProperty Intersection, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Intersection, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty Intersection, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: IntersectionID

    Module::SOFT_CACHE.set IntersectionID, new Set

    Reflect.defineProperty Intersection, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(IntersectionID).has value

    Reflect.defineProperty Intersection, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(IntersectionID).add value

    Reflect.defineProperty Intersection, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Intersection, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Intersection, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        if Intersection.has x
          return yes
        result = Types.every (type)-> valueIsType x, type
        if result
          Intersection.keep x
        return result

    Reflect.defineProperty Intersection, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'intersection'
        types: Types
        name: Intersection.displayName
        identity: yes
      }

    Reflect.defineProperty Intersection, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Intersection

    typesCache.set IntersectionID, Intersection
    CACHE.set Intersection, IntersectionID

    Intersection
