Class = require './Class'

class Core
  KEYWORDS = ['constructor', 'prototype', '__super__']
  cpmDefineInstanceDescriptors  = Symbol 'defineInstanceDescriptors'
  cpmDefineClassDescriptors     = Symbol 'defineClassDescriptors'
  cpmResetParentSuper           = Symbol 'resetParentSuper'

  constructor: ->
    # TODO здесь надо сделать проверку того, что в классе нет недоопределенных виртуальных методов. если для каких то виртуальных методов нет реализаций - кинуть эксепшен

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

  # метод, чтобы объявить виртуальный (скорее всего) метод, если не указан тип, значит это виртуальный атрибут, т.к. если бы это была виртуальная функция, то тип был бы явно указан Function
  @virtual: (typeDefinition)->

  # метод чтобы объявить атрибут или метод класса
  @static: (typeDefinition, params, returnValue)->

  # методы с такими же названиями будут объявлены в CoreObject
  # но реализоация у них будет другая. В Interface эти методы должны в специальные проперти положить результаты их вызовов при формировании классов-интерфейсов, однако реализация этих методов в CoreObject будет дефайнить реальные атрибуты и методы инстанса и самого класса. (своего рода перегрузка)
  @public: (typeDefinition, params, returnValue)->
    key = Object.keys(typeDefinition)[0]
    Type = typeDefinition[key]
    isFunction = Type is Function
    if isFunction
      functionArguments = params
      return {key, Type, functionArguments, returnValue}
    else
      return {key, Type}

  @protected: (typeDefinition, params, returnValue)->
    # like public but outter objects does not get data or call methods
    # если ключ объявлен с использованием
    # `protected_key = Symbol.for('protected_key')`
    # то естественно он доступен и внутри текущего класса, т.к. указатель на него находится в зоне видимости методов класса (и инстанса класса).
    # но также в унаследованных классах есть возможность получить этот же Символ
    # чтобы обратиться к этому же проперти.
    # Плюсы в его использовании все же есть, т.к. protected дефиниция позволяет унаследованным классам переопределять свойства и методы родительского класса.
    throw new Error 'It is not been implemented yet'

  @private: (typeDefinition, params, returnValue)->
    # like public but outter objects does not get data or call methods
    # если ключ объявлен с использованием
    # `private_key = Symbol('private_key')`
    # то естественно он доступен ТОЛЬКО внутри текущего класса, т.к. уникальный указатель на него находится в зоне видимости методов класса (и инстанса класса).
    throw new Error 'It is not been implemented yet'

module.exports = Core
