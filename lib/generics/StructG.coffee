# Есть понимание что Interface, Struct and Class НЕ тождественные понятия.
# если описывается класс в его конструкторе может быть передано что угодно, таким образом проводится создание инстанса класса.
# описание Struct не подходит для проверки инстансов классов и наоборот, т.к. instanceof вернут в обоих случаях false
# проверка же интерфейса хоть и осуществляет проверку "вроде бы правильно", но опосредованно, т.к. переданный объект может не являться инстансом именно этого "Interface"а - задача интерфейса обеспечить полиморфизм

# таким образом, если надо проверить некоторый объект, как инстанс подкласса Object нужно воспользоваться именно этим Struct генериком.

# struct генерик нужено использовать в тех случаях, когда надо объявить тип для структуры, в которой должны быть определенные имена ключей с определенными (не одинаковыми) типами значений.

# при этом по функционированию struct не будет отличаться принципиально от интерфейса кроме 2 пунктов:
# - в отличие от интерфейса проверка имен ключей будет прозводиться 'строго', т.е. в проверяемом объекте должны быть строго только те ключи, которые объявлены в struct И НЕ БОЛЕЕ.
# - семантически, т.е. struct НЕ ДОЛЖЕН использоваться для проверки инстансов классов и самих классов - для них должен использоваться интерфейс, в то время как любые сложные (не словари) объекты "не инстансы кастомных классов" должны проверяться именно struct'ами.

# NOTE: options.defaultProps не добавляем, т.к. Struct не должен инстанцировать объекты через new, а должен только проверить в строгом режиме уже существующие объекты, а следовательно ленивое описание дефолтов не может быть использовано.
# NOTE: options вторым аргументом не принимаем, т.к. defaultProps не должен быть, а strict - по умолчанию всегда true, name - как и во всех других генериках не передаем.


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

  Module.defineGeneric Generic 'StructG', (props) ->
    if Module.environment isnt PRODUCTION
      assert Module::DictG(String, Function).is(props), "Invalid argument props #{assert.stringify props} supplied to StructG(props) (expected a dictionary String -> Type)"

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
    # StructID = _ids.join()

    props = new_props

    displayName = "Struct{#{(
      for own k, T of props
        "#{k}: #{getTypeName T}"
    ).join ', '}}"

    StructID = "Struct{#{(
      for own k, T of props
        "#{k}: #{T.ID}"
    ).join ', '}}"

    if (cachedType = typesCache.get StructID)?
      return cachedType

    Struct = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Struct.isNotSample @
      if Struct.cache.has value
        return value
      path ?= [Struct.displayName]
      assert _.isPlainObject(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a plain object)"
      for own k of value
        assert props.hasOwnProperty(k), "Invalid prop \"#{k}\" supplied to #{path.join '.'}"
      for own k, expected of props
        assert value.hasOwnProperty(k), "Invalid prop \"#{k}\" supplied to #{path.join '.'}"
        actual = value[k]
        createByType expected, actual, path.concat "#{k}: #{getTypeName expected}"
      Struct.cache.add value
      return value

    Reflect.defineProperty Struct, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

    Reflect.defineProperty Struct, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty Struct, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: StructID

    Reflect.defineProperty Struct, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Struct, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Struct, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        _.isPlainObject(x) and (
          res = yes
          for own k of x
            res = res and props.hasOwnProperty k
          for own k, v of props
            res = res and x.hasOwnProperty k
            res = res and valueIsType x[k], v
          res
        )

    Reflect.defineProperty Struct, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'interface'
        props: props
        name: Struct.displayName
        identity: yes
        strict: yes
      }

    Reflect.defineProperty Struct, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Struct

    typesCache.set StructID, Struct
    CACHE.set Struct, StructID

    Struct
