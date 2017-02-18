

class Core
  KEYWORDS = ['constructor', 'prototype', '__super__']
  cpmDefineInstanceDescriptors  = Symbol 'defineInstanceDescriptors'
  cpmDefineClassDescriptors     = Symbol 'defineClassDescriptors'
  cpmResetParentSuper           = Symbol 'resetParentSuper'

  @implements: ->

  @initialize: (Class)->
    Class ?= @
    # but maybe something will be here
    Class

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
      if mixin.__super__.constructor.name isnt 'Mixin'
        throw new Error 'Supplied mixin must be a subclass of RC::Mixin'

      __mixin = @[cpmResetParentSuper] mixin

      @__super__ = __mixin::

      @[cpmDefineClassDescriptors] __mixin
      @[cpmDefineInstanceDescriptors] __mixin::

      __mixin.including?.apply @
    @


module.exports = Core
