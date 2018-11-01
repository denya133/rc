# нужен, чтобы предоставить абстракцию промиса как такового. с виртуальными методами.
# по коду будут использоваться и иметь схожее с обычными промисами апи.
# инициализироваться они будут по разному (для ноды, в декоратор будет засовываться нативный промис, а для аранги, специальный объект, предоставляемый отдельным npm-пакетом, реализация которого будет строго синхронной для совместимости с платформой arangodb)

###
A Promise is in one of these states:

pending: initial state, not fulfilled or rejected.
fulfilled: meaning that the operation completed successfully.
rejected: meaning that the operation failed.
###


module.exports = (Module) ->
  {
    Interface
    FuncG
    MaybeG
    AnyT
    PromiseT
  } = Module::

  class PromiseInterface extends Interface
    @inheritProtected()
    @module Module

    @virtual catch: FuncG Function, PromiseT
    @virtual 'then': FuncG [Function, MaybeG Function], PromiseT
    @virtual finally: FuncG Function, PromiseT

    @virtual @static all: FuncG Array, PromiseT
    @virtual @static reject: FuncG Error, PromiseT
    @virtual @static resolve: FuncG AnyT, PromiseT
    @virtual @static race: FuncG Array, PromiseT


    @initialize()
