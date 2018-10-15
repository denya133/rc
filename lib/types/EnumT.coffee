

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'EnumT', (x)-> x.meta.kind is 'enums'
