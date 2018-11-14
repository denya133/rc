# Основное назначение словаря - объявить тип такой структуры, в которой все значения строго одного типа. А struct генерик нужено использовать в тех случаях, когда надо объявить тип для структуры, в которой должны быть определенные имена ключей с определенными (не одинаковыми) типами значений.


module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
      createByType
      valueIsType
    }
  } = Module::

  # cache = new Map()

  Module.defineGeneric Generic 'DictG', (KeyType, ValueType) ->
    KeyType = Module::AccordG KeyType
    ValueType = Module::AccordG ValueType
    if Module.environment isnt PRODUCTION
      assert _.isFunction(KeyType), "Invalid argument KeyType #{assert.stringify KeyType} supplied to DictG(KeyType, ValueType) (expected a function)"
      assert _.isFunction(ValueType), "Invalid argument ValueType #{assert.stringify ValueType} supplied to DictG(KeyType, ValueType) (expected a function)"

    keyTypeNameCache = getTypeName KeyType
    valueTypeNameCache = getTypeName ValueType
    displayName = "{[key: #{keyTypeNameCache}]: #{valueTypeNameCache}}"

    # if (cachedType = cache.get displayName)?
    #   return cachedType

    Dict = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Dict.isNotSample @
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
      return value

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

    # cache.set displayName, Dict

    Dict
