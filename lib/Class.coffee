_ = require 'lodash'

module.exports = (RC)->
# all classes will be instances of this (CucumberController.constructor is Class)
  class RC::Class extends RC::CoreObject
    CLASS_KEYS = [
      'prototype', 'constructor', '__super__'
      'name', 'arguments', 'caller', 'including'
    ]
    INSTANCE_KEYS = [
      'constructor'
      'length'
      'arguments'
      'caller'
    ]
    @inheritProtected()
    @public @static new: Function,
      default: (name, object)->
        console.log '###############$$$$$$$$$$$TTTTT'
        vClass = @clone RC::CoreObject, { name, parent: RC::CoreObject }

        reserved_words = Object.keys RC::CoreObject
        for own k, v of object.ClassMethods when k not in reserved_words
          vClass[k] = v
        for own _k, _v of object.InstanceMethods when _k not in INSTANCE_KEYS
          vClass::[_k] = _v
        vClass.Module = object.Module  if object.Module?

        vClass.__super__ = RC::CoreObject::
        return vClass
    console.log '########^^^^^^^^^', @new.body

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
        parent = options.parent ? klass.__super__?.constructor ? klass::constructor
        console.log '<><><>0000', klass, klass.Module
        console.log '<><><>1111', options.parent
        console.log '<><><>2222/0', klass.__super__
        console.log '<><><>2222/1', klass.__super__?.constructor
        console.log '<><><>3333', klass::constructor, klass::constructor.Module
        Class = @

        do (original = klass, parentPrototype = parent::, options) ->
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

          ctor = ->
            @constructor = clone
            return
          ctor:: = parentPrototype
          clone:: = new ctor()
          console.log 'DASFSDAF00', new ctor().constructor
          console.log 'DASFSDAF', clone, clone::, clone::constructor, clone.constructor

          # clone::constructor = clone

          originalPrototypeKeys = Reflect.ownKeys original::
          for key in originalPrototypeKeys when key not in INSTANCE_KEYS
            do (k = key) ->
              descriptor = Reflect.getOwnPropertyDescriptor original::, k
              if descriptor?.value?
                v = Class.propWrapper clone::, k, descriptor.value
                descriptor.value = v
              Reflect.defineProperty clone::, k, descriptor

          clone.__super__ = parentPrototype
          console.log 'MMMMMMMMMMMMMMMMMMMM>>>', clone.__super__

          clone.initialize?()  if options.initialize
          console.log '=> CLASS:', Reflect.ownKeys clone
          console.log '=> PROTO:', Reflect.ownKeys clone::
          clone

      @public @static newTest: Function,
        default: ->
          console.log 42

    # надо объявить и методы из Class и из Module
  RC::Class.constructor = RC::Class
  console.log '########^^^^^^^^^1111', RC::Class.new.body
  return RC::Class
