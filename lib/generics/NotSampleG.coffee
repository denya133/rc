

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
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to NotSampleG(Type) (expected a function)"

    typeNameCache = getTypeName Type
    displayName = "!#{typeNameCache}"

    if (cachedType = cache.get Type)?
      return cachedType

    NotSample = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      path ?= [NotSample.displayName]
      assert NotSample.is(value), "Cannot use the new operator to instantiate the type #{path.join '.'}"
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
      value: (x)->
        return yes unless x?
        not switch Type
          when String
            _.isString x
          when Number
            _.isNumber x
          when Boolean
            _.isBoolean x
          when Array
            _.isArray x
          when Object
            _.isPlainObject x
          when Date
            _.isDate x
          else
            do (a = x)->
              while a = a.__proto__
                if a is Type.prototype
                  return yes
              return no

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

    cache.set Type, NotSample

    NotSample
