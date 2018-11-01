

module.exports = (Module)->
  {
    SubtypeG
    FunctionT
  } = Module::

  Module.defineType SubtypeG FunctionT, 'LambdaT', (x)-> yes
