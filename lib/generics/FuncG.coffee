# This file is part of RC.
#
# RC is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with RC.  If not, see <https://www.gnu.org/licenses/>.

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    NON
    Generic
    Utils: {
      _
      uuid
      t: { assert }
      getTypeName
      createByType
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'FuncG', (ArgsTypes, ReturnType) ->
    unless ArgsTypes?
      ArgsTypes = []
    unless _.isArray ArgsTypes
      ArgsTypes = [ArgsTypes]
    if ArgsTypes.length is 0 and not ReturnType?
      return Module::FunctionT
    _ids = []
    ReturnType = ReturnType ? Module::MaybeG Module::AnyT
    ArgsTypes = ArgsTypes.map (Type)->
      t = Module::AccordG Type
      unless (id = CACHE.get t)?
        id = uuid.v4()
        CACHE.set t, id
      _ids.push id
      t
    ReturnType = Module::AccordG ReturnType
    if Module.environment isnt PRODUCTION
      assert ArgsTypes.every(_.isFunction), "Invalid argument ArgsTypes #{assert.stringify ArgsTypes} supplied to FuncG(ArgsTypes, ReturnType) (expected an array of functions)"
      assert _.isFunction(ReturnType), "Invalid argument ReturnType #{assert.stringify ReturnType} supplied to FuncG(ArgsTypes, ReturnType) (expected a function)"

    displayName = "(#{ArgsTypes.map(getTypeName).join ', '}) => #{getTypeName ReturnType}"

    unless (id = CACHE.get ReturnType)?
      id = uuid.v4()
      CACHE.set ReturnType, id
    _ids.push id
    FuncID = _ids.join()

    if (cachedType = typesCache.get FuncID)?
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
      # value: (f, curried)->
      value: (f)->
        if Module.environment isnt PRODUCTION
          assert _.isFunction(f), "Invalid argument f supplied to FuncT #{displayName} (expected a function)"
          # assert _.isNil(curried) or _.isBoolean(curried), "Invalid argument curried #{assert.stringify curried} supplied to FuncT #{displayName} (expected a boolean)"

        return f if Func.is f

        fn = (args...)->
          # argsLength = args.length
          if Module.environment isnt PRODUCTION
            tupleLength = optionalArgumentsIndex
            # tupleLength = if curried
            #   argsLength
            # else
            #   # Math.max argsLength, optionalArgumentsIndex
            #   optionalArgumentsIndex
            if domainLength isnt 0
              # Module::TupleG(ArgsTypes.slice(0, tupleLength))(args.slice(0, optionalArgumentsIndex), ["arguments of `#{fn.name}#{displayName}`"])
              fn.argsTuple?(args.slice(0, optionalArgumentsIndex), ["arguments of `#{fn.name}#{displayName}`"])
          # if curried and domainLength > 0 and argsLength < domainLength
          #   if Module.environment isnt PRODUCTION
          #     assert argsLength > 0, 'Invalid arguments.length = 0 for curried function ' + displayName
          #   g = Function.prototype.bind.apply(f, [@].concat(args))
          #   newDomain = Module::FuncG(ArgsTypes.slice(argsLength), ReturnType)
          #   return newDomain.of g, yes
          # else
          data = f.apply @, args
          if Module.environment isnt PRODUCTION
            createByType ReturnType, data, ["return of `#{fn.name}#{displayName}`"]
          return data

        Reflect.defineProperty fn, 'argsTuple',
          configurable: no
          enumerable: yes
          writable: no
          value: do ->
            if domainLength isnt 0
              Module::TupleG(ArgsTypes.slice(0, optionalArgumentsIndex))

        Reflect.defineProperty fn, 'instrumentation',
          configurable: no
          enumerable: yes
          writable: no
          value: {domain: ArgsTypes, codomain: ReturnType, f}

        Reflect.defineProperty fn, 'name',
          configurable: yes
          enumerable: yes
          writable: no
          value: getTypeName f

        Reflect.defineProperty fn, 'displayName',
          configurable: yes
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

    Reflect.defineProperty Func, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: NON

    Reflect.defineProperty Func, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Func

    typesCache.set FuncID, Func
    CACHE.set Func, FuncID

    Func
