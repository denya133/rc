# all classes will be instances of this (CucumberController.constructor is Class)


module.exports = (RC)->
  {
    CoreObject
  } = RC::
  {
    CLASS_KEYS, INSTANCE_KEYS
  } = CoreObject::

  _ = RC::_ ? RC::Utils._
  t = RC::t ? RC::Utils.t
  { assert } = t

  class RC::Class extends CoreObject
    @inheritProtected()
    @module RC

    Reflect.defineProperty @, 'new',
      enumerable: yes
      value: (name, object)->
        vClass = @clone CoreObject, { name, parent: CoreObject }

        reserved_words = Object.keys CoreObject
        for own k, v of object.ClassMethods when k not in reserved_words
          vClass[k] = v
        for own _k, _v of object.InstanceMethods when _k not in INSTANCE_KEYS
          vClass::[_k] = _v
        vClass.Module = object.Module  if object.Module?

        Reflect.setPrototypeOf vClass::, new CoreObject
        return vClass

    Reflect.defineProperty @, 'restoreObject',
      enumerable: yes
      value: (Module, replica)->
        assert replica?, "Replica cann`t be empty"
        assert replica.class?, "Replica type is required"
        assert replica?.type is 'class', "Replica type isn`t `class`. It is `#{replica.type}`"
        (@Module::Promise ? RC::Promise).resolve Module::[replica.class]

    Reflect.defineProperty @, 'replicateObject',
      enumerable: yes
      value: (acClass)->
        assert acClass?, "Argument cann`t be empty"
        replica =
          type: 'class'
          class: acClass.name
        (@Module::Promise ? RC::Promise).resolve replica

    Reflect.defineProperty @, 'clone',
      enumerable: yes
      value: (klass, options = {}) ->
        assert _.isFunction(klass), 'Not a constructor function'
        options.name ?= klass.name
        SuperClass = Reflect.getPrototypeOf klass
        parent = options.parent ? SuperClass ? klass::constructor
        Class = @

        do (original = klass, parentPrototype = parent::, options) ->
          clone = class extends original
          Reflect.defineProperty clone, 'name', value: options.name

          clone.initialize?()  if options.initialize
          clone

    # надо объявить и методы из Class и из Module - которые в Ruby
  RC::Class.constructor = RC::Class

  return RC::Class
