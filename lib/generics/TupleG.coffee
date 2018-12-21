

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

  Module.defineGeneric Generic 'TupleG', (Types...) ->
    if Module.environment isnt PRODUCTION
      assert Types.length > 0, 'TupleG must be call with Array or many arguments'
      if Types.length is 1
        Types = Types[0]
      assert _.isArray(Types), "Invalid argument Types #{assert.stringify Types} supplied to TupleG(Types) (expected an array)"
    # _ids = []
    Types = Types.map (Type)->
      t = Module::AccordG Type
      # unless (id = CACHE.get t)?
      #   id = uuid.v4()
      #   CACHE.set t, id
      # _ids.push id
      # t
    # TupleID = _ids.join()
    if Module.environment isnt PRODUCTION
      assert Types.every(_.isFunction), "Invalid argument Types #{assert.stringify Types} supplied to TupleG(Types) (expected an array of functions)"

    displayName = "[#{Types.map(getTypeName).join ', '}]"

    TupleID = "[#{Types.map((T)-> T.ID).join ', '}]"

    if (cachedType = typesCache.get TupleID)?
      return cachedType

    Tuple = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Tuple.isNotSample @
      if Tuple.cache.has value
        return value
      path ?= [Tuple.displayName]
      assert _.isArray(value) and value.length is Types.length, "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected an array of length #{Types.length})"
      for Type, i in Types
        actual = value[i]
        createByType Type, actual, path.concat "#{i}: #{getTypeName Type}"
      Tuple.cache.add value
      return value

    Reflect.defineProperty Tuple, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

    Reflect.defineProperty Tuple, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty Tuple, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: TupleID

    Reflect.defineProperty Tuple, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Tuple, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Tuple, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        _.isArray(x) and x.length is Types.length and Types.every (e, i)->
          valueIsType x[i], e

    Reflect.defineProperty Tuple, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'tuple'
        types: Types
        name: Tuple.displayName
        identity: yes
      }

    Reflect.defineProperty Tuple, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Tuple

    typesCache.set TupleID, Tuple
    CACHE.set Tuple, TupleID

    Tuple
