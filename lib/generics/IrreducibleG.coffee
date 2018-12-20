

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  Module.defineGeneric Generic 'IrreducibleG', (name, predicate) ->
    if Module.environment isnt PRODUCTION
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to IrreducibleG(name, predicate) (expected a string)"
      assert _.isFunction(predicate), "Invalid argument predicate #{assert.stringify predicate} supplied to IrreducibleG(name, predicate) (expected a function)"

    Irreducible = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      Irreducible.isNotSample @
      if Irreducible.cache.has value
        return value
      path ?= [Irreducible.displayName]
      assert Irreducible.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a #{Irreducible.displayName})"
      Irreducible.cache.add value
      return value

    Reflect.defineProperty Irreducible, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

    Reflect.defineProperty Irreducible, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty Irreducible, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty Irreducible, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: predicate

    Reflect.defineProperty Irreducible, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'irreducible'
        name: Irreducible.displayName
        predicate: Irreducible.is
        identity: yes
      }

    Reflect.defineProperty Irreducible, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Irreducible

    Irreducible
