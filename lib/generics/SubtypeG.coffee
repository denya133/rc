

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    STRONG, WEAK, SOFT, NON
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

  # typesDict = new Map()
  typesCache = new Map()

  Module.defineGeneric Generic 'SubtypeG', (Type, name, predicate, cacheStrategy) ->
    Type = Module::AccordG Type
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to SubtypeG(Type, name, predicate) (expected a function)"
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to SubtypeG(Type, name, predicate) (expected a string)"
      assert _.isFunction(predicate), "Invalid argument predicate #{assert.stringify predicate} supplied to SubtypeG(Type, name, predicate) (expected a function)"

    displayName = "{#{getTypeName Type} | #{name}}"

    SubtypeID = "{#{Type.ID} | #{name}}"

    # _ids = []
    # unless (id = CACHE.get Type)?
    #   id = uuid.v4()
    #   CACHE.set Type, id
    # _ids.push id
    # unless (id = CACHE.get name)?
    #   id = uuid.v4()
    #   CACHE.set name, id
    # _ids.push id
    # # unless (id = CACHE.get predicate)?
    # #   id = uuid.v4()
    # #   CACHE.set predicate, id
    # # _ids.push id
    # SubtypeID = _ids.join()

    # if (cachedType = typesCache.get SubtypeID)?
    #   return cachedType
    if (cachedType = typesCache.get SubtypeID)?
      return cachedType

    Subtype = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Subtype.isNotSample @
      if Subtype.has value
        return value
      path ?= [Subtype.displayName]
      x = createByType Type, value, path
      assert Subtype.is(x), "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      Subtype.keep value
      return value

    # Reflect.defineProperty Subtype, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Subtype, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: cacheStrategy ? Type.cacheStrategy

    Reflect.defineProperty Subtype, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: SubtypeID

    switch Subtype.cacheStrategy
      when STRONG
        unless Module::STRONG_CACHE.has SubtypeID
          Module::STRONG_CACHE.set SubtypeID, new Set
      when WEAK
        Module::WEAK_CACHE.set SubtypeID, new WeakSet
      when SOFT
        Module::SOFT_CACHE.set SubtypeID, new Set

    Reflect.defineProperty Subtype, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: do ->
        switch Subtype.cacheStrategy
          when STRONG
            (value)-> Module::STRONG_CACHE.get(SubtypeID).has value
          when WEAK
            (value)-> Module::WEAK_CACHE.get(SubtypeID).has value
          when SOFT
            (value)-> Module::SOFT_CACHE.get(SubtypeID).has value
          else
            -> no

    Reflect.defineProperty Subtype, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: do ->
        switch Subtype.cacheStrategy
          when STRONG
            (value)-> Module::STRONG_CACHE.get(SubtypeID).add value
          when WEAK
            (value)-> Module::WEAK_CACHE.get(SubtypeID).add value
          when SOFT
            (value)-> Module::SOFT_CACHE.get(SubtypeID).add value
          else
            ->

    Reflect.defineProperty Subtype, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty Subtype, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Subtype, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)-> valueIsType(x, Type) and predicate(x)

    Reflect.defineProperty Subtype, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'subtype'
        type: Type
        name: Subtype.displayName
        predicate: predicate
        identity: yes
      }

    Reflect.defineProperty Subtype, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Subtype

    # typesCache.set SubtypeID, Subtype
    typesCache.set SubtypeID, Subtype
    CACHE.set Subtype, SubtypeID

    Subtype
