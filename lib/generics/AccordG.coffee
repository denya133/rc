

module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
    }
  } = Module::

  cache = new Map()

  Module.defineGeneric Generic 'AccordG', (AnyClass) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(AnyClass), -> "Invalid argument AnyClass #{assert.stringify AnyClass} supplied to AccordG(AnyClass) (expected a function)"

    if Module::TypeT.is AnyClass
      return AnyClass

    displayName = getTypeName AnyClass

    if (cachedType = cache.get displayName)?
      return cachedType

    Type = switch AnyClass
      when Function
        Module::['FunctionT']
      when String
        Module::['StringT']
      when Number
        Module::['NumberT']
      when Boolean
        Module::['BooleanT']
      when Date
        Module::['DateT']
      when Object
        Module::['ObjectT']
      when Array
        Module::['ArrayT']
      when Map
        Module::['MapT']
      when Set
        Module::['SetT']
      when RegExp
        Module::['RegExpT']
      when Symbol
        Module::['SymbolT']
      when Error
        Module::['ErrorT']
      when Promise, Module::Promise
        Module::['PromiseT']
      when Buffer
        Module::['BufferT']
      when (require 'stream')
        Module::['StreamT']
      when Generic
        Module::['GenericT']
      when (require 'events')
        Module::['EventEmitterT']
      when Module::ANY
        Module::['AnyT']
      when Module::NILL
        Module::['NilT']
      when Module::Class
        Module::['ClassT']
      when Module::Mixin
        Module::['MixinT']
      when Module::Module
        Module::['ModuleT']
      when Module::Interface
        Module::['InterfaceT']
      else
        AnyClass

    cache.set displayName, Type

    Type
