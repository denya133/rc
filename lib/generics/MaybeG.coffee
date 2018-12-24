

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
      createByType
      valueIsType
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'MaybeG', (Type) ->
    Type = Module::AccordG Type ? Module::AnyT
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to MaybeG(Type) (expected a function)"

    displayName = "?(#{getTypeName Type})"

    MaybeID = "?(#{Type.ID})"

    if (cachedType = typesCache.get MaybeID)?
      return cachedType

    Maybe = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Maybe.isNotSample @
      if Type is Module::AnyT
        return value
      if Maybe.has value
        return value
      path ?= [Maybe.displayName]
      if Module::NilT.is value
        return value
      createByType Type, value, path
      Maybe.keep value
      return value

    # Reflect.defineProperty Maybe, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Maybe, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty Maybe, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: MaybeID

    Module::SOFT_CACHE.set MaybeID, new Set

    Reflect.defineProperty Maybe, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(MaybeID).has value

    Reflect.defineProperty Maybe, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(MaybeID).add value

    Reflect.defineProperty Maybe, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Maybe, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Maybe, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)-> Module::NilT.is(x) or valueIsType x, Type

    Reflect.defineProperty Maybe, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'maybe'
        type: Type
        name: Maybe.displayName
        identity: yes
      }

    Reflect.defineProperty Maybe, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Maybe

    typesCache.set MaybeID, Maybe
    CACHE.set Maybe, MaybeID

    Maybe
