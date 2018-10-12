

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _, t }
  } = Module::

  Module.defineType IrreducibleG 'ModuleT', (x)->
    _.isFunction(x) and _.isPlainObject(x.meta) and x.meta.kind is 'module'
