

module.exports = (Module)->
  {
    PRODUCTION
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
    if (cachedType = typesCache.get Type)?
      return cachedType

    Subset = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      # Subset.isNotSample @
      if Subset.cache.has value
        return value
      path ?= [Subset.displayName]
      assert Subset.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a subset of #{getTypeName Type})"
      Subset.cache.add value
      return value

    Reflect.defineProperty Subset, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

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
      value: (x)-> isSubsetOf x, Type

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

    # Reflect.defineProperty Subset, 'isNotSample',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: Module::NotSampleG Subset

    typesCache.set Type, Subset

    Subset
