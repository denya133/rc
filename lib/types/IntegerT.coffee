

module.exports = (Module)->
  {
    SubtypeG
    NumberT
  } = Module::

  Module.defineType SubtypeG NumberT, 'IntegerT', (x)-> x % 1 is 0
