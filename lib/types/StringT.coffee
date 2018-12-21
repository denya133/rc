

module.exports = (Module)->
  {
    STRONG
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'StringT', ((x)-> _.isString x), STRONG
