

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    WEAK
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
      createByType
    }
  } = Module::

  Module.defineGeneric Generic 'Declare', (name) ->
    if Module.environment isnt PRODUCTION
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to Declare(name) (expected a string)"

    DeclareID = name

    class Declare
      constructor: ->
        assert.fail 'new operator unsupported' if @ instanceof Declare

    declare = new Proxy Declare,
      apply: (target, thisArg, argumentsList)->
        [value, path] = argumentsList
        if Module.environment is PRODUCTION
          return value
        path = (path ? []).concat [target.name]
        assert value?, "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
        assert target.Type?, 'Type declared but not defined, don\'t forget to call .define on every declared type'
        if Module::TypeT.is(target.Type) and target.Type.meta.kind is 'union'
          assert target.Type.dispatch is target.dispatch, "Please define the custom #{target.name}.dispatch function before calling #{target.name}.define()"
        # chachedValue = switch
        #   when _.isNumber(value) and not _.isObject(value)
        #     new Number value
        #   when _.isString(value) and not _.isObject(value)
        #     new String value
        #   when _.isBoolean(value) and not _.isObject(value)
        #     new Boolean value
        #   else
        #     value
        if Declare.cache.has value#chachedValue
          return value
        Declare.cache.add value#chachedValue

        if target.Type.constructor is Function
          target.Type value, path
        else
          for own k, {attrType} of target.instanceVirtualVariables
            actual = value[k]
            createByType attrType, actual, path.concat "#{k}: #{getTypeName attrType}"
          for own k, {attrType} of target.instanceVirtualMethods
            actual = value[k]
            createByType attrType, actual, path.concat "#{k}: #{getTypeName attrType}"

        return value

    Reflect.defineProperty Declare, 'cache',
      configurable: no
      enumerable: yes
      writable: no
      value: new Set()

    Reflect.defineProperty Declare, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: WEAK

    Reflect.defineProperty Declare, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: DeclareID

    Reflect.defineProperty Declare, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty Declare, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty Declare, 'define',
      configurable: no
      enumerable: yes
      writable: no
      value: (spec)->
        if Module.environment isnt PRODUCTION
          assert Module::TypeT.is(spec), "Invalid argument type #{assert.stringify spec} supplied to define(type) (expected a type)"
          assert _.isNil(Declare.Type), "Declare.define(type) can only be invoked once"

        if spec.constructor is Function
          if spec.meta.kind is 'union' and Declare.hasOwnProperty 'dispatch'
            spec.dispatch = Declare.dispatch
          Reflect.defineProperty Declare, 'of',
            configurable: no
            enumerable: yes
            writable: no
            value: spec.of ? (x)-> x
          Reflect.defineProperty Declare, 'is',
            configurable: no
            enumerable: yes
            writable: no
            value: spec.is
          Reflect.setPrototypeOf Declare::, spec::
        else
          Reflect.defineProperty spec, 'name',
            value: Declare.name
          Reflect.setPrototypeOf Declare, spec
          Reflect.setPrototypeOf Declare::, spec::

        Reflect.defineProperty Declare, 'meta',
          configurable: no
          enumerable: yes
          writable: no
          value: spec.meta
        Reflect.defineProperty Declare, 'Type',
          configurable: no
          enumerable: yes
          writable: no
          value: spec
        return Declare

    Reflect.defineProperty Declare, 'meta',
      configurable: yes
      enumerable: yes
      writable: no
      value: {
        kind: 'declare'
        name: Declare.displayName
        identity: yes
      }

    CACHE.set Declare, DeclareID

    declare
