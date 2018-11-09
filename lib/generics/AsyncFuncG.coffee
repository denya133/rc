

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
      createByType
    }
  } = Module::

  cache = new Map()

  Module.defineGeneric Generic 'AsyncFuncG', (ArgsTypes, ReturnType) ->
    unless ArgsTypes?
      ArgsTypes = []
    unless _.isArray ArgsTypes
      ArgsTypes = [ArgsTypes]
    ReturnType = ReturnType ? Module::NilT
    ArgsTypes = ArgsTypes.map (Type)-> Module::AccordG Type
    ReturnType = Module::AccordG ReturnType
    if Module.environment isnt PRODUCTION
      assert ArgsTypes.every(_.isFunction), "Invalid argument ArgsTypes #{assert.stringify ArgsTypes} supplied to AsyncFuncG(ArgsTypes, ReturnType) (expected an array of functions)"
      assert _.isFunction(ReturnType), "Invalid argument ReturnType #{assert.stringify ReturnType} supplied to AsyncFuncG(ArgsTypes, ReturnType) (expected a function)"

    displayName = "async (#{ArgsTypes.map(getTypeName).join ', '}) => #{getTypeName ReturnType}"

    if (cachedType = cache.get displayName)?
      return cachedType

    domainLength = ArgsTypes.length
    optionalArgumentsIndex = Module::getOptionalArgumentsIndex ArgsTypes

    AsyncFunc = (value, path)->
      if Module.environment is PRODUCTION
        return value
      AsyncFunc.isNotSample @
      unless _.isFunction(value) and _.isPlainObject(value.instrumentation)
        return AsyncFunc.of value
      path ?= [AsyncFunc.displayName]
      assert AsyncFunc.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a function)"
      return value

    Reflect.defineProperty AsyncFunc, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty AsyncFunc, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty AsyncFunc, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        _.isFunction(x) and _.isPlainObject(x.instrumentation) and
        x.instrumentation.domain.length is domainLength and
        x.instrumentation.domain.every((type, i)-> type is ArgsTypes[i]) and
        x.instrumentation.codomain is ReturnType

    Reflect.defineProperty AsyncFunc, 'of',
      configurable: no
      enumerable: yes
      writable: no
      value: (f, curried)->
        if Module.environment isnt PRODUCTION
          assert _.isFunction(f), "Invalid argument f supplied to FuncT #{displayName} (expected a function)"
          assert _.isNil(curried) or _.isBoolean(curried), "Invalid argument curried #{assert.stringify curried} supplied to FuncT #{displayName} (expected a boolean)"

        return f if AsyncFunc.is f

        fn = (args...)->
          argsLength = args.length
          if Module.environment isnt PRODUCTION
            tupleLength = if curried
              argsLength
            else
              # Math.max argsLength, optionalArgumentsIndex
              optionalArgumentsIndex
            if domainLength isnt 0
              Module::TupleG(ArgsTypes.slice(0, tupleLength))(args.slice(0, optionalArgumentsIndex), ["arguments of `#{fn.name}#{displayName}`"])
          if curried and domainLength > 0 and argsLength < domainLength
            if Module.environment isnt PRODUCTION
              assert argsLength > 0, 'Invalid arguments.length = 0 for curried function ' + displayName
            g = Function.prototype.bind.apply(f, [@].concat(args))
            newDomain = Module::AsyncFuncG(ArgsTypes.slice(argsLength), ReturnType)
            return newDomain.of g, yes
          else
            return f.apply(@, args).then (data)->
              createByType ReturnType, data, ["return of `#{fn.name}#{displayName}`"]
              data

        Reflect.defineProperty fn, 'instrumentation',
          configurable: no
          enumerable: yes
          writable: no
          value: {domain: ArgsTypes, codomain: ReturnType, f}

        Reflect.defineProperty fn, 'name',
          configurable: no
          enumerable: yes
          writable: no
          value: getTypeName f

        Reflect.defineProperty fn, 'displayName',
          configurable: no
          enumerable: yes
          writable: no
          value: fn.name

        return fn

    Reflect.defineProperty AsyncFunc, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'async'
        domain: ArgsTypes
        codomain: ReturnType
        name: AsyncFunc.displayName
        identity: yes
      }

    Reflect.defineProperty AsyncFunc, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG AsyncFunc

    cache.set displayName, AsyncFunc

    AsyncFunc
