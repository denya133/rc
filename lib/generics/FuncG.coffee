

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

  Module.defineGeneric Generic 'FuncG', (ArgsTypes, ReturnType) ->
    unless ArgsTypes?
      ArgsTypes = []
    unless _.isArray ArgsTypes
      ArgsTypes = [ArgsTypes]
    if ArgsTypes.length is 0 and not ReturnType?
      return Module::FunctionT
    ReturnType = ReturnType ? Module::NilT
    ArgsTypes = ArgsTypes.map (Type)-> Module::AccordG Type
    ReturnType = Module::AccordG ReturnType
    if Module.environment isnt PRODUCTION
      assert ArgsTypes.every(_.isFunction), "Invalid argument ArgsTypes #{assert.stringify ArgsTypes} supplied to FuncG(ArgsTypes, ReturnType) (expected an array of functions)"
      assert _.isFunction(ReturnType), "Invalid argument ReturnType #{assert.stringify ReturnType} supplied to FuncG(ArgsTypes, ReturnType) (expected a function)"

    displayName = "(#{ArgsTypes.map(getTypeName).join ', '}) => #{getTypeName ReturnType}"

    if (cachedType = cache.get displayName)?
      return cachedType

    domainLength = ArgsTypes.length
    optionalArgumentsIndex = Module::getOptionalArgumentsIndex ArgsTypes

    Func = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Func.isNotSample @
      unless _.isFunction(value) and _.isPlainObject(value.instrumentation)
        return Func.of value
      path ?= [Func.displayName]
      assert Func.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a function)"
      return value

    Reflect.defineProperty Func, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Func, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Func, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        _.isFunction(x) and _.isPlainObject(x.instrumentation) and
        x.instrumentation.domain.length is domainLength and
        x.instrumentation.domain.every((type, i)-> type is ArgsTypes[i]) and
        x.instrumentation.codomain is ReturnType

    Reflect.defineProperty Func, 'of',
      configurable: no
      enumerable: yes
      writable: no
      value: (f, curried)->
        if Module.environment isnt PRODUCTION
          assert _.isFunction(f), "Invalid argument f supplied to FuncT #{displayName} (expected a function)"
          assert _.isNil(curried) or _.isBoolean(curried), "Invalid argument curried #{assert.stringify curried} supplied to FuncT #{displayName} (expected a boolean)"

        return f if Func.is f

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
            newDomain = Module::FuncG(ArgsTypes.slice(argsLength), ReturnType)
            return newDomain.of g, yes
          else
            return createByType ReturnType, f.apply(@, args), ["return of `#{fn.name}#{displayName}`"]

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

    Reflect.defineProperty Func, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'func'
        domain: ArgsTypes
        codomain: ReturnType
        name: Func.displayName
        identity: yes
      }

    Reflect.defineProperty Func, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Func

    cache.set displayName, Func

    Func
