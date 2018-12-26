# Есть понимание что Interface, Struct and Class НЕ тождественные понятия.
# если описывается класс в его конструкторе может быть передано что угодно, таким образом проводится создание инстанса класса.
# описание Struct не подходит для проверки инстансов классов и наоборот, т.к. instanceof вернут в обоих случаях false
# проверка же интерфейса хоть и осуществляет проверку "вроде бы правильно", но опосредованно, т.к. переданный объект может не являться инстансом именно этого "Interface"а - задача интерфейса обеспечить полиморфизм

# таким образом, если надо проверить некоторый объект, что он инстанс конкретного (пользовательского) класса, то нужно воспользоваться этим генериком


module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    SOFT
    Generic
    Utils: {
      _
      uuid
      t: { assert }
      getTypeName
      instanceOf
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'SampleG', (Class) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Class), "Invalid argument Class #{assert.stringify Class} supplied to SampleG(Class) (expected a function)"

    displayName = "Sample<#{getTypeName Class}>"

    SampleID = "Sample<#{getTypeName Class}>#{uuid.v4()}"

    if (cachedType = typesCache.get Class)?
      return cachedType

    if (nonCustomType = Module::AccordG Class) isnt Class
      typesCache.set Class, nonCustomType
      return nonCustomType

    Sample = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      Sample.isNotSample @
      if Sample.has value
        return value
      path ?= [Sample.displayName]
      assert Sample.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a sample of #{getTypeName Class})"
      Sample.keep value
      return value

    # Reflect.defineProperty Sample, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Sample, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty Sample, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: SampleID

    Module::SOFT_CACHE.set SampleID, new Set

    Reflect.defineProperty Sample, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(SampleID).has value

    Reflect.defineProperty Sample, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::SOFT_CACHE.get(SampleID).add value

    Reflect.defineProperty Sample, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Sample, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Sample, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)-> instanceOf x, Class

    Reflect.defineProperty Sample, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'sample'
        type: Class
        name: Sample.displayName
        predicate: Sample.is
        identity: yes
      }

    Reflect.defineProperty Sample, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Sample

    typesCache.set Class, Sample
    CACHE.set Sample, SampleID

    Sample
