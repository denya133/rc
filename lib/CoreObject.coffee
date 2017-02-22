_ = require 'lodash'
Class = require './Class'
{VIRTUAL, STATIC, PUBLIC, PRIVATE, PROTECTED} = require './Constants'

###
class TestInterface extends Interface
  # only public virtual properties and methods
  @public @static @virtual new: Function,
    args: [String, Object]
    return: Object
  @public @static @virtual create: Function,
    args: ANY
    return: ANY
  @public @virtual testing: Function,
    args: [String, Object, RC::Class, Boolean, String, Function]
    return: ANY

class Test extends CoreObject
  @implements TestInterface

  ipnTestIt = @private testIt: Number,
    default: 9
    get: (v)-> v
    set: (v)->
      @send 'testItChanged', v
      v + 98
  ipmModel = @protected Model: RC::Class,
    default: Basis::User

  @public @static new: Function,
    default: (methodName, options)-> #some code
  @public @static create: Function,
    default: (args...)-> new @::Model args...
  @public testing: Function,
    default: (methodName, config, users, isInternal, path, lambda)-> #some code

###


class CoreObject
  KEYWORDS = ['constructor', 'prototype', '__super__']
  cpmDefineInstanceDescriptors  = Symbol 'defineInstanceDescriptors'
  cpmDefineClassDescriptors     = Symbol 'defineClassDescriptors'
  cpmResetParentSuper           = Symbol 'resetParentSuper'
  cpmDefineProperty             = Symbol 'defineProperty'
  cpmCheckDefault               = Symbol 'checkDefault'

  constructor: ->
    # TODO здесь надо сделать проверку того, что в классе нет недоопределенных виртуальных методов. если для каких то виртуальных методов нет реализаций - кинуть эксепшен

  @super: (methodName)->
    if arguments.length is 0
      return @__super__?.constructor
    (Class, args...)=>
      if arguments.length is 1
        [args] = arguments
        Class = args.callee?.class ? @
      else
        unless _.isFunction Class
          throw new Error 'First argument must be <Class> or arguments'
      method = Class.__super__?.constructor[methodName]
      method?.apply @, args

  super: (methodName)->
    if arguments.length is 0
      return @constructor.__super__
    (Class, args...)=>
      if arguments.length is 1
        [args] = arguments
        Class = args.callee?.class ? @constructor
      else
        unless _.isFunction Class
          throw new Error 'First argument must be <Class> or arguments'
      method = Class.__super__?[methodName]
      method?.apply @, args

  @new: (args...)->
    new @ args...

  @[cpmDefineInstanceDescriptors] = (definitions)->
      for own methodName, funct of definitions when methodName not in KEYWORDS
        @__super__[methodName] = funct

        if not @::hasOwnProperty methodName
          @::[methodName] = funct
      return

  @[cpmDefineClassDescriptors] = (definitions)->
      for own methodName, funct of definitions when methodName not in KEYWORDS
        @__super__.constructor[methodName] = funct

        if not @hasOwnProperty methodName
          @[methodName] = funct
      return

  @[cpmResetParentSuper] = (_mixin)->
    __mixin = eval "(
      function() {
        function #{_mixin.name}() {
          #{_mixin.name}.__super__.constructor.apply(this, arguments);
        }
        return #{_mixin.name};
    })();"
    reserved_words = Object.keys CoreObject
    for own k, v of _mixin when k not in reserved_words
      __mixin[k] = v
    for own _k, _v of _mixin.prototype when _k not in KEYWORDS
      __mixin::[_k] = _v

    for own k, v of @__super__.constructor when k isnt 'including'
      __mixin[k] = v unless __mixin[k]
    for own _k, _v of @__super__ when _k not in KEYWORDS
      __mixin::[_k] = _v unless __mixin::[_k]
    __mixin::constructor.__super__ = @__super__
    return __mixin

    # tmp = class extends @__super__
    # reserved_words = Object.keys CoreObject
    # for own k, v of _mixin when k not in reserved_words
    #   tmp[k] = v
    # for own _k, _v of _mixin.prototype when _k not in KEYWORDS
    #   tmp::[_k] = _v
    # return tmp

  @include: (mixins...)->
    if Array.isArray mixins[0]
      mixins = mixins[0]
    mixins.forEach (mixin)=>
      if not mixin
        throw new Error 'Supplied mixin was not found'
      if mixin.constructor isnt Function
        throw new Error 'Supplied mixin must be a class'
      if mixin.__super__.constructor.name in ['Mixin', 'Interface']
        throw new Error 'Supplied mixin must be a subclass of RC::Mixin'

      __mixin = @[cpmResetParentSuper] mixin

      @__super__ = __mixin::

      @[cpmDefineClassDescriptors] __mixin
      @[cpmDefineInstanceDescriptors] __mixin::

      __mixin.including?.apply @
    @

  @implements: ->
    @include arguments...

  @initialize: (aClass)->
    aClass ?= @
    aClass.constructor = Class
    aClass

  @[cpmDefineProperty] = (
    {
      level, type, kind, attr, attrType
      default:_default, get, set
    }
  )->
    isFunction  = attrType  is Function
    isPublic    = level     is PUBLIC
    isPrivate   = level     is PRIVATE
    isProtected = level     is PROTECTED
    isStatic    = type      is STATIC
    isVirtual   = kind      is VIRTUAL

    target = if isStatic then @ else @::
    name = if isPublic
      attr
    else if isProtected
      Symbol.for attr
    else
      Symbol attr
    definition =
      writable: no
      enumerable: yes
      configurable: no
    if isFunction
      definition.value = _default
    else
      pointerOnRealPlace = Symbol 'uniqPointer'
      if _default?
        @[pointerOnRealPlace] = _default
      definition.get = ->
        value = @[pointerOnRealPlace]
        if get? and _.isFunction get
          return get value
      definition.set = (newValue)->
        if set? and _.isFunction set
          newValue = set newValue
        @[pointerOnRealPlace] = newValue
        return newValue

    Reflect.defineProperty target, name, definition
    return name

  @[cpmCheckDefault] = (config)->
    if config.attrType is Function and config.kind isnt VIRTUAL and not config.default?
      throw new Error 'For non virtual method default is required'
    return

  # метод, чтобы объявить виртуальный метод класса или инстанса
  @virtual: (typeDefinition, config)->
    if arguments.length is 0
      throw new Error 'arguments is required'
    if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?)
      throw new Error 'you must use second argument with config or @virtual/@static definition'

    if arguments.length is 1
      config = typeDefinition
    else
      if typeDefinition.constructor isnt Object or config.constructor isnt Object
        throw new Error 'typeDefinition and config must be Object instances'
      config.attr = Object.keys(typeDefinition)[0]
      config.attrType = typeDefinition[config.attr]

    config.kind = VIRTUAL
    config.default = null
    return config

  # метод чтобы объявить атрибут или метод класса
  @static: (typeDefinition, config)->
    if arguments.length is 0
      throw new Error 'arguments is required'
    if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?)
      throw new Error 'you must use second argument with config or @virtual/@static definition'

    if arguments.length is 1
      config = typeDefinition
    else
      if typeDefinition.constructor isnt Object or config.constructor isnt Object
        throw new Error 'typeDefinition and config must be Object instances'
      config.attr = Object.keys(typeDefinition)[0]
      config.attrType = typeDefinition[config.attr]

    config.type = STATIC
    return config

  @public: (typeDefinition, config)->
    if arguments.length is 0
      throw new Error 'arguments is required'
    if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?)
      throw new Error 'you must use second argument with config or @virtual/@static definition'

    if arguments.length is 1
      config = typeDefinition
    else
      if typeDefinition.constructor isnt Object or config.constructor isnt Object
        throw new Error 'typeDefinition and config must be Object instances'
      config.attr = Object.keys(typeDefinition)[0]
      config.attrType = typeDefinition[config.attr]

    @[cpmCheckDefault] config

    config.level = PUBLIC
    @[cpmDefineProperty] config

  @protected: (typeDefinition, params, returnValue)->
    # like public but outter objects does not get data or call methods
    if arguments.length is 0
      throw new Error 'arguments is required'
    if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?)
      throw new Error 'you must use second argument with config or @virtual/@static definition'

    if arguments.length is 1
      config = typeDefinition
    else
      if typeDefinition.constructor isnt Object or config.constructor isnt Object
        throw new Error 'typeDefinition and config must be Object instances'
      config.attr = Object.keys(typeDefinition)[0]
      config.attrType = typeDefinition[config.attr]

    @[cpmCheckDefault] config

    config.level = PROTECTED
    @[cpmDefineProperty] config

  @private: (typeDefinition, params, returnValue)->
    # like public but outter objects does not get data or call methods
    if arguments.length is 0
      throw new Error 'arguments is required'
    if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?)
      throw new Error 'you must use second argument with config or @virtual/@static definition'

    if arguments.length is 1
      config = typeDefinition
    else
      if typeDefinition.constructor isnt Object or config.constructor isnt Object
        throw new Error 'typeDefinition and config must be Object instances'
      config.attr = Object.keys(typeDefinition)[0]
      config.attrType = typeDefinition[config.attr]

    @[cpmCheckDefault] config

    config.level = PRIVATE
    @[cpmDefineProperty] config

  @public @static @virtual Module: Class
  @public Module: Class,
    get: -> @constructor.Module
  @public @static moduleName: String,
    get: -> @Module.name


module.exports = CoreObject.initialize()
