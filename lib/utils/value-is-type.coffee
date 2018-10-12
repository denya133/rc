

module.exports = (Module) ->
  Module.util valueIsType: (x, type)->
    if Module::TypeT.is type
      return type.is x
    return x instanceof type
