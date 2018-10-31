

module.exports = (Module) ->
  {
    Utils: { _ }
  } = Module::

  Module.util instanceOf: (x, Type)->
    return no unless x?
    switch Type
      when String
        _.isString x
      when Number
        _.isNumber x
      when Boolean
        _.isBoolean x
      when Array
        _.isArray x
      when Object
        _.isPlainObject x
      when Date
        _.isDate x
      else
        do (a = x)->
          while a = a.__proto__
            if a is Type.prototype
              return yes
          return no
