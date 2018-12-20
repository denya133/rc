

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'EnumG', (args...) ->
    if Module.environment isnt PRODUCTION
      assert args.length > 0, 'EnumG must be call with Array, Object or many arguments'
      config = if args.length is 1
        args[0]
      else
        args
      assert _.isArray(config) or _.isPlainObject(config), 'EnumG must be call with Array or Plain Object'
      if _.isPlainObject(config)
        enums = []
        def = new Set( for own k, v of config
          enums.push assert.stringify k
          v
        )
        displayName = enums.join ' | '
      else if _.isArray(config)
        def = new Set config
        displayName = []
        config = config.reduce (prev, i)->
          item = assert.stringify i
          displayName.push item
          prev[item] ?= item
          prev
        , {}
        displayName = displayName.join ' | '

    # NOTE: так как кроме примитивов Строка и Число другие не смогут дать положительный результат в строкой проверке, в енуме не могут быть объявлены объекты, массивы и даты, следователно можно использовать в качестве ключа displayName
    if (cachedType = typesCache.get displayName)?
      return cachedType

    Enum = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Enum.isNotSample @
      if Enum.cache.has value
        return value
      path ?= [Enum.displayName]
      assert Enum.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected one of #{displayName})"
      Enum.cache.add value
      return value

    Reflect.defineProperty Enum, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

    Reflect.defineProperty Enum, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Enum, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Enum, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)-> def.has x

    Reflect.defineProperty Enum, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'enums'
        config: config
        map: def
        name: Enum.displayName
        identity: yes
      }

    Reflect.defineProperty Enum, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Enum

    typesCache.set displayName, Enum

    Enum
