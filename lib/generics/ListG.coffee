

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
      createByType
      valueIsType
    }
  } = Module::

  # cache = new Map()

  Module.defineGeneric Generic 'ListG', (Type) ->
    Type = Module::AccordG Type
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to ListG(Type) (expected a function)"

    typeNameCache = getTypeName Type
    displayName = "Array< #{typeNameCache} >"

    # if (cachedType = cache.get displayName)?
    #   return cachedType

    List = (value, path)->
      if Module.environment is PRODUCTION
        return value
      List.isNotSample @
      path ?= [List.displayName]
      assert _.isArray(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an array of #{typeNameCache})"
      for actual, i in value
        createByType Type, actual, path.concat "#{i}: #{typeNameCache}"
      return value

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

    # cache.set displayName, List

    List
