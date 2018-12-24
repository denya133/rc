

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    SOFT
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

  Module.defineGeneric Generic 'UnionG', (Types...) ->
    if Module.environment isnt PRODUCTION
      assert Types.length > 0, 'UnionG must be call with Array or many arguments'
    if Types.length is 1
      Types = Types[0]
    if Module.environment isnt PRODUCTION
      assert _.isArray(Types) and Types.length >= 2, "Invalid argument Types #{assert.stringify Types} supplied to UnionG(Types) (expected an array of at least 2 types)"
    # _ids = []
    Types = Types.map (Type)->
      t = Module::AccordG Type
      # unless (id = CACHE.get t)?
      #   id = uuid.v4()
      #   CACHE.set t, id
      # _ids.push id
      # t
    # UnionID = _ids.join()
    if Module.environment isnt PRODUCTION
      assert Types.every(_.isFunction), "Invalid argument Types #{assert.stringify Types} supplied to UnionG(Types) (expected an array of functions)"

    displayName = Types.map(getTypeName).join ' | '

    UnionID = Types.map((T)-> T.ID).join ' | '

    if (cachedType = typesCache.get UnionID)?
      return cachedType

    Union = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Union.isNotSample @
      if Union.has value
        return value
      Type = Union.dispatch value
      if not Type and Union.is value
        return value
      path ?= [Union.displayName]
      assert _.isFunction(Type), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (no Type returned by dispatch)"
      path[path.length - 1] += "(#{getTypeName Type})"
      createByType Type, value, path
      Union.keep value
      return value

    # Reflect.defineProperty Union, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Union, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty Union, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: UnionID

    Module::SOFT_CACHE.set UnionID, new Set

    Reflect.defineProperty Union, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(UnionID).has value

    Reflect.defineProperty Union, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(UnionID).add value

    Reflect.defineProperty Union, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Union, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Union, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        Types.some (type)-> valueIsType x, type

    Reflect.defineProperty Union, 'dispatch',
      configurable: no
      enumerable: yes
      writable: yes
      value: (x)->
        for type in Types
          if Module::TypeT.is(type) and type.meta.kind is 'union'
            dispatchedType = type.dispatch x
            return dispatchedType if dispatchedType?
          else if valueIsType x, type
            return type

    Reflect.defineProperty Union, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'union'
        types: Types
        name: Union.displayName
        identity: yes
      }

    Reflect.defineProperty Union, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Union

    typesCache.set UnionID, Union
    CACHE.set Union, UnionID

    Union
