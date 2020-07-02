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
      t: { assert }
      getTypeName
      createByType
      valueIsType
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'ListG', (Type) ->
    Type = Module::AccordG Type
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to ListG(Type) (expected a function)"

    typeNameCache = getTypeName Type
    displayName = "Array< #{typeNameCache} >"

    ListID = "Array< #{Type.ID} >"

    if (cachedType = typesCache.get ListID)?
      return cachedType

    List = (value, path)->
      if Module.environment is PRODUCTION
        return value
      List.isNotSample @
      if List.has value
        return value
      path ?= [List.displayName]
      assert _.isArray(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an array of #{typeNameCache})"
      for actual, i in value
        createByType Type, actual, path.concat "#{i}: #{typeNameCache}"
      List.keep value
      return value

    # Reflect.defineProperty List, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty List, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty List, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: ListID

    Module::WEAK_CACHE.set ListID, new WeakSet

    Reflect.defineProperty List, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(ListID).has value

    Reflect.defineProperty List, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(ListID).add value

    Reflect.defineProperty List, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty List, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty List, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        if List.has x
          return yes
        result = _.isArray(x) and x.length isnt 0 and x.every (e)-> valueIsType e, Type
        if result
          List.keep x
        return result

    Reflect.defineProperty List, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'list'
        type: Type
        name: List.displayName
        identity: yes
      }

    Reflect.defineProperty List, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG List

    typesCache.set ListID, List
    CACHE.set List, ListID

    List
