# смысл интерфейса, чтобы объявить публичные виртуальные методы (и/или) проперти
# сами они должны быть реализованы в тех классах, куда подмешаны интерфейсы
# !!! Вопрос: а надо ли указывать типы аргументов и возвращаемого значения в декларации методов в интерфейсе если эти методы виртуальные???????????
# !!! Ответ: т.к. это интерфейсы дефиниции методов должны быть полностью задекларированы, чтобы реализации строго соотвествовали сигнатурам методов интерфейса.
# если в интерфейсе объявлен тип выходного значения как AnyT то проверку можно сделать строже, объявив конкретный тип в реализации метода в самом классе.


module.exports = (Module)->
  {
    PRODUCTION
    VIRTUAL
    Declare
    CoreObject
    Utils: {
      assign
      _
      t
      getTypeName
      createByType
      valueIsType
      isSubsetOf
    }
  } = Module::

  { assert } = t

  # cache = new Set()

  class Interface extends CoreObject
    @inheritProtected()
    @module Module

    cpmDefineProperty = Symbol.for '~defineProperty'

    constructor: ->
      super()
      assert.fail 'new operator unsupported' if @ instanceof Interface

    @public @static new: Function,
      default: -> assert.fail 'new method unsupported for Interface'

    @public @static implements: Function,
      default: -> assert.fail 'implements method unsupported for Interface'

    @public @static include: Function,
      default: -> assert.fail 'include method unsupported for Interface'

    @public @static initializeMixin: Function,
      default: -> assert.fail 'initializeMixin method unsupported for Interface'

    @public @static virtual: Function,
      default: (args...)->
        assert args.length > 0, 'arguments is required'
        [typeDefinition] = args
        assert _.isPlainObject(typeDefinition), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to virtual(typeDefinition) (expected a plain object or @static or/and @async definition)"

        config = if typeDefinition.attr? and typeDefinition.attrType?
          typeDefinition
        else
          attr = Object.keys(typeDefinition)[0]
          attrType = typeDefinition[attr]
          attrType = @Module::AccordG attrType

          isFunction = attrType in [
            @Module::FunctionT
            @Module::GeneratorFunctionT
          ] or @Module::FunctorT.is attrType

          { attr, attrType, isFunction }

        config.level = VIRTUAL
        @[cpmDefineProperty] config

    @public @static initialize: Function,
      default: ->
        # NOTE: т.к. CoreObject.initialize будет проверять нереализованные виртуальные методы, здесь ни в коем случае нельзя вызывать @super
        @constructor = Module::Class
        assert _.isFunction(@Module.const), "Module of #{@name} must be subclass of RC::Module"
        if @Module isnt @ or @name is 'Module'
          if @Module::[@name]? and @Module::[@name].meta.kind is 'declare'
            @Module::[@name].define @
          else
            Reflect.defineProperty @, 'cache',
              configurable: no
              enumerable: yes
              writable: no
              value: new Set()
            @Module.const {
              "#{@name}": new Proxy @,
                apply: (target, thisArg, argumentsList)->
                  if Module.environment is PRODUCTION
                    return value
                  [value, path] = argumentsList
                  path ?= [target.name]
                  assert value?, "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
                  if target.cache.has value
                    return value
                  target.cache.add value
                  for own k, {attrType} of target.instanceVirtualVariables
                    actual = value[k]
                    createByType attrType, actual, path.concat "#{k}: #{getTypeName attrType}"
                  for own k, {attrType} of target.instanceVirtualMethods
                    actual = value[k]
                    createByType attrType, actual, path.concat "#{k}: #{getTypeName attrType}"
                  return value
            }
        @

    @public @static displayName: String,
      get: -> @name

    @public @static is: Function,
      default: (x)->
        # console.log('>>>>> Interface.is', @name, x)
        return no unless x?
        # res = yes
        for own k, {attrType} of @instanceVirtualVariables
          # # return no unless t.is x[k], attrType
          # _inst = valueIsType x[k], attrType
          # console.log '>>>>> Interface.is for ::', x.constructor.name, _inst, @name, k, getTypeName attrType
          # res &&= _inst
          return no unless valueIsType x[k], attrType
        for own k of @instanceVirtualMethods
          # # return no unless t.is x[k], attrType
          # _inst = _.isFunction x[k] #valueIsType x[k], FunctionT
          # console.log '>>>>> Interface.is for ::', x.constructor.name, _inst, @name, k
          # res &&= _inst
          return no unless _.isFunction x[k]
        # for own k, {attrType} of @classVirtualVariables
        #   # # return no unless t.is x[k], attrType
        #   _cla = valueIsType x.constructor[k], attrType
        #   console.log '>>>>> Interface.is for .', x.constructor.name, _cla, @name, k, getTypeName attrType
        #   res &&= _cla
        #   # return no unless valueIsType x.constructor[k], attrType
        # for own k of @classVirtualMethods
        #   # # return no unless t.is x[k], attrType
        #   _cla = _.isFunction x.constructor[k] #valueIsType x.constructor[k], FunctionT
        #   console.log '>>>>> Interface.i for .', x.constructor.name, _cla, @name, k
        #   res &&= _cla
        #   # return no unless _.isFunction x.constructor[k]
        return yes
        # return res

    @public @static meta: Object,
      get: ->
        instanceVariables = {}
        instanceMethods = {}
        classVariables = {}
        classMethods = {}
        for own k, {attrType} of @instanceVirtualVariables
          instanceVariables[k] = attrType
        for own k, {attrType} of @instanceVirtualMethods
          instanceMethods[k] = attrType
        for own k, {attrType} of @classVirtualVariables
          classVariables[k] = attrType
        for own k, {attrType} of @classVirtualMethods
          classMethods[k] = attrType
        return {
          kind: 'interface'
          statics: assign {}, classVariables, classMethods
          props: assign {}, instanceVariables, instanceMethods
          name: @name
          identity: yes
          strict: no
        }


    @initialize()
