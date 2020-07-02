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

# Основное назначение словаря - объявить тип такой структуры, в которой все значения строго одного типа. А struct генерик нужено использовать в тех случаях, когда надо объявить тип для структуры, в которой должны быть определенные имена ключей с определенными (не одинаковыми) типами значений.

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

  typesCache = new Map()

  Module.defineGeneric Generic 'DictG', (KeyType, ValueType) ->
    KeyType = Module::AccordG KeyType
    ValueType = Module::AccordG ValueType
    if Module.environment isnt PRODUCTION
      assert _.isFunction(KeyType), "Invalid argument KeyType #{assert.stringify KeyType} supplied to DictG(KeyType, ValueType) (expected a function)"
      assert _.isFunction(ValueType), "Invalid argument ValueType #{assert.stringify ValueType} supplied to DictG(KeyType, ValueType) (expected a function)"

    keyTypeNameCache = getTypeName KeyType
    valueTypeNameCache = getTypeName ValueType
    displayName = "{[key: #{keyTypeNameCache}]: #{valueTypeNameCache}}"

    DictID = "{[key: #{KeyType.ID}]: #{ValueType.ID}}"

    # _ids = []
    # unless (id = CACHE.get KeyType)?
    #   id = uuid.v4()
    #   CACHE.set KeyType, id
    # _ids.push id
    # unless (id = CACHE.get ValueType)?
    #   id = uuid.v4()
    #   CACHE.set ValueType, id
    # _ids.push id
    # DictID = _ids.join()

    if (cachedType = typesCache.get DictID)?
      return cachedType

    Dict = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Dict.isNotSample @
      if Dict.has value
        return value
      path ?= [Dict.displayName]
      assert _.isPlainObject(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected {[key: #{keyTypeNameCache}]: #{valueTypeNameCache}})"
      if Module::SymbolT is KeyType
        for s in Object.getOwnPropertySymbols(value)
          createByType KeyType, s, path.concat keyTypeNameCache
          v = value[s]
          _k = Symbol.keyFor s
          createByType ValueType, v, path.concat "#{_k}: #{valueTypeNameCache}"
      else
        for own k, v of value
          createByType KeyType, k, path.concat keyTypeNameCache
          createByType ValueType, v, path.concat "#{k}: #{valueTypeNameCache}"
      Dict.keep value
      return value

    # Reflect.defineProperty Dict, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Dict, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty Dict, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: DictID

    Module::WEAK_CACHE.set DictID, new WeakSet

    Reflect.defineProperty Dict, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(DictID).has value

    Reflect.defineProperty Dict, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(DictID).add value

    Reflect.defineProperty Dict, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Dict, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Dict, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        if Dict.has x
          return yes
        result = _.isPlainObject(x) and (
          res = yes
          if Module::SymbolT is KeyType
            for s in Object.getOwnPropertySymbols(x)
              v = x[s]
              res = res and valueIsType(k, KeyType) and valueIsType(v, ValueType)
          else
            for own k, v of x
              res = res and valueIsType(k, KeyType) and valueIsType(v, ValueType)
          res
        )
        if result
          Dict.keep x
        return result

    Reflect.defineProperty Dict, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'dict'
        domain: KeyType
        codomain: ValueType
        name: Dict.displayName
        identity: yes
      }

    Reflect.defineProperty Dict, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Dict

    # unless (subCache = typesCache.get KeyType)?
    #   subCache = new Map()
    #   typesCache.set KeyType, subCache
    # subCache.set ValueType, Dict
    typesCache.set DictID, Dict
    CACHE.set Dict, DictID

    Dict
