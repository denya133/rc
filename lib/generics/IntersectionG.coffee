

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
      valueIsType
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'IntersectionG', (Types...) ->
    if Module.environment isnt PRODUCTION
      assert Types.length > 0, 'IntersectionG must be call with Array or many arguments'
    if Types.length is 1
      Types = Types[0]
    if Module.environment isnt PRODUCTION
      assert _.isArray(Types) and Types.length >= 2, "Invalid argument Types #{assert.stringify Types} supplied to IntersectionG(Types) (expected an array of at least 2 types)"
    # _ids = []
    Types = Types.map (Type)->
      t = Module::AccordG Type
      # unless (id = CACHE.get t)?
      #   id = uuid.v4()
      #   CACHE.set t, id
      # _ids.push id
      # t
    # IntersectionID = _ids.join()
    if Module.environment isnt PRODUCTION
      assert Types.every(_.isFunction), "Invalid argument Types #{assert.stringify Types} supplied to IntersectionG(Types) (expected an array of functions)"

    displayName = Types.map(getTypeName).join ' & '

    IntersectionID = Types.map((T)-> T.ID).join ' & '

    if (cachedType = typesCache.get IntersectionID)?
      return cachedType

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

    Reflect.defineProperty Intersection, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty Intersection, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: IntersectionID

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

    typesCache.set IntersectionID, Intersection
    CACHE.set Intersection, IntersectionID

    Intersection
