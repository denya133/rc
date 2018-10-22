{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  TypeT
} = RC::

describe 'TypeT', ->
  describe 'checking TypeT', ->
    it 'check type of Interface', ->
      expect ->
        TypeT RC::Interface
      .to.not.throw TypeError
    it 'check type of InterfaceG', ->
      expect ->
        TypeT RC::InterfaceG name: String
      .to.not.throw TypeError
    it 'check type of custom Interface', ->
      expect ->
        TypeT RC::StateMachineInterface
      .to.not.throw TypeError
    it 'check type of AnyT', ->
      expect ->
        TypeT RC::AnyT
      .to.not.throw TypeError
    it 'check type of ArrayT', ->
      expect ->
        TypeT RC::ArrayT
      .to.not.throw TypeError
    it 'check type of BooleanT', ->
      expect ->
        TypeT RC::BooleanT
      .to.not.throw TypeError
    it 'check type of BufferT', ->
      expect ->
        TypeT RC::BufferT
      .to.not.throw TypeError
    it 'check type of ClassT', ->
      expect ->
        TypeT RC::ClassT
      .to.not.throw TypeError
    it 'check type of DateT', ->
      expect ->
        TypeT RC::DateT
      .to.not.throw TypeError
    it 'check type of DictT', ->
      expect ->
        TypeT RC::DictT
      .to.not.throw TypeError
    it 'check type of EnumT', ->
      expect ->
        TypeT RC::EnumT
      .to.not.throw TypeError
    it 'check type of ErrorT', ->
      expect ->
        TypeT RC::ErrorT
      .to.not.throw TypeError
    it 'check type of EventEmitterT', ->
      expect ->
        TypeT RC::EventEmitterT
      .to.not.throw TypeError
    it 'check type of FunctionT', ->
      expect ->
        TypeT RC::FunctionT
      .to.not.throw TypeError
    it 'check type of FunctorT', ->
      expect ->
        TypeT RC::FunctorT
      .to.not.throw TypeError
    it 'check type of GeneratorFunctionT', ->
      expect ->
        TypeT RC::GeneratorFunctionT
      .to.not.throw TypeError
    it 'check type of GeneratorT', ->
      expect ->
        TypeT RC::GeneratorT
      .to.not.throw TypeError
    it 'check type of GenericT', ->
      expect ->
        TypeT RC::GenericT
      .to.not.throw TypeError
    it 'check type of IntegerT', ->
      expect ->
        TypeT RC::IntegerT
      .to.not.throw TypeError
    it 'check type of InterfaceT', ->
      expect ->
        TypeT RC::InterfaceT
      .to.not.throw TypeError
    it 'check type of IntersectionT', ->
      expect ->
        TypeT RC::IntersectionT
      .to.not.throw TypeError
    it 'check type of LambdaT', ->
      expect ->
        TypeT RC::LambdaT
      .to.not.throw TypeError
    it 'check type of ListT', ->
      expect ->
        TypeT RC::ListT
      .to.not.throw TypeError
    it 'check type of MapT', ->
      expect ->
        TypeT RC::MapT
      .to.not.throw TypeError
    it 'check type of MaybeT', ->
      expect ->
        TypeT RC::MaybeT
      .to.not.throw TypeError
    it 'check type of MixinT', ->
      expect ->
        TypeT RC::MixinT
      .to.not.throw TypeError
    it 'check type of ModuleT', ->
      expect ->
        TypeT RC::ModuleT
      .to.not.throw TypeError
    it 'check type of NilT', ->
      expect ->
        TypeT RC::NilT
      .to.not.throw TypeError
    it 'check type of NumberT', ->
      expect ->
        TypeT RC::NumberT
      .to.not.throw TypeError
    it 'check type of ObjectT', ->
      expect ->
        TypeT RC::ObjectT
      .to.not.throw TypeError
    it 'check type of PointerT', ->
      expect ->
        TypeT RC::PointerT
      .to.not.throw TypeError
    it 'check type of PromiseT', ->
      expect ->
        TypeT RC::PromiseT
      .to.not.throw TypeError
    it 'check type of RegExpT', ->
      expect ->
        TypeT RC::RegExpT
      .to.not.throw TypeError
    it 'check type of SetT', ->
      expect ->
        TypeT RC::SetT
      .to.not.throw TypeError
    it 'check type of StreamT', ->
      expect ->
        TypeT RC::StreamT
      .to.not.throw TypeError
    it 'check type of StringT', ->
      expect ->
        TypeT RC::StringT
      .to.not.throw TypeError
    it 'check type of StructT', ->
      expect ->
        TypeT RC::StructT
      .to.not.throw TypeError
    it 'check type of SymbolT', ->
      expect ->
        TypeT RC::SymbolT
      .to.not.throw TypeError
    it 'check type of TupleT', ->
      expect ->
        TypeT RC::TupleT
      .to.not.throw TypeError
    it 'check type of TypeT', ->
      expect ->
        TypeT RC::TypeT
      .to.not.throw TypeError
    it 'check type of UnionT', ->
      expect ->
        TypeT RC::UnionT
      .to.not.throw TypeError
  describe 'throw when check not TypeT', ->
    it 'throw when check new Error', ->
      expect ->
        TypeT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        TypeT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        TypeT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        TypeT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        TypeT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        TypeT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        TypeT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        TypeT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        TypeT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        TypeT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        TypeT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        TypeT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        TypeT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        TypeT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        TypeT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        TypeT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        TypeT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        TypeT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        TypeT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        TypeT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        TypeT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        TypeT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        TypeT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        TypeT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        TypeT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        TypeT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        TypeT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        TypeT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        TypeT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        TypeT new Readable()
        TypeT new Writable()
        TypeT new Duplex()
        TypeT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        TypeT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        TypeT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        TypeT class Cucumber
      .to.throw TypeError
    it 'throw when check class inherited from RC::CoreObject', ->
      expect ->
        TypeT class Cucumber extends RC::CoreObject
      .to.throw TypeError
    it 'throw when check module', ->
      expect ->
        TypeT RC::Module
      .to.throw TypeError
    it 'throw when check custom module', ->
      expect ->
        TypeT RC
      .to.throw TypeError
    it 'throw when check mixin', ->
      expect ->
        TypeT RC::ChainsMixin
      .to.throw TypeError
    it 'throw when check generic', ->
      expect ->
        TypeT RC::Generic
      .to.throw TypeError
    it 'throw when check custom generic', ->
      expect ->
        TypeT RC::TupleG
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        TypeT new Cucumber
      .to.throw TypeError
