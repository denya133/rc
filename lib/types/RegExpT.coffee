

module.exports = (Module)->
  {
    WEAK
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'RegExpT', ((x)-> t.RegExp.is x), WEAK
