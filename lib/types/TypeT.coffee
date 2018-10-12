# по задумке это тип всех типов (интерфейсов от AnyT до SymbolT)
# он нужен для того, чтобы при вызове метода можно было проверить аргумент, в качестве которого передан один из существующих типов.


module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'TypeT', (x)->
    _.isFunction(x) and _.isPlainObject(x.meta) and x.meta.kind isnt 'generic'
