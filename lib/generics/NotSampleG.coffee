

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
    }
  } = Module::

  cache = new Map()

  Module.defineGeneric Generic 'NotSampleG', (Type) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), -> "Invalid argument Type #{assert.stringify Type} supplied to NotSampleG(Type) (expected a function)"

    typeNameCache = getTypeName Type
    displayName = "!#{typeNameCache}"

    if (cachedType = cache.get displayName)?
      return cachedType

    NotSample = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      path ?= [NotSample.displayName]
      assert NotSample.is(value), -> "Cannot use the new operator to instantiate the type #{path.join '.'}"
      return value

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
      value: (x)-> not(x instanceof Type)

    Reflect.defineProperty NotSample, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'irreducible'
        name: NotSample.displayName
        predicate: NotSample.is
        identity: yes
      }

    cache.set displayName, NotSample

    NotSample
