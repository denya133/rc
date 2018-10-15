

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'StructT', (x)->
    x.meta.kind is 'interface' and x.meta.strict is yes
