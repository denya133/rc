

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

  typesCache = new Map()

  Module.defineGeneric Generic 'MapG', (KeyType, ValueType) ->
    KeyType = Module::AccordG KeyType
    ValueType = Module::AccordG ValueType
    if Module.environment isnt PRODUCTION
      assert _.isFunction(KeyType), "Invalid argument KeyType #{assert.stringify KeyType} supplied to MapG(KeyType, ValueType) (expected a function)"
      assert _.isFunction(ValueType), "Invalid argument ValueType #{assert.stringify ValueType} supplied to MapG(KeyType, ValueType) (expected a function)"

    keyTypeNameCache = getTypeName KeyType
    valueTypeNameCache = getTypeName ValueType
    displayName = "Map< #{keyTypeNameCache}, #{valueTypeNameCache} >"

    if (cachedType = typesCache.get(KeyType)?.get ValueType)?
      return cachedType

    _Map = (value, path)->
      if Module.environment is PRODUCTION
        return value
      _Map.isNotSample @
      path ?= [_Map.displayName]
      assert _.isMap(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an map of [#{keyTypeNameCache}, #{valueTypeNameCache}])"
      value.forEach (v, k)->
        createByType KeyType, k, path.concat keyTypeNameCache
        _k = if _.isSymbol k
          Symbol.keyFor k
        else
          k
        createByType ValueType, v, path.concat "#{_k}: #{valueTypeNameCache}"
      return value

    Reflect.defineProperty _Map, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty _Map, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty _Map, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        _.isMap(x) and (
          res = yes
          x.forEach (v, k)->
            res = res and valueIsType(k, KeyType) and valueIsType(v, ValueType)
          res
        )

    Reflect.defineProperty _Map, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'map'
        domain: KeyType
        codomain: ValueType
        name: _Map.displayName
        identity: yes
      }

    Reflect.defineProperty _Map, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG _Map

    unless (subCache = typesCache.get KeyType)?
      subCache = new Map()
      typesCache.set KeyType, subCache
    subCache.set ValueType, _Map

    _Map
