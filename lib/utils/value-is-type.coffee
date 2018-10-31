

module.exports = (Module) ->
  {
    PRODUCTION
    Utils: { _, t: { assert }, instanceOf }
  } = Module::

  Module.util valueIsType: (x, Type)->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to valueIsType(x, Type) (expected a function)"

    if Module::TypeT.is Type
      return Type.is x

    if (nonCustomType = Module::AccordG Type) isnt Type
      return nonCustomType.is x

    instanceOf x, Type
