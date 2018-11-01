# смысл интерфейса, чтобы объявить публичные виртуальные методы (и/или) проперти
# сами они должны быть реализованы в тех классах, куда подмешаны интерфейсы
# !!! Вопрос: а надо ли указывать типы аргументов и возвращаемого значения в декларации методов в интерфейсе если эти методы виртуальные???????????
# !!! Ответ: т.к. это интерфейсы дефиниции методов должны быть полностью задекларированы, чтобы реализации строго соотвествовали сигнатурам методов интерфейса.
# если в интерфейсе объявлен тип выходного значения как AnyT то проверку можно сделать строже, объявив конкретный тип в реализации метода в самом классе.


module.exports = (Module)->
  {
    PRODUCTION
    VIRTUAL
    CoreObject
    Declare
    Utils: {
      assign
      _
      t
      getTypeName
      createByType
    }
  } = Module::

  { assert } = t

  cache = new WeakSet()

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
            @Module.const {
              "#{@name}": new Proxy @,
                apply: (target, thisArg, argumentsList)->
                  if Module.environment is PRODUCTION
                    return value
                  [value, path] = argumentsList
                  path ?= [target.name]
                  assert value?, "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
                  if cache.has value
                    return value
                  cache.add value
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
        return no unless x?
        for own k, {attrType} of @instanceVirtualVariables
          return no unless t.is x[k], attrType
        for own k, {attrType} of @instanceVirtualMethods
          return no unless t.is x[k], attrType
        return yes

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
