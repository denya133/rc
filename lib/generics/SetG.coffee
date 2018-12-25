

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

  Module.defineGeneric Generic 'SetG', (Type) ->
    Type = Module::AccordG Type
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to SetG(Type) (expected a function)"

    typeNameCache = getTypeName Type
    displayName = "Set< #{typeNameCache} >"

    SetID = "Set< #{Type.ID} >"

    if (cachedType = typesCache.get SetID)?
      return cachedType

    _Set = (value, path)->
      if Module.environment is PRODUCTION
        return value
      _Set.isNotSample @
      if _Set.has value
        return value
      path ?= [_Set.displayName]
      assert _.isSet(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an set of #{typeNameCache})"
      value.forEach (actual, i)->
        createByType Type, actual, path.concat "#{i}: #{typeNameCache}"
      _Set.keep value
      return value

    # Reflect.defineProperty _Set, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty _Set, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty _Set, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: SetID

    Module::WEAK_CACHE.set SetID, new WeakSet

    Reflect.defineProperty _Set, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(SetID).has value

    Reflect.defineProperty _Set, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(SetID).add value

    Reflect.defineProperty _Set, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty _Set, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty _Set, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        if _Set.has x
          return yes
        result = _.isSet(x) and (
          res = yes
          x.forEach (e)->
            res = res and valueIsType e, Type
          res
        )
        if result
          _Set.keep x
        return result

    Reflect.defineProperty _Set, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'set'
        type: Type
        name: _Set.displayName
        identity: yes
      }

    Reflect.defineProperty _Set, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG _Set

    typesCache.set SetID, _Set
    CACHE.set _Set, SetID

    _Set
