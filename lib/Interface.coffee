Core  = require './Core'

###
```coffee
RC = require 'RC'
{SELF, NILL, ANY, CLASS} = RC::Constants


class CucumberInterface extends RC::Interface
  @public color:              String
  @public length:             Number
  @public culculateSomeText:  Function
  ,
    [
      text: String
    ,
      options: Object
    ]
  , ->
    return: NILL
  @protected convertColor: Function, [color: String], -> return: [String, NILL]


class TomatoInterface extends RC::Interface
  @public color:              String
  @public length:             Number
  @private cucumber:          CucumberInterface
  @protected processAmount:   Function, [], -> return: CucumberInterface


class Cucumber extends RC::CoreObject
  @implements CucumberInterface

class Tomato extends RC::CoreObject
  @implements TomatoInterface
```
###


class Interface extends Core
  # метод, чтобы объявить виртуальный (скорее всего) метод, если не указан тип, значит это виртуальный атрибут, т.к. если бы это была виртуальная функция, то тип был бы явно указан Function
  @virtual: (typeDefinition)->

  # метод чтобы объявить атрибут или метод класса
  @static: (typeDefinition, params, returnValue)->

  # методы с такими же названиями будут объявлены в CoreObject
  # но реализоация у них будет другая. В Interface эти методы должны в специальные проперти положить результаты их вызовов при формировании классов-интерфейсов, однако реализация этих методов в CoreObject будет дефайнить реальные атрибуты и методы инстанса и самого класса. (своего рода перегрузка)
  @public: (typeDefinition, params, returnValue)->
    key = Object.keys(typeDefinition)[0]
    Type = typeDefinition[key]
    isFunction = Type is Function
    if isFunction
      functionArguments = params
      return {key, Type, functionArguments, returnValue}
    else
      return {key, Type}

  @protected: (typeDefinition, params, returnValue)->
    # like public but outter objects does not get data or call methods
    # если ключ объявлен с использованием
    # `protected_key = Symbol.for('protected_key')`
    # то естественно он доступен и внутри текущего класса, т.к. указатель на него находится в зоне видимости методов класса (и инстанса класса).
    # но также в унаследованных классах есть возможность получить этот же Символ
    # чтобы обратиться к этому же проперти.
    # Плюсы в его использовании все же есть, т.к. protected дефиниция позволяет унаследованным классам переопределять свойства и методы родительского класса.
    throw new Error 'It is not been implemented yet'

  @private: (typeDefinition, params, returnValue)->
    # like public but outter objects does not get data or call methods
    # если ключ объявлен с использованием
    # `private_key = Symbol('private_key')`
    # то естественно он доступен ТОЛЬКО внутри текущего класса, т.к. уникальный указатель на него находится в зоне видимости методов класса (и инстанса класса).
    throw new Error 'It is not been implemented yet'

module.exports = Interface.initialize()
