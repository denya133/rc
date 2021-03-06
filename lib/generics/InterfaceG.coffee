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
    CoreObject
    Generic
    Utils: {
      _
      # uuid
      t: { assert }
      getTypeName
      createByType
      valueIsType
      instanceOf
    }
  } = Module::

  # typesDict = new Map()
  typesCache = new Map()

  Module.defineGeneric Generic 'InterfaceG', (props) ->
    if Module.environment isnt PRODUCTION
      assert Module::DictG(String, Function).is(props), "Invalid argument props #{assert.stringify props} supplied to InterfaceG(props) (expected a dictionary String -> Type)"

    # _ids = []
    new_props = {}
    for own k, ValueType of props
      t = Module::AccordG ValueType
      # unless (id = CACHE.get k)?
      #   id = uuid.v4()
      #   CACHE.set k, id
      # _ids.push id
      # unless (id = CACHE.get t)?
      #   id = uuid.v4()
      #   CACHE.set t, id
      # _ids.push id
      new_props[k] = t
    # InterfaceID = _ids.join()

    props = new_props

    displayName = "Interface{#{(
      for own k, T of props
        "#{k}: #{getTypeName T}"
    ).join ', '}}"

    InterfaceID = "Interface{#{(
      for own k, T of props
        "#{k}: #{T.ID}"
    ).join ', '}}"

    if (cachedType = typesCache.get InterfaceID)?
      return cachedType

    Interface = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Interface.isNotSample @
      if Interface.has value
        return value
      path ?= [Interface.displayName]
      assert value?, "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      if instanceOf(value, CoreObject) and value.constructor.isSupersetOf props
        Interface.keep value
        return value
      for own k, expected of props
        actual = value[k]
        createByType expected, actual, path.concat "#{k}: #{getTypeName expected}"
      Interface.keep value
      return value

    # Reflect.defineProperty Interface, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Interface, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty Interface, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: InterfaceID

    Module::WEAK_CACHE.set InterfaceID, new WeakSet

    Reflect.defineProperty Interface, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(InterfaceID).has value

    Reflect.defineProperty Interface, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(InterfaceID).add value

    Reflect.defineProperty Interface, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Interface, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Interface, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        return no unless x?
        if Interface.has x
          return yes
        if instanceOf(x, CoreObject) and x.constructor.isSupersetOf props
          Interface.keep x
          return yes
        for own k, v of props
          return no unless valueIsType x[k], v
        Interface.keep x
        return yes

    Reflect.defineProperty Interface, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'interface'
        props: props
        name: Interface.displayName
        identity: yes
        strict: no
      }

    Reflect.defineProperty Interface, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Interface

    typesCache.set InterfaceID, Interface
    CACHE.set Interface, InterfaceID

    Interface
