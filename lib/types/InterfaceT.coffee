

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'InterfaceT', (x)->
    x.meta.kind is 'interface' and x.meta.strict is no
