

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    WEAK
    Generic
    Utils: {
      _
      # uuid
      t: { assert }
      getTypeName
      createByType
      valueIsType
    }
  } = Module::

  # typesDict = new Map()
  typesCache = new Map()

  Module.defineGeneric Generic 'InterfaceG', (props) ->
    if Module.environment isnt PRODUCTION
      assert Module::DictG(String, Function).is(props), "Invalid argument props #{assert.stringify props} supplied to InterfaceG(props) (expected a dictionary String -> Type)"

    # _ids = []
    new_props = {}
    for own k, ValueType of props
      t = Module::AccordG ValueType
      # unless (id = CACHE.get k)?
      #   id = uuid.v4()
      #   CACHE.set k, id
      # _ids.push id
      # unless (id = CACHE.get t)?
      #   id = uuid.v4()
      #   CACHE.set t, id
      # _ids.push id
      new_props[k] = t
    # InterfaceID = _ids.join()

    props = new_props

    displayName = "Interface{#{(
      for own k, T of props
        "#{k}: #{getTypeName T}"
    ).join ', '}}"

    InterfaceID = "Interface{#{(
      for own k, T of props
        "#{k}: #{T.ID}"
    ).join ', '}}"

    if (cachedType = typesCache.get InterfaceID)?
      return cachedType

    Interface = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Interface.isNotSample @
      if Interface.cache.has value
        return value
      path ?= [Interface.displayName]
      assert value?, "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      for own k, expected of props
        actual = value[k]
        createByType expected, actual, path.concat "#{k}: #{getTypeName expected}"
      Interface.cache.add value
      return value

    Reflect.defineProperty Interface, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

    Reflect.defineProperty Interface, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty Interface, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: InterfaceID

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
          return no unless valueIsType x[k], v
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

    typesCache.set InterfaceID, Interface
    CACHE.set Interface, InterfaceID

    Interface
