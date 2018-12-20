

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
      valueIsType
    }
  } = Module::

  # cache = new Map()

  Module.defineGeneric Generic 'IntersectionG', (Types...) ->
    if Module.environment isnt PRODUCTION
      assert Types.length > 0, 'IntersectionG must be call with Array or many arguments'
      if Types.length is 1
        Types = Types[0]
      assert _.isArray(Types) and Types.length >= 2, "Invalid argument Types #{assert.stringify Types} supplied to IntersectionG(Types) (expected an array of at least 2 types)"
      Types = Types.map (Type)-> Module::AccordG Type
      assert Types.every(_.isFunction), "Invalid argument Types #{assert.stringify Types} supplied to IntersectionG(Types) (expected an array of functions)"

    displayName = Types.map(getTypeName).join ' & '

    # if (cachedType = cache.get displayName)?
    #   return cachedType

    Intersection = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Intersection.isNotSample @
      if Intersection.cache.has value
        return value
      path ?= [Intersection.displayName]
      assert Intersection.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
      Intersection.cache.add value
      return value

    Reflect.defineProperty Intersection, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

    Reflect.defineProperty Intersection, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Intersection, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Intersection, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        Types.every (type)-> valueIsType x, type

    Reflect.defineProperty Intersection, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'intersection'
        types: Types
        name: Intersection.displayName
        identity: yes
      }

    Reflect.defineProperty Intersection, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Intersection

    # cache.set displayName, Intersection

    Intersection
