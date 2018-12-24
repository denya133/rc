

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

  Module.defineGeneric Generic 'ListG', (Type) ->
    Type = Module::AccordG Type
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to ListG(Type) (expected a function)"

    typeNameCache = getTypeName Type
    displayName = "Array< #{typeNameCache} >"

    ListID = "Array< #{Type.ID} >"

    if (cachedType = typesCache.get ListID)?
      return cachedType

    List = (value, path)->
      if Module.environment is PRODUCTION
        return value
      List.isNotSample @
      if List.has value
        return value
      path ?= [List.displayName]
      assert _.isArray(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an array of #{typeNameCache})"
      for actual, i in value
        createByType Type, actual, path.concat "#{i}: #{typeNameCache}"
      List.keep value
      return value

    # Reflect.defineProperty List, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty List, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty List, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: ListID

    Module::WEAK_CACHE.set ListID, new WeakSet

    Reflect.defineProperty List, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(ListID).has value

    Reflect.defineProperty List, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::WEAK_CACHE.get(ListID).add value

    Reflect.defineProperty List, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty List, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty List, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        _.isArray(x) and x.length isnt 0 and x.every (e)-> valueIsType e, Type

    Reflect.defineProperty List, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'list'
        type: Type
        name: List.displayName
        identity: yes
      }

    Reflect.defineProperty List, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG List

    typesCache.set ListID, List
    CACHE.set List, ListID

    List
