

module.exports = (Module)->
  {
    STRONG
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'BooleanT', ((x)-> _.isBoolean x), STRONG
