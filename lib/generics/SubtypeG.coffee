

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t
      getTypeName
      createByType
    }
  } = Module::

  { assert } = t

  cache = new Map()

  Module.defineGeneric Generic 'SubtypeG', (Type, name, predicate) ->
    Type = Module::AccordG Type
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to SubtypeG(Type, name, predicate) (expected a function)"
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to SubtypeG(Type, name, predicate) (expected a string)"
      assert _.isFunction(predicate), "Invalid argument predicate #{assert.stringify predicate} supplied to SubtypeG(Type, name, predicate) (expected a function)"

    displayName = "{#{getTypeName Type} | #{name}}"

    if (cachedType = cache.get displayName)?
      return cachedType

    Subtype = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Subtype.isNotSample @
      path ?= [Subtype.displayName]
      x = createByType Type, value, path
      assert Subtype.is(x), "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      return value

    Reflect.defineProperty Subtype, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Subtype

    Reflect.defineProperty Subtype, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty Subtype, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Subtype, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)-> t.is(x, Type) and predicate(x)

    Reflect.defineProperty Subtype, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'subtype'
        type: Type
        name: Subtype.displayName
        predicate: predicate
        identity: yes
      }

    cache.set displayName, Subtype

    Subtype
