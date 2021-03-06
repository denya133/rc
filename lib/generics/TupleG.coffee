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
    WEAK
    Generic
    Utils: {
      _
      # uuid
      t: { assert }
      getTypeName
      createByType
      valueIsType
    }
  } = Module::

  # typesDict = new Map()
  typesCache = new Map()

  Module.defineGeneric Generic 'TupleG', (Types...) ->
    if Module.environment isnt PRODUCTION
      assert Types.length > 0, 'TupleG must be call with Array or many arguments'
      if Types.length is 1
        Types = Types[0]
      assert _.isArray(Types), "Invalid argument Types #{assert.stringify Types} supplied to TupleG(Types) (expected an array)"
    # _ids = []
    Types = Types.map (Type)->
      t = Module::AccordG Type
      # unless (id = CACHE.get t)?
      #   id = uuid.v4()
      #   CACHE.set t, id
      # _ids.push id
      # t
    # TupleID = _ids.join()
    if Module.environment isnt PRODUCTION
      assert Types.every(_.isFunction), "Invalid argument Types #{assert.stringify Types} supplied to TupleG(Types) (expected an array of functions)"

    displayName = "[#{Types.map(getTypeName).join ', '}]"

    TupleID = "[#{Types.map((T)-> T.ID).join ', '}]"

    if (cachedType = typesCache.get TupleID)?
      return cachedType

    Tuple = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Tuple.isNotSample @
      if Tuple.has value
        return value
      path ?= [Tuple.displayName]
      assert _.isArray(value) and value.length is Types.length, "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an array of length #{Types.length})"
      for Type, i in Types
        actual = value[i]
        createByType Type, actual, path.concat "#{i}: #{getTypeName Type}"
      Tuple.keep value
      return value

    # Reflect.defineProperty Tuple, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Tuple, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty Tuple, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: TupleID

    Module::WEAK_CACHE.set TupleID, new WeakSet

    Reflect.defineProperty Tuple, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(TupleID).has value

    Reflect.defineProperty Tuple, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(TupleID).add value

    Reflect.defineProperty Tuple, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Tuple, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Tuple, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        if Tuple.has x
          return yes
        result = _.isArray(x) and x.length is Types.length and Types.every (e, i)->
          valueIsType x[i], e
        if result
          Tuple.keep x
        return result

    Reflect.defineProperty Tuple, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'tuple'
        types: Types
        name: Tuple.displayName
        identity: yes
      }

    Reflect.defineProperty Tuple, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Tuple

    typesCache.set TupleID, Tuple
    CACHE.set Tuple, TupleID

    Tuple
