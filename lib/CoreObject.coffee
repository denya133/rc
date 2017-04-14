_ = require 'lodash'

###
Пример инклуда для CoffeeScript 2.x
class CoreObject
  size: ->
    8
  @include: (aMixin)->
    SuperClass = Object.getPrototypeOf @
    vMixin = aMixin SuperClass
    Object.setPrototypeOf @, vMixin
    Object.setPrototypeOf @::, vMixin::
    return

_ControllerMixin = (Base)->
  class ControllerMixin extends Base
    size: ->
      super() + 4
    @size: ->
      66

_Controller1Mixin = (Base)->
  class Controller1Mixin extends Base
    size: ->
      super() + 1

class CucumberController extends CoreObject
  @include _ControllerMixin
  @include _Controller1Mixin

cu = new CucumberController()
console.log cu.size()
console.log CucumberController.size()
console.log CucumberController, cu
###


###
RC = require 'RC'
{ANY} = RC::Constants


module.exports = (App)->
  class App::TestInterface extends RC::Interface
    @inheritProtected()

    @Module: App

    # only public virtual properties and methods
    @public @static @virtual new: Function,
      args: [String, Object]
      return: Object
    @public @static @virtual create: Function,
      args: ANY
      return: ANY
    @public @virtual testing: Function,
      args: [Object, RC::Class, Boolean, String, Function]
      return: ANY
  App::TestInterface.initialize()
###

###
RC = require 'RC'


module.exports = (App)->
  class App::TestMixin extends RC::Mixin
    @inheritProtected()

    @Module: App

    @public methodInMixin: Function,
      args: [String, Object]
      return: Object
      default: (asPath, ahConfig)-> #some code

  App::TestMixin.initialize()
###

###
RC = require 'RC'

module.exports = (App)->
  class App::Test extends RC::CoreObject
    @inheritProtected()
    @implements App::TestInterface
    @include App::TestMixin

    @Module: App

    ipnTestIt = @private testIt: Number,
      default: 9
      get: (anValue)-> anValue
      set: (anValue)->
        @send 'testItChanged', anValue
        anValue + 98

    ipcModel = @protected Model: RC::Class,
      default: Basis::User

    @public @static new: Function,
      default: (args...)->
        @super arguments...
        #some code
    @public @static create: Function,
      default: (args...)-> @::[ipcModel].new args...

    @public testing: Function,
      default: (ahConfig, alUsers, isInternal, asPath, lambda)->
        vhResult = @methodInMixin path, config
        #some code
  App::Test.initialize()
###

# TODO: посмотреть интересные решения по наследованию в
# https://github.com/arximboldi/heterarchy
# после анализа если получится повидерать куски кода, и впилить у нас.

module.exports = (RC)->
  {
    ANY
    VIRTUAL, STATIC, ASYNC, CONST
    PUBLIC, PRIVATE, PROTECTED
  } = RC::Constants


  class RC::CoreObject
    # KEYWORDS = ['constructor', 'prototype', '__super__', 'length', 'name', 'arguments', 'caller']
    CLASS_KEYS = ['prototype', '__super__', 'name', 'arguments', 'caller']
    INSTANCE_KEYS = ['constructor', 'length', 'arguments', 'caller']
    cpmDefineInstanceDescriptors  = Symbol 'defineInstanceDescriptors'
    cpmDefineClassDescriptors     = Symbol 'defineClassDescriptors'
    cpmResetParentSuper           = Symbol 'resetParentSuper'
    cpmDefineProperty             = Symbol 'defineProperty'
    cpmCheckDefault               = Symbol 'checkDefault'

    cpoMetaObject                 = Symbol.for '~metaObject'

    constructor: ->
      # TODO здесь надо сделать проверку того, что в классе нет недоопределенных виртуальных методов. если для каких то виртуальных методов нет реализаций - кинуть эксепшен


    # Core class API
    Reflect.defineProperty @, 'super',
      enumerable: yes
      value: ->
        {caller} = arguments.callee
        vClass = caller.class ? @
        method = vClass.__super__?.constructor[caller.pointer]
        method?.apply @, arguments

    Reflect.defineProperty @::, 'super',
      enumerable: yes
      value: ->
        {caller} = arguments.callee
        vClass = caller.class ? @constructor
        method = vClass.__super__?[caller.pointer]
        method?.apply @, arguments

    Reflect.defineProperty @, 'inheritProtected',
      enumerable: yes
      value: ->
        baseSymbols = Reflect.ownKeys @__super__?.constructor ? {}
        for key in baseSymbols when key not in CLASS_KEYS
          do (key) =>
            descriptor = Reflect.getOwnPropertyDescriptor @__super__.constructor, key
            Reflect.defineProperty @, key, descriptor
        @[cpoMetaObject] = new RC::MetaObject @superclass()?.metaObject
        Reflect.defineProperty @, 'metaObject',
          enumerable: yes
          configurable: yes
          get: -> @[cpoMetaObject]
        Reflect.defineProperty @, 'classMethods',
          enumerable: yes
          configurable: yes
          get: -> @metaObject.getGroup 'classMethods'
        Reflect.defineProperty @, 'instanceMethods',
          enumerable: yes
          configurable: yes
          get: -> @metaObject.getGroup 'instanceMethods'
        Reflect.defineProperty @, 'constants',
          enumerable: yes
          configurable: yes
          get: -> @metaObject.getGroup 'constants'
        Reflect.defineProperty @, 'instanceVariables',
          enumerable: yes
          configurable: yes
          get: -> @metaObject.getGroup 'instanceVariables'
        Reflect.defineProperty @, 'classVariables',
          enumerable: yes
          configurable: yes
          get: -> @metaObject.getGroup 'classVariables'
        return

    Reflect.defineProperty @, 'new',
      enumerable: yes
      configurable: yes
      value: (args...)->
        Reflect.construct @, args

    propWrapper = (target, pointer, funct) ->
      if not funct instanceof RC::CoreObject and _.isFunction funct
        originalFunction = funct
        name = if _.isSymbol pointer
          /^Symbol\((\w*)\)$/.exec(pointer.toString())?[1]
        else
          pointer
        funct = (args...) -> originalFunction.apply @, args
        Reflect.defineProperty funct, 'class', value: target
        Reflect.defineProperty funct, 'name', value: name
        Reflect.defineProperty funct, 'pointer', value: pointer
      funct

    Reflect.defineProperty @, cpmDefineInstanceDescriptors,
      enumerable: yes
      value: (definitions)->
        for methodName in Reflect.ownKeys definitions when methodName not in INSTANCE_KEYS
          descriptor = Reflect.getOwnPropertyDescriptor definitions, methodName
          if descriptor?.value?
            funct = propWrapper definitions, methodName, descriptor.value
            descriptor.value = funct
          Reflect.defineProperty @__super__, methodName, descriptor

          unless Object::hasOwnProperty.call @.prototype, methodName
            descriptor = Reflect.getOwnPropertyDescriptor definitions, methodName
            if descriptor?.value?
              funct = propWrapper definitions, methodName, descriptor.value
              descriptor.value = funct
            Reflect.defineProperty @::, methodName, descriptor
        return

    Reflect.defineProperty @, cpmDefineClassDescriptors,
      enumerable: yes
      value: (definitions)->
        for methodName in Reflect.ownKeys definitions when methodName not in CLASS_KEYS
          descriptor = Reflect.getOwnPropertyDescriptor definitions, methodName
          if descriptor?.value?
            funct = propWrapper @__super__.constructor, methodName, descriptor.value
            descriptor.value = funct
          Reflect.defineProperty @__super__.constructor, methodName, descriptor

          descriptor = Reflect.getOwnPropertyDescriptor definitions, methodName
          if descriptor?.value?
            funct = propWrapper definitions, methodName, descriptor.value
            descriptor.value = funct
          Reflect.defineProperty @, methodName, descriptor
        return

    Reflect.defineProperty @, cpmResetParentSuper,
      enumerable: yes
      value: (_mixin, _super = @__super__)->
        __mixin = eval "(
          function() {
            function #{_mixin.name}() {
              #{_mixin.name}.__super__.constructor.apply(this, arguments);
            }
            return #{_mixin.name};
        })();"

        for key in Reflect.ownKeys _mixin
          do (k = key) =>
            descriptor = Reflect.getOwnPropertyDescriptor _mixin, k
            if descriptor?.value?
              v = propWrapper __mixin, key, descriptor.value
              descriptor.value = v
            Reflect.defineProperty __mixin, k, descriptor

        for key in Reflect.ownKeys _mixin::
          do (k = key) =>
            descriptor = Reflect.getOwnPropertyDescriptor _mixin::, k
            if descriptor?.value?
              v = propWrapper __mixin::, key, descriptor.value
              descriptor.value = v
            Reflect.defineProperty __mixin::, k, descriptor

        for k in Reflect.ownKeys _super.constructor when k isnt 'including'
          descriptor = Reflect.getOwnPropertyDescriptor _super.constructor, k
          if descriptor?.value?
            v = propWrapper __mixin, k, descriptor.value
            descriptor.value = v
          Reflect.defineProperty __mixin, k, descriptor  unless k of __mixin
        for k in Reflect.ownKeys _super when k not in INSTANCE_KEYS
          descriptor = Reflect.getOwnPropertyDescriptor _super, k
          if descriptor?.value?
            v = propWrapper __mixin::, k, descriptor.value
            descriptor.value = v
          Reflect.defineProperty __mixin::, k, descriptor  unless k of __mixin::

        __mixin::constructor.__super__ = _super
        return __mixin

        # tmp = class extends @__super__
        # reserved_words = Object.keys CoreObject
        # for own k, v of _mixin when k not in reserved_words
        #   tmp[k] = v
        # for own _k, _v of _mixin.prototype when _k not in KEYWORDS
        #   tmp::[_k] = _v
        # return tmp

    Reflect.defineProperty @, 'include',
      enumerable: yes
      value: (mixins...)->
        if Array.isArray mixins[0]
          mixins = mixins[0]
        mixins.forEach (mixin)=>
          if not mixin
            throw new Error 'Supplied mixin was not found'
          unless mixin.constructor is RC::Class
            throw new Error 'Supplied mixin must be a class'
          unless (mixin::) instanceof RC::Mixin or (mixin::) instanceof RC::Interface
            throw new Error 'Supplied mixin must be a subclass of RC::Mixin'

          __mixin = @[cpmResetParentSuper] mixin, @__super__

          @__super__ = __mixin::

          @[cpmDefineClassDescriptors] __mixin
          @[cpmDefineInstanceDescriptors] __mixin::

          __mixin.including?.apply @
        @

    Reflect.defineProperty @, 'implements',
      enumerable: yes
      value: ->
        @include arguments...

    Reflect.defineProperty @, 'metaObject',
      enumerable: yes
      configurable: yes
      value: new RC::MetaObject()

    Reflect.defineProperty @, 'initialize',
      enumerable: yes
      configurable: yes
      value: (aClass)->
        aClass ?= @
        aClass.constructor = RC::Class
        aClass

    Reflect.defineProperty @, cpmDefineProperty,
      enumerable: yes
      value: (config = {})->
        {
          level, type, kind, async, const:constant
          attr, attrType
          default:_default, get, set, configurable
        } = config

        isFunction  = attrType  is Function
        isPublic    = level     is PUBLIC
        isPrivate   = level     is PRIVATE
        isProtected = level     is PROTECTED
        isStatic    = type      is STATIC
        isVirtual   = kind      is VIRTUAL
        isConstant  = constant  is CONST

        if isVirtual
          return

        target = if isStatic then @ else @::
        name = if isPublic
          attr
        else if isProtected
          Symbol.for attr
        else
          Symbol attr
        definition =
          enumerable: yes
          configurable: configurable ? yes
        if isFunction
          Reflect.defineProperty _default, 'class', value: @
          Reflect.defineProperty _default, 'name', value: attr
          Reflect.defineProperty _default, 'pointer', value: name
          checkTypesWrapper = (args...)->
            # TODO: здесь надо в будущем реализовать логику проверки типов входящих аргументов
            if async is ASYNC
              # RC::Utils.co =>
              #   data = yield _default.apply @, args
              RC::Utils.co =>
                data = yield from _default.apply @, args
              # RC::Utils.co =>
              #   data = yield RC::Utils.co.wrap(_default).apply @, args
                # TODO: здесь надо проверить тип выходящего значения
                return data
            else
              data = _default.apply @, args
              # TODO: здесь надо проверить тип выходящего значения
              return data

          Reflect.defineProperty checkTypesWrapper, 'class', value: @
          Reflect.defineProperty checkTypesWrapper, 'name', value: attr
          Reflect.defineProperty checkTypesWrapper, 'pointer', value: name
          definition.value = checkTypesWrapper
        else
          pointerOnRealPlace = Symbol "_#{attr}"
          if _default?
            target[pointerOnRealPlace] = _default
          # TODO: сделать оптимизацию: если getter и setter не указаны,
          # то не использовать getter и setter, а объявлять через value
          definition.get = ->
            value = @[pointerOnRealPlace]
            if get? and _.isFunction get
              return get.apply @, [value]
            else
              return value
          definition.set = (newValue)->
            if set? and _.isFunction set
              newValue = set.apply @, [newValue]
            @[pointerOnRealPlace] = newValue
            return newValue

        Reflect.defineProperty target, name, definition
        if isConstant
          @metaObject.addMetaData 'constants', attr, config
        else if isStatic
          if isFunction
            @metaObject.addMetaData 'classMethods', attr, config
          else
            @metaObject.addMetaData 'classVariables', attr, config
        else
          if isFunction
            @metaObject.addMetaData 'instanceMethods', attr, config
          else
            @metaObject.addMetaData 'instanceVariables', attr, config
        return name

    Reflect.defineProperty @, cpmCheckDefault,
      enumerable: yes
      value: (config)->
        if config.attrType is Function and config.kind isnt VIRTUAL and not config.default?
          throw new Error 'For non virtual method default is required'
        return

    # метод, чтобы объявить асинхронный метод класса или инстанса
    # этот метод возвращает промис, а оберточная функция, которая будет делать проверку типов входящих и возвращаемых значений тоже будет ретурнить промис, а внутри будет использовать yield для ожидания резолва обворачиваемой функции
    Reflect.defineProperty @, 'async',
      enumerable: yes
      value: (typeDefinition, config={})->
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static/@async definition'

        if arguments.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        config.async = ASYNC
        return config

    # метод, чтобы объявить виртуальный метод класса или инстанса
    Reflect.defineProperty @, 'virtual',
      enumerable: yes
      value: (typeDefinition, config={})->
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static/@async definition'

        if arguments.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        config.kind = VIRTUAL
        return config

    # метод чтобы объявить атрибут или метод класса
    Reflect.defineProperty @, 'static',
      enumerable: yes
      value: (typeDefinition, config={})->
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static/@async definition'

        if arguments.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        config.type = STATIC
        return config

    Reflect.defineProperty @, 'public',
      enumerable: yes
      value: (typeDefinition, config={})->
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        @[cpmCheckDefault] config

        config.level = PUBLIC
        @[cpmDefineProperty] config

    Reflect.defineProperty @, 'protected',
      enumerable: yes
      value: (typeDefinition, config={})->
        # like public but outter objects does not get data or call methods
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        unless /^[~]/.test config.attr
          config.attr = '~' + config.attr
        @[cpmCheckDefault] config

        config.level = PROTECTED
        @[cpmDefineProperty] config

    Reflect.defineProperty @, 'private',
      enumerable: yes
      value: (typeDefinition, config={})->
        # like public but outter objects does not get data or call methods
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        unless /^[_]/.test config.attr
          config.attr = '_' + config.attr
        @[cpmCheckDefault] config

        config.level = PRIVATE
        @[cpmDefineProperty] config

    Reflect.defineProperty @, 'const',
      enumerable: yes
      value: (typeDefinition, config={})->
        config.const = CONST
        config.configurable = no
        @public @static typeDefinition, config

    @Module: RC

    Reflect.defineProperty @::, 'Module',
      enumerable: yes
      value: -> @constructor.Module
    Reflect.defineProperty @, 'moduleName',
      enumerable: yes
      value: -> @Module.name


    # General class API
    Reflect.defineProperty @, 'superclass',
    # @superclass: ->
      enumerable: yes
      value: ->
        @__super__?.constructor #? CoreObject
    Reflect.defineProperty @, 'class',
      enumerable: yes
      value: -> @constructor
    Reflect.defineProperty @::, 'class',
      enumerable: yes
      value: -> @constructor

    @public @static classMethods: Object,
      get: -> @metaObject.getGroup 'classMethods'

    @public @static instanceMethods: Object,
      get: -> @metaObject.getGroup 'instanceMethods'

    @public @static constants: Object,
      get: -> @metaObject.getGroup 'constants'

    @public @static instanceVariables: Object,
      get: -> @metaObject.getGroup 'instanceVariables'

    @public @static classVariables: Object,
      get: -> @metaObject.getGroup 'classVariables'

    # дополнительно можно объявить:
    # privateClassMethods, protectedClassMethods, publicClassMethods
    # privateInstanceMethods, protectedInstanceMethods, publicInstanceMethods
    # privateClassVariables, protectedClassVariables, publicClassVariables
    # privateInstanceVariables, protectedInstanceVariables, publicInstanceVariables

  require('./Class') RC

  return RC::CoreObject
