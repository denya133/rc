

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

    if AnyClass in [
      Module::ANY
      Module::NILL
      Module::LAMBDA
      Promise, Module::Promise
      Generic
      Module::Class
      Module::Mixin
      Module::Module
      Module::Interface
    ]
      displayName = getTypeName AnyClass
      if (cachedType = cache.get displayName)?
        return cachedType
      Type = switch AnyClass
        when Module::ANY
          Module::['AnyT']
        when Module::NILL
          Module::['NilT']
        when Module::LAMBDA
          Module::['LambdaT']
        when Promise, Module::Promise
          Module::['PromiseT']
        when Generic
          Module::['GenericT']
        when Module::Class
          Module::['ClassT']
        when Module::Mixin
          Module::['MixinT']
        when Module::Module
          Module::['ModuleT']
        when Module::Interface
          Module::['InterfaceT']
      cache.set displayName, Type
      return Type

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
      when Buffer
        Module::['BufferT']
      when (require 'stream')
        Module::['StreamT']
      when (require 'events')
        Module::['EventEmitterT']
      else
        AnyClass

    cache.set displayName, Type

    Type
