

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    SOFT
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
      isSubsetOf
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'SubsetG', (Type) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to SubsetG(Type) (expected a type)"

    displayName = "<< #{getTypeName Type}"

    SubsetID = "<< #{Type.ID}"

    if (cachedType = typesCache.get SubsetID)?
      return cachedType

    Subset = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      Subset.isNotSample @
      if Subset.has value
        return value
      path ?= [Subset.displayName]
      assert Subset.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a subset of #{getTypeName Type})"
      Subset.keep value
      return value

    # Reflect.defineProperty Subset, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Subset, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty Subset, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: SubsetID

    Module::SOFT_CACHE.set SubsetID, new Set

    Reflect.defineProperty Subset, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(SubsetID).has value

    Reflect.defineProperty Subset, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(SubsetID).add value

    Reflect.defineProperty Subset, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Subset, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Subset, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        if Subset.has x
          return yes
        result = isSubsetOf x, Type
        if result
          Subset.keep x
        return result

    Reflect.defineProperty Subset, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'subset'
        type: Type
        name: displayName
        predicate: Subset.is
        identity: yes
      }

    Reflect.defineProperty Subset, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Subset

    typesCache.set SubsetID, Subset
    CACHE.set Subset, SubsetID

    Subset
