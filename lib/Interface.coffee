

# смысл интерфейса, чтобы объявить публичные виртуальные методы (и/или) проперти
# сами они должны быть реализованы в тех классах, куда подмешаны интерфейсы
# !!! Вопрос: а надо ли указывать типы аргументов и возвращаемого значения в декларации методов в интерфейсе если эти методы виртуальные???????????
# !!! Ответ: т.к. это интерфейсы дефиниции методов должны быть полностью задекларированы, чтобы реализации строго соотвествовали сигнатурам методов интерфейса.
# если в интерфейсе объявлен тип выходного значения как ANY то проверку можно сделать строже, объявив конкретный тип в реализации метода в самом классе.

###
```coffee
RC = require 'RC'
{SELF, NILL, ANY} = RC::Constants

# every definition public and virtual only (can be static optionaly)
class CucumberInterface extends RC::Interface
  @public @virtual color:               String
  @public @virtual length:              Number
  @public @virtual culculateSomeText:   Function,
    args: [String, Object]
    return: NILL

# every definition public and virtual only (can be static optionaly)
class TomatoInterface extends RC::Interface
  @public @virtual color:              String
  @public @virtual length:             Number


class Cucumber extends RC::CoreObject
  @implements CucumberInterface

  @public color: String
    default: 'red'
  @public length: Number
    default: 0
  @public culculateSomeText: Function,
    default: (text, options)-> # some code
  ipmConvertColor = @protected convertColor: Function,
    args: [String]
    return: [String, NILL]
    default: (color)-> # some code

class Tomato extends RC::CoreObject
  @implements TomatoInterface

  @public color: String
  @public length: Number
  ipoCucumber = @private cucumber: Cucumber
  ipmProcessAmount = @protected processAmount: Function,
    args: []
    return: Cucumber
    default: -> # some code
```
###

Core  = require './Core'
{SELF, NILL, ANY} = require '../Constants'


class Interface extends Core


module.exports = Interface.initialize()
