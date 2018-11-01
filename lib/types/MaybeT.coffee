

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'MaybeT', (x)-> x.meta.kind is 'maybe'
