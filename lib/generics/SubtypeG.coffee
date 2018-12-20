

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    Generic
    Utils: {
      _
      uuid
      t: { assert }
      getTypeName
      createByType
      valueIsType
    }
  } = Module::

  # typesDict = new Map()
  typesCache = new Map()

  Module.defineGeneric Generic 'SubtypeG', (Type, name, predicate) ->
    Type = Module::AccordG Type
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to SubtypeG(Type, name, predicate) (expected a function)"
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to SubtypeG(Type, name, predicate) (expected a string)"
      assert _.isFunction(predicate), "Invalid argument predicate #{assert.stringify predicate} supplied to SubtypeG(Type, name, predicate) (expected a function)"

    displayName = "{#{getTypeName Type} | #{name}}"

    _ids = []
    unless (id = CACHE.get Type)?
      id = uuid.v4()
      CACHE.set Type, id
    _ids.push id
    unless (id = CACHE.get name)?
      id = uuid.v4()
      CACHE.set name, id
    _ids.push id
    # unless (id = CACHE.get predicate)?
    #   id = uuid.v4()
    #   CACHE.set predicate, id
    # _ids.push id
    SubtypeID = _ids.join()

    if (cachedType = typesCache.get SubtypeID)?
      return cachedType

    Subtype = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Subtype.isNotSample @
      if Subtype.cache.has value
        return value
      path ?= [Subtype.displayName]
      x = createByType Type, value, path
      assert Subtype.is(x), "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      Subtype.cache.add value
      return value

    Reflect.defineProperty Subtype, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

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

    typesCache.set SubtypeID, Subtype

    Subtype
