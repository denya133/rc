

module.exports = (RC)->
# all classes will be instances of this (CucumberController.constructor is Class)
  class RC::Class extends RC::CoreObject
    @inheritProtected()
    KEYWORDS = ['constructor', 'prototype', '__super__']
    @new: (name, object)->
      vClass = eval "(
        function() {
          function #{name}() {
            #{name}.__super__.constructor.apply(this, arguments);
          }
          return #{name};
      })();"
      for own k, v of RC::CoreObject when k isnt 'including'
        vClass[k] = v
      for own _k, _v of (RC::CoreObject::) when _k not in KEYWORDS
        vClass::[_k] = _v

      reserved_words = Object.keys RC::CoreObject
      for own k, v of object.ClassMethods when k not in reserved_words
        vClass[k] = v
      for own _k, _v of object.InstanceMethods when _k not in KEYWORDS
        vClass::[_k] = _v
      vClass.Module = object.Module  if object.Module?

      baseSymbols = Object.getOwnPropertySymbols RC::CoreObject
      for key in baseSymbols
        do (key) =>
          descriptor = Object.getOwnPropertyDescriptor RC::CoreObject, key
          Reflect.defineProperty vClass, key, descriptor
      vClass::constructor.__super__ = RC::CoreObject::
      return vClass

    # надо объявить и методы из Class и из Module
  RC::Class.constructor = RC::Class
  return RC::Class
