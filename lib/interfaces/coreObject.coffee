{SELF, NILL, ANY} = require '../Constants'
Interface = require '../Interface'


class CoreObjectInterface extends Interface
  # возможно эти методы надо убрать отсюда, и перенести в Core
  @public @static @virtual super: Function,
    agrs: [[String, NILL]]
    return: Function
  @public @virtual super: Function,
    args: [String]
    return: Function
  @public @static @virtual new: Function,
    args: ANY
    return: ANY
  @public @static @virtual moduleName: Function,
    args: []
    return: String

  # все что ниже наверно надо закоментировать и удалить. т.к. в Core объявлены методы @public, @private, @protected - которые должны дефайнить и проперти и методы.
  @public @static @virtual defineProperty: Function
  ,
    [name, definition]
  , -> return: NILL
  @public @static @virtual defineClassProperty: Function
  ,
    [name, definition]
  , -> return: NILL
  # @public @static @virtual defineGetter: Function
  # ,
  #   [aName, aDefault, aGetter]
  # , -> return: NILL
  # @public @static @virtual defineSetter: Function
  # ,
  #   [Class, aName, aSetter]
  # , -> return: NILL
  @public @static @virtual defineAccessor: Function
  ,
    [Class, aName, aDefault, aGetter, aSetter]
  , -> return: NILL
  # @public @static @virtual defineClassGetter: Function
  # ,
  #   [aName, aDefault, aGetter]
  # , -> return: NILL
  # @public @static @virtual defineClassSetter: Function
  # ,
  #   [Class, aName, aSetter]
  # , -> return: NILL
  @public @static @virtual defineClassAccessor: Function
  ,
    [Class, aName, aDefault, aGetter, aSetter]
  , -> return: NILL
  # @private @static functor: Function, [lambda], -> return: Function
  @public @static @virtual method: Function, [lambda], -> return: Function
  @public @static @virtual instanceMethod: Function, [methodName, lambda], -> return: Function
  @public @static @virtual classMethod: Function, [methodName, lambda], -> return: Function


module.exports = CoreObjectInterface.initialize()
