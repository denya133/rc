# Есть понимание что Interface, Struct and Class НЕ тождественные понятия.
# если описывается класс в его конструкторе может быть передано что угодно, таким образом проводится создание инстанса класса.
# описание Struct не подходит для проверки инстансов классов и наоборот, т.к. instanceof вернут в обоих случаях false
# проверка же интерфейса хоть и осуществляет проверку "вроде бы правильно", но опосредованно, т.к. переданный объект может не являться инстансом именно этого "Interface"а - задача интерфейса обеспечить полиморфизм

# таким образом, если надо проверить некоторый объект, что он инстанс конкретного (пользовательского) класса, то нужно воспользоваться этим генериком


module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
    }
  } = Module::

  cache = new Map()

  Module.defineGeneric Generic 'SampleG', (Class) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Class), "Invalid argument Class #{assert.stringify Class} supplied to SampleG(Class) (expected a function)"

    displayName = getTypeName Class

    if (cachedType = cache.get displayName)?
      return cachedType

    if (nonCustomType = Module::AccordG Class) isnt Class
      cache.set displayName, nonCustomType
      return nonCustomType

    Sample = (value, path) ->
      if Module.environment is PRODUCTION
        return value
      Sample.isNotSample @
      path ?= [Sample.displayName]
      assert Sample.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a sample of #{getTypeName Class})"
      return value

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
      value: (x)-> x instanceof Class

    Reflect.defineProperty Sample, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'irreducible'
        name: Sample.displayName
        predicate: Sample.is
        identity: yes
      }

    Reflect.defineProperty Sample, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Sample

    cache.set displayName, Sample

    Sample
