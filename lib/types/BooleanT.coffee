

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'BooleanT', (x)-> _.isBoolean x
