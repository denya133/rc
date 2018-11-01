# этот тип нужен для описания асинхронной функции - созданной через async funcName() {}
# возможно нужно так же создать AsyncFuncG чтобы более подробно указывать типы аргументов и тип выходного значения в then который будет.
# для проверки нужно заиспользовать Object.getPrototypeOf(async function(){}).constructor
# НО используемая версия ноды 6.10 не поддерживает async/await, поддержка начинается с 7.6 - поэтому пока что этот тип остается не реализованным.


module.exports = (Module)->
  {
    SubtypeG
    FunctionT
  } = Module::

  Module.defineType SubtypeG FunctionT, 'AsyncFunctionT', (x)->
    # NOTE: только функции созданные через co.wrap пока что являются асинковыми
    x.__generatorFunction__?
