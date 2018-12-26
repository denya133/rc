

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    SOFT
    Generic
    Utils: {
      _
      uuid
      t: { assert }
      getTypeName
      instanceOf
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'NotSampleG', (Type) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to NotSampleG(Type) (expected a function)"

    typeNameCache = getTypeName Type
    displayName = "!#{typeNameCache}"

    NotSampleID = uuid.v4()#"!#{Type.ID ? String Type}"

    if (cachedType = typesCache.get Type)?
      return cachedType

    NotSample = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      if NotSample.has value
        return value
      path ?= [NotSample.displayName]
      assert NotSample.is(value), "Cannot use the new operator to instantiate the type #{path.join '.'}"
      NotSample.keep value
      return value

    # Reflect.defineProperty NotSample, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty NotSample, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty NotSample, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: NotSampleID

    Module::SOFT_CACHE.set NotSampleID, new Set

    Reflect.defineProperty NotSample, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(NotSampleID).has value

    Reflect.defineProperty NotSample, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(NotSampleID).add value

    Reflect.defineProperty NotSample, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty NotSample, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty NotSample, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)-> not instanceOf x, Type

    Reflect.defineProperty NotSample, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'not-sample'
        type: Type
        name: NotSample.displayName
        predicate: NotSample.is
        identity: yes
      }

    typesCache.set Type, NotSample
    CACHE.set NotSample, NotSampleID

    NotSample
