_ = require 'lodash'

module.exports = (RC)->
# all classes will be instances of this (CucumberController.constructor is Class)
  class RC::Class extends RC::CoreObject
    CLASS_KEYS = [
      'prototype', 'constructor', '__super__'
      'name', 'arguments', 'caller', 'including'
    ]
    INSTANCE_KEYS = [
      # 'constructor'
      'length'
      'arguments'
      'caller'
    ]
    @inheritProtected()
    @public @static new: Function,
      default: (name, object)->
        vClass = @clone RC::CoreObject, { name }

        reserved_words = Object.keys RC::CoreObject
        for own k, v of object.ClassMethods when k not in reserved_words
          vClass[k] = v
        for own _k, _v of object.InstanceMethods when _k not in INSTANCE_KEYS
          vClass::[_k] = _v
        vClass.Module = object.Module  if object.Module?

        vClass.__super__ = RC::CoreObject::
        return vClass

    @public @static propWrapper: Function,
      default: (target, pointer, funct) ->
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

    @public @static clone: Function,
      default: (klass, options = {}) ->
        throw new Error 'Not a constructor function'  unless _.isFunction klass
        options.name = klass.name
        parent = klass.__super__?.constructor ? klass::constructor
        Class = @

        clone = do (original = klass, parentPrototype = parent::, options) ->
          clone = eval "(
            function() {
              function #{original.name} () {
                #{original.name}.__super__.constructor.apply(this, arguments);
              };
              return #{original.name};
          })();"

          originalClassKeys = Reflect.ownKeys original
          for key in originalClassKeys when key not in CLASS_KEYS
            do (k = key) ->
              descriptor = Reflect.getOwnPropertyDescriptor original, k
              if descriptor?.value?
                v = Class.propWrapper clone, k, descriptor.value
                descriptor.value = v
              Reflect.defineProperty clone, k, descriptor

          ctor = -> @constructor = clone
          ctor:: = parentPrototype
          clone:: = new ctor()

          clone::constructor = clone

          originalPrototypeKeys = Reflect.ownKeys original::
          for key in originalPrototypeKeys when key not in INSTANCE_KEYS
            do (k = key) ->
              descriptor = Reflect.getOwnPropertyDescriptor original::, k
              if descriptor?.value?
                v = Class.propWrapper clone::, k, descriptor.value
                descriptor.value = v
              Reflect.defineProperty clone::, k, descriptor

          clone.__super__ = original.__super__

          clone.initialize?()  if options.initialize
          clone

    # надо объявить и методы из Class и из Module
  RC::Class.constructor = RC::Class
  return RC::Class
