{SELF, NILL, ANY, CLASS} = require '../Constants'
Interface = require '../Interface'


class CoreObjectInterface extends Interface
  @public @static super: Function
  ,
    [
      methodName: [String, NILL]
    ]
  , -> return: Function
  @public super: Function, [methodName: String], -> return: Function
  @public @static new: Function, ANY, -> return: CoreObjectInterface

  @public @static defineProperty: Function
  ,
    [name, definition]
  , -> return: NILL
  @public @static defineClassProperty: Function
  ,
    [name, definition]
  , -> return: NILL
  @public @static defineGetter: Function
  ,
    [aName, aDefault, aGetter]
  , -> return: NILL
  @public @static defineSetter: Function
  ,
    [Class, aName, aSetter]
  , -> return: NILL
  @public @static defineAccessor: Function
  ,
    [Class, aName, aDefault, aGetter, aSetter]
  , -> return: NILL
  @public @static defineClassGetter: Function
  ,
    [aName, aDefault, aGetter]
  , -> return: NILL
  @public @static defineClassSetter: Function
  ,
    [Class, aName, aSetter]
  , -> return: NILL
  @public @static defineClassAccessor: Function
  ,
    [Class, aName, aDefault, aGetter, aSetter]
  , -> return: NILL
  @private @static functor: Function, [lambda], -> return: Function
  @public @static method: Function, [lambda], -> return: Function
  @public @static instanceMethod: Function, [methodName, lambda], -> return: Function
  @public @static classMethod: Function, [methodName, lambda], -> return: Function


module.exports = CoreObjectInterface.initialize()
