

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

  # cache = new Map()

  Module.defineGeneric Generic 'SubsetG', (Type) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to SubsetG(Type) (expected a type)"

    displayName = "<< #{getTypeName Type}"
    # if (cachedType = cache.get Type)?
    #   return cachedType

    Subset = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      Subset.isNotSample @
      path ?= [Subset.displayName]
      assert Subset.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a subset of #{getTypeName Type})"
      return value

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
        kind: 'irreducible'
        name: displayName
        predicate: Subset.is
        identity: yes
      }

    Reflect.defineProperty Subset, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Subset

    # cache.set Type, Subset

    Subset
