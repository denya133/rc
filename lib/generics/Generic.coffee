

module.exports = (Module)->
  {
    PRODUCTION
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
