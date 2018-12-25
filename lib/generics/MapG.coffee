

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

  Module.defineGeneric Generic 'MapG', (KeyType, ValueType) ->
    KeyType = Module::AccordG KeyType
    ValueType = Module::AccordG ValueType
    if Module.environment isnt PRODUCTION
      assert _.isFunction(KeyType), "Invalid argument KeyType #{assert.stringify KeyType} supplied to MapG(KeyType, ValueType) (expected a function)"
      assert _.isFunction(ValueType), "Invalid argument ValueType #{assert.stringify ValueType} supplied to MapG(KeyType, ValueType) (expected a function)"

    keyTypeNameCache = getTypeName KeyType
    valueTypeNameCache = getTypeName ValueType
    displayName = "Map< #{keyTypeNameCache}, #{valueTypeNameCache} >"

    MapID = "Map< #{KeyType.ID}, #{ValueType.ID} >"

    # _ids = []
    # unless (id = CACHE.get KeyType)?
    #   id = uuid.v4()
    #   CACHE.set KeyType, id
    # _ids.push id
    # unless (id = CACHE.get ValueType)?
    #   id = uuid.v4()
    #   CACHE.set ValueType, id
    # _ids.push id
    # MapID = _ids.join()

    if (cachedType = typesCache.get MapID)?
      return cachedType

    _Map = (value, path)->
      if Module.environment is PRODUCTION
        return value
      _Map.isNotSample @
      if _Map.has value
        return value
      path ?= [_Map.displayName]
      assert _.isMap(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an map of [#{keyTypeNameCache}, #{valueTypeNameCache}])"
      value.forEach (v, k)->
        createByType KeyType, k, path.concat keyTypeNameCache
        _k = if _.isSymbol k
          Symbol.keyFor k
        else
          k
        createByType ValueType, v, path.concat "#{_k}: #{valueTypeNameCache}"
      _Map.keep value
      return value

    # Reflect.defineProperty _Map, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty _Map, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty _Map, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: MapID

    Module::WEAK_CACHE.set MapID, new WeakSet

    Reflect.defineProperty _Map, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(MapID).has value

    Reflect.defineProperty _Map, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(MapID).add value

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
        if _Map.has x
          return yes
        result = _.isMap(x) and (
          res = yes
          x.forEach (v, k)->
            res = res and valueIsType(k, KeyType) and valueIsType(v, ValueType)
          res
        )
        if result
          _Map.keep x
        return result

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

    # unless (subCache = typesCache.get KeyType)?
    #   subCache = new Map()
    #   typesCache.set KeyType, subCache
    # subCache.set ValueType, _Map
    typesCache.set MapID, _Map
    CACHE.set _Map, MapID

    _Map
