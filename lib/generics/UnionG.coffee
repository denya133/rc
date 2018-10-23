

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

  Module.defineGeneric Generic 'UnionG', (Types...) ->
    if Module.environment isnt PRODUCTION
      assert Types.length > 0, 'UnionG must be call with Array or many arguments'
      if Types.length is 1
        Types = Types[0]
      assert _.isArray(Types) and Types.length >= 2, "Invalid argument Types #{assert.stringify Types} supplied to UnionG(Types) (expected an array of at least 2 types)"
      Types = Types.map (Type)-> Module::AccordG Type
      assert Types.every(_.isFunction), "Invalid argument Types #{assert.stringify Types} supplied to UnionG(Types) (expected an array of functions)"

    displayName = Types.map(getTypeName).join ' | '

    if (cachedType = cache.get displayName)?
      return cachedType

    Union = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Union.isNotSample @
      Type = Union.dispatch value
      if not Type and Union.is value
        return value
      path ?= [Union.displayName]
      assert _.isFunction(Type), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (no constructor returned by dispatch)"
      path[path.length - 1] += "(#{getTypeName Type})"
      createByType Type, value, path
      return value

    Reflect.defineProperty Union, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Union

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
        Types.some (type)-> t.is x, type

    Reflect.defineProperty Union, 'dispatch',
      configurable: no
      enumerable: yes
      writable: yes
      value: (x)->
        for type in Types
          if Module::TypeT.is(type) and type.meta.kind is 'union'
            dispatchedType = type.dispatch x
            return dispatchedType if dispatchedType?
          else if t.is x, type
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

    cache.set displayName, Union

    Union
