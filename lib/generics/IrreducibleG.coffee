

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    STRONG, WEAK, SOFT, NON
    Generic
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  Module.defineGeneric Generic 'IrreducibleG', (name, predicate, cacheStrategy = SOFT) ->
    if Module.environment isnt PRODUCTION
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to IrreducibleG(name, predicate) (expected a string)"
      assert _.isFunction(predicate), "Invalid argument predicate #{assert.stringify predicate} supplied to IrreducibleG(name, predicate) (expected a function)"

    Irreducible = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      Irreducible.isNotSample @
      if Irreducible.has value
        return value
      path ?= [Irreducible.displayName]
      assert Irreducible.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a #{Irreducible.displayName})"
      Irreducible.keep value
      return value

    # Reflect.defineProperty Irreducible, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Irreducible, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: cacheStrategy

    Reflect.defineProperty Irreducible, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    switch Irreducible.cacheStrategy
      when STRONG
        unless Module::STRONG_CACHE.has name
          Module::STRONG_CACHE.set name, new Set
      when WEAK
        Module::WEAK_CACHE.set name, new WeakSet
      when SOFT
        Module::SOFT_CACHE.set name, new Set

    Reflect.defineProperty Irreducible, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: do ->
        switch Irreducible.cacheStrategy
          when STRONG
            (value)-> Module::STRONG_CACHE.get(name).has value
          when WEAK
            (value)-> Module::WEAK_CACHE.get(name).has value
          when SOFT
            (value)-> Module::SOFT_CACHE.get(name).has value
          else
            -> no

    Reflect.defineProperty Irreducible, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: do ->
        switch Irreducible.cacheStrategy
          when STRONG
            (value)-> Module::STRONG_CACHE.get(name).add value
          when WEAK
            (value)-> Module::WEAK_CACHE.get(name).add value
          when SOFT
            (value)-> Module::SOFT_CACHE.get(name).add value
          else
            ->

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

    CACHE.set Irreducible, name

    Irreducible
