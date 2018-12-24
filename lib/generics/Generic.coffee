

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    SOFT
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  Generic = (name, definition) ->
    if Module.environment isnt PRODUCTION
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to Generic(name, definition) (expected a string)"
      assert _.isFunction(definition), "Invalid argument definition #{assert.stringify definition} supplied to Generic(name, definition) (expected a function)"
      assert not(definition instanceof Generic), "Cannot use the new operator to instantiate the type Generic"

    GenericID = name

    Reflect.defineProperty definition, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty definition, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: GenericID

    Reflect.defineProperty definition, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty definition, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty definition, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'generic'
        name: definition.displayName
        identity: yes
      }

    CACHE.set definition, GenericID

    definition

  Reflect.defineProperty Generic, 'name',
    configurable: no
    enumerable: yes
    writable: no
    value: 'Generic'

  Reflect.defineProperty Generic, 'displayName',
    configurable: no
    enumerable: yes
    writable: no
    value: 'Generic'

  Reflect.defineProperty Generic, 'meta',
    configurable: no
    enumerable: yes
    writable: no
    value: {
      kind: 'generic'
      name: 'Generic'
      identity: yes
    }

  Module.defineGeneric Generic
