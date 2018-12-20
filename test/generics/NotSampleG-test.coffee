{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  NotSampleG
} = RC::

describe 'NotSampleG', ->
  describe 'throw when checking instances', ->
    it 'throw when check !GreenCucumber201', ->
      expect ->
        class GreenCucumber201
        NotSampleG(GreenCucumber201) new GreenCucumber201
      .to.throw TypeError
    it 'throw when check !GreenCucumber202', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber202 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        NotSampleG(GreenCucumber202) GreenCucumber202.new()
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        NotSampleG(String) 'string'
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        NotSampleG(Number) 1
      .to.throw TypeError
    it 'throw when check NaN', ->
      expect ->
        NotSampleG(Number) NaN
      .to.throw TypeError
    it 'throw when check Infinity', ->
      expect ->
        NotSampleG(Number) Infinity
      .to.throw TypeError
    it 'throw when check date', ->
      expect ->
        NotSampleG(Date) new Date
      .to.throw TypeError
    it 'throw when check boolean yes', ->
      expect ->
        NotSampleG(Boolean) yes
      .to.throw TypeError
    it 'throw when check boolean no', ->
      expect ->
        NotSampleG(Boolean) no
      .to.throw TypeError
    it 'throw when check error', ->
      expect ->
        NotSampleG(Error) new Error
      .to.throw TypeError
    it 'throw when check map', ->
      expect ->
        NotSampleG(Map) new Map
      .to.throw TypeError
    it 'throw when check set', ->
      expect ->
        NotSampleG(Set) new Set
      .to.throw TypeError
    it 'throw when check buffer', ->
      expect ->
        NotSampleG(Buffer) Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        NotSampleG(Array) []
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        NotSampleG(Object) {}
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        NotSampleG(Function) (->)
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        NotSampleG(Promise) Promise.resolve()
      .to.throw TypeError
    it 'throw when check regexp', ->
      expect ->
        NotSampleG(RegExp) /.*/
      .to.throw TypeError



    it 'throw when check AnyT', ->
      expect ->
        new RC::AnyT()
      .to.throw TypeError
    it 'throw when check ArrayT', ->
      expect ->
        new RC::ArrayT()
      .to.throw TypeError
    it 'throw when check BooleanT', ->
      expect ->
        new RC::BooleanT()
      .to.throw TypeError
    it 'throw when check BufferT', ->
      expect ->
        new RC::BufferT()
      .to.throw TypeError
    it 'throw when check ClassT', ->
      expect ->
        new RC::ClassT()
      .to.throw TypeError
    it 'throw when check DateT', ->
      expect ->
        new RC::DateT()
      .to.throw TypeError
    it 'throw when check DictT', ->
      expect ->
        new RC::DictT()
      .to.throw TypeError
    it 'throw when check EnumT', ->
      expect ->
        new RC::EnumT()
      .to.throw TypeError
    it 'throw when check ErrorT', ->
      expect ->
        new RC::ErrorT()
      .to.throw TypeError
    it 'throw when check EventEmitterT', ->
      expect ->
        new RC::EventEmitterT()
      .to.throw TypeError
    it 'throw when check FunctionT', ->
      expect ->
        new RC::FunctionT()
      .to.throw TypeError
    it 'throw when check FunctorT', ->
      expect ->
        new RC::FunctorT()
      .to.throw TypeError
    it 'throw when check GeneratorFunctionT', ->
      expect ->
        new RC::GeneratorFunctionT()
      .to.throw TypeError
    it 'throw when check GeneratorT', ->
      expect ->
        new RC::GeneratorT()
      .to.throw TypeError
    it 'throw when check GenericT', ->
      expect ->
        new RC::GenericT()
      .to.throw TypeError
    it 'throw when check IntegerT', ->
      expect ->
        new RC::IntegerT()
      .to.throw TypeError
    it 'throw when check InterfaceT', ->
      expect ->
        new RC::InterfaceT()
      .to.throw TypeError
    it 'throw when check IntersectionT', ->
      expect ->
        new RC::IntersectionT()
      .to.throw TypeError
    it 'throw when check LambdaT', ->
      expect ->
        new RC::LambdaT()
      .to.throw TypeError
    it 'throw when check ListT', ->
      expect ->
        new RC::ListT()
      .to.throw TypeError
    it 'throw when check MapT', ->
      expect ->
        new RC::MapT()
      .to.throw TypeError
    it 'throw when check MaybeT', ->
      expect ->
        new RC::MaybeT()
      .to.throw TypeError
    it 'throw when check MixinT', ->
      expect ->
        new RC::MixinT()
      .to.throw TypeError
    it 'throw when check ModuleT', ->
      expect ->
        new RC::ModuleT()
      .to.throw TypeError
    it 'throw when check NilT', ->
      expect ->
        new RC::NilT()
      .to.throw TypeError
    it 'throw when check NumberT', ->
      expect ->
        new RC::NumberT()
      .to.throw TypeError
    it 'throw when check ObjectT', ->
      expect ->
        new RC::ObjectT()
      .to.throw TypeError
    it 'throw when check PointerT', ->
      expect ->
        new RC::PointerT()
      .to.throw TypeError
    it 'throw when check PromiseT', ->
      expect ->
        new RC::PromiseT()
      .to.throw TypeError
    it 'throw when check RegExpT', ->
      expect ->
        new RC::RegExpT()
      .to.throw TypeError
    it 'throw when check SetT', ->
      expect ->
        new RC::SetT()
      .to.throw TypeError
    it 'throw when check StreamT', ->
      expect ->
        new RC::StreamT()
      .to.throw TypeError
    it 'throw when check StringT', ->
      expect ->
        new RC::StringT()
      .to.throw TypeError
    it 'throw when check StructT', ->
      expect ->
        new RC::StructT()
      .to.throw TypeError
    it 'throw when check SymbolT', ->
      expect ->
        new RC::SymbolT()
      .to.throw TypeError
    it 'throw when check TupleT', ->
      expect ->
        new RC::TupleT()
      .to.throw TypeError
    it 'throw when check TypeT', ->
      expect ->
        new RC::TypeT()
      .to.throw TypeError
    it 'throw when check UnionT', ->
      expect ->
        new RC::UnionT()
      .to.throw TypeError



    it 'throw when check AsyncFuncG', ->
      expect ->
        new (RC::AsyncFuncG String, String)(-> yield return)
      .to.throw TypeError
    it 'throw when check DictG', ->
      expect ->
        new (RC::DictG String, String) key: 'value'
      .to.throw TypeError
    it 'throw when check EnumG', ->
      expect ->
        new (RC::EnumG 1, 2, 3) 1
      .to.throw TypeError
    it 'throw when check FuncG', ->
      expect ->
        new (RC::FuncG String, String)(->)
      .to.throw TypeError
    it 'throw when check InterfaceG', ->
      expect ->
        new (RC::InterfaceG key: String) key: 'value'
      .to.throw TypeError
    it 'throw when check IntersectionG', ->
      expect ->
        new (RC::IntersectionG Number, RC::IntegerT) 1
      .to.throw TypeError
    it 'throw when check ListG', ->
      expect ->
        new (RC::ListG String) []
      .to.throw TypeError
    it 'throw when check MapG', ->
      expect ->
        new (RC::MapG String, String) new Map
      .to.throw TypeError
    it 'throw when check MaybeG', ->
      expect ->
        new (RC::MaybeG String) 'string'
      .to.throw TypeError
    it 'throw when check SetG', ->
      expect ->
        new (RC::SetG String) new Set
      .to.throw TypeError
    it 'throw when check StructG', ->
      expect ->
        new (RC::StructG key: String) key: 'value'
      .to.throw TypeError
    it 'throw when check TupleG', ->
      expect ->
        new (RC::TupleG String, Number) ['string', 1]
      .to.throw TypeError
    it 'throw when check UnionG', ->
      expect ->
        new (RC::UnionG String, Number) 'string'
      .to.throw TypeError
