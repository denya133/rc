

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'NumberT', (x)-> 
    _.isNumber(x) and isFinite(x) and not isNaN(x)
