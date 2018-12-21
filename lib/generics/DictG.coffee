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
      if Dict.cache.has value
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
      Dict.cache.add value
      return value

    Reflect.defineProperty Dict, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

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
        _.isPlainObject(x) and (
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
