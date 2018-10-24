

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

  Module.defineGeneric Generic 'InterfaceG', (props) ->
    if Module.environment isnt PRODUCTION
      assert Module::DictG(String, Function).is(props), "Invalid argument props #{assert.stringify props} supplied to InterfaceG(props) (expected a dictionary String -> Type)"

    new_props = {}
    for own k, ValueType of props
      new_props[k] = Module::AccordG ValueType

    props = new_props

    displayName = "{#{(
      for own k, v of props
        "#{k}: #{getTypeName v}"
    ).join ', '}}"

    if (cachedType = cache.get displayName)?
      return cachedType

    Interface = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Interface.isNotSample @
      path ?= [Interface.displayName]
      assert value?, "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      for own k, expected of props
        actual = value[k]
        createByType expected, actual, path.concat "#{k}: #{getTypeName expected}"
      return value

    Reflect.defineProperty Interface, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Interface, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Interface, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        return no unless x?
        for own k, v of props
          return no unless t.is x[k], v
        return yes

    Reflect.defineProperty Interface, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'interface'
        props: props
        name: Interface.displayName
        identity: yes
        strict: no
      }

    Reflect.defineProperty Interface, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Interface

    cache.set displayName, Interface

    Interface
