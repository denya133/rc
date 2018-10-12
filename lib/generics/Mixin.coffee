

module.exports = (Module)->
  {
    PRODUCTION
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  Mixin = (name, definition) ->
    if Module.environment isnt PRODUCTION
      assert _.isString(name), -> "Invalid argument name #{assert.stringify name} supplied to Mixin(name, definition) (expected a string)"
      assert _.isFunction(definition), -> "Invalid argument definition #{assert.stringify definition} supplied to Mixin(name, definition) (expected a function)"
      assert not(definition instanceof Mixin), -> "Cannot use the new operator to instantiate the type Mixin"

    Reflect.defineProperty definition, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty definition, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: definition.name

    Reflect.defineProperty definition, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'mixin'
        name: definition.name
        identity: yes
      }

    definition

  Reflect.defineProperty Mixin, 'name',
    configurable: no
    enumerable: yes
    writable: no
    value: 'Mixin'

  Reflect.defineProperty Mixin, 'displayName',
    configurable: no
    enumerable: yes
    writable: no
    value: 'Mixin'

  Reflect.defineProperty Mixin, 'meta',
    configurable: no
    enumerable: yes
    writable: no
    value: {
      kind: 'generic'
      name: 'Mixin'
      identity: yes
    }

  Module.defineGeneric Mixin
