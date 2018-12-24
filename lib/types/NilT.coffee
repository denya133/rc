

module.exports = (Module)->
  {
    STRONG
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'NilT', ((x)-> t.Nil.is x), STRONG
