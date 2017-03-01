_ = require 'lodash'


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
    default: (args...)->
      @super arguments...
      #some code
  @public @static create: Function,
    default: (args...)-> new @::Model args...
  @public testing: Function,
    default: (methodName, config, users, isInternal, path, lambda)-> #some code

###

module.exports = (RC)->
  {
    ANY
    VIRTUAL, STATIC
    PUBLIC, PRIVATE, PROTECTED
  } = RC::Constants


  class RC::CoreObject
    KEYWORDS = ['constructor', 'prototype', '__super__']
    cpmDefineInstanceDescriptors  = Symbol 'defineInstanceDescriptors'
    cpmDefineClassDescriptors     = Symbol 'defineClassDescriptors'
    cpmResetParentSuper           = Symbol 'resetParentSuper'
    cpmDefineProperty             = Symbol 'defineProperty'
    cpmCheckDefault               = Symbol 'checkDefault'

    constructor: ->
      # TODO здесь надо сделать проверку того, что в классе нет недоопределенных виртуальных методов. если для каких то виртуальных методов нет реализаций - кинуть эксепшен


    # Core class API
    # Reflect.defineProperty @, 'super',
    #   enumerable: yes
    #   value: (methodName)->
    #     if arguments.length is 0
    #       return @__super__?.constructor
    #     (vClass, args...)=>
    #       if arguments.length is 1
    #         [args] = arguments
    #         vClass = args.callee?.class ? @
    #       else
    #         unless _.isFunction vClass
    #           throw new Error 'First argument must be <Class> or arguments'
    #       method = vClass.__super__?.constructor[methodName]
    #       method?.apply @, args
    #
    # Reflect.defineProperty @::, 'super',
    #   enumerable: yes
    #   value: (methodName)->
    #     if arguments.length is 0
    #       return @constructor.__super__
    #     (vClass, args...)=>
    #       if arguments.length is 1
    #         [args] = arguments
    #         vClass = args.callee?.class ? @constructor
    #       else
    #         unless _.isFunction vClass
    #           throw new Error 'First argument must be <Class> or arguments'
    #       method = vClass.__super__?[methodName]
    #       method?.apply @, args
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
        baseSymbols = Object.getOwnPropertySymbols @__super__?.constructor ? {}
        for key in baseSymbols
          do (key) =>
            Reflect.defineProperty @, key,
              enumerable: yes,
              value: @__super__.constructor[key]
        return

    Reflect.defineProperty @, 'new',
      enumerable: yes
      value: (args...)->
        new @ args...

    Reflect.defineProperty @, cpmDefineInstanceDescriptors,
      enumerable: yes
      value: (definitions)->
        for own methodName, funct of definitions when methodName not in KEYWORDS
          @__super__[methodName] = funct

          if not @::hasOwnProperty methodName
            @::[methodName] = funct
        return

    Reflect.defineProperty @, cpmDefineClassDescriptors,
      enumerable: yes
      value: (definitions)->
        for own methodName, funct of definitions when methodName not in KEYWORDS
          @__super__.constructor[methodName] = funct

          if not @hasOwnProperty methodName
            @[methodName] = funct
        return

    Reflect.defineProperty @, cpmResetParentSuper,
      enumerable: yes
      value: (_mixin)->
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

          __mixin = @[cpmResetParentSuper] mixin

          @__super__ = __mixin::

          @[cpmDefineClassDescriptors] __mixin
          @[cpmDefineInstanceDescriptors] __mixin::

          __mixin.including?.apply @
        @

    Reflect.defineProperty @, 'implements',
      enumerable: yes
      value: ->
        @include arguments...

    Reflect.defineProperty @, 'initialize',
      enumerable: yes
      value: (aClass)->
        aClass ?= @
        aClass.constructor = RC::Class
        aClass

    Reflect.defineProperty @, cpmDefineProperty,
      enumerable: yes
      value: (
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
          configurable: no
        if isFunction
          Reflect.defineProperty _default, 'class', value: @
          Reflect.defineProperty _default, 'name', value: attr
          Reflect.defineProperty _default, 'pointer', value: name
          definition.value = _default
        else
          pointerOnRealPlace = Symbol 'uniqPointer'
          if _default?
            target[pointerOnRealPlace] = _default
          definition.get = ->
            value = @[pointerOnRealPlace]
            if get? and _.isFunction get
              return get value
            else
              return value
          definition.set = (newValue)->
            if set? and _.isFunction set
              newValue = set newValue
            @[pointerOnRealPlace] = newValue
            return newValue

        Reflect.defineProperty target, name, definition
        return name

    Reflect.defineProperty @, cpmCheckDefault,
      enumerable: yes
      value: (config)->
        if config.attrType is Function and config.kind isnt VIRTUAL and not config.default?
          throw new Error 'For non virtual method default is required'
        return

    # метод, чтобы объявить виртуальный метод класса или инстанса
    Reflect.defineProperty @, 'virtual',
      enumerable: yes
      value: (typeDefinition, config)->
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1
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
      value: (typeDefinition, config)->
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1
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
      value: (typeDefinition, config)->
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1
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
      value: (typeDefinition, config)->
        # like public but outter objects does not get data or call methods
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        @[cpmCheckDefault] config

        config.level = PROTECTED
        @[cpmDefineProperty] config

    Reflect.defineProperty @, 'private',
      enumerable: yes
      value: (typeDefinition, config)->
        # like public but outter objects does not get data or call methods
        if arguments.length is 0
          throw new Error 'arguments is required'
        attr = Object.keys(typeDefinition)[0]
        attrType = typeDefinition[attr]
        if arguments.length is 1 and (not typeDefinition.attr? or not typeDefinition.attrType?) and attrType is Function
          throw new Error 'you must use second argument with config or @virtual/@static definition'

        if arguments.length is 1
          config = typeDefinition
        else
          if typeDefinition.constructor isnt Object or config.constructor isnt Object
            throw new Error 'typeDefinition and config must be Object instances'
          config.attr = attr
          config.attrType = attrType

        @[cpmCheckDefault] config

        config.level = PRIVATE
        @[cpmDefineProperty] config

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
        @__super__?.constructor ? CoreObject
    Reflect.defineProperty @, 'class',
      enumerable: yes
      value: -> @constructor
    Reflect.defineProperty @::, 'class',
      enumerable: yes
      value: -> @constructor

  require('./Class') RC

  return RC::CoreObject
