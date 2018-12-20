{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  NilT, AnyT
  StringT, NumberT, IntegerT, BooleanT, ObjectT, ArrayT
  GeneratorFunctionT, GeneratorT, FunctionT, AsyncFunctionT, FunctorT
  TupleT, MapT, DictT, SetT, ListT, TypeT
  ClassT, ModuleT, InterfaceT, MixinT, GenericT
  InterfaceG, AccordG, AsyncFuncG, FuncG, TupleG, MapG, DictG, SetG, ListG, EnumG, IrreducibleG, IntersectionG, UnionG, MaybeG, SubsetG, NotSampleG
  Interface, PromiseInterface, CoreObject, ChainsMixin
  Utils: { isSubsetOf }
} = RC::

describe 'SubsetG', ->
  describe 'create new Type', ->
    subsetOfClass = SubsetG CoreObject
    name = '<< CoreObject'
    it 'check type of subset type', ->
      expect ->
        TypeT subsetOfClass
      .to.not.throw TypeError
    it 'check name of subset type', ->
      expect subsetOfClass.name
      .to.equal name
    it 'check displayName of subset type', ->
      expect subsetOfClass.displayName
      .to.equal name
    it 'check isNotSample of subset type', ->
      expect isSubsetOf(subsetOfClass.isNotSample, NotSampleG subsetOfClass)
      .to.be.true
  describe 'checking NilT and AnyT', ->
    it 'compare equal types', ->
      expect ->
        SubsetG(NilT) NilT
      .to.not.throw TypeError
    it 'compare NilT with AnyT', ->
      expect ->
        SubsetG(AnyT) NilT
      .to.throw TypeError
    it 'compare not NilT with AnyT', ->
      expect ->
        SubsetG(AnyT) StringT
      .to.not.throw TypeError

  describe 'checking type with MaybeG', ->
    it 'compare NilT with MaybeG Number', ->
      expect ->
        SubsetG(MaybeG Number) NilT
      .to.not.throw TypeError
    it 'compare NumberT with MaybeG Number', ->
      expect ->
        SubsetG(MaybeG Number) NumberT
      .to.not.throw TypeError

  describe 'checking type with UnionG', ->
    it 'compare BooleanT with UnionG Number, Boolean', ->
      expect ->
        SubsetG(UnionG Number, Boolean) BooleanT
      .to.not.throw TypeError
    it 'compare NumberT with UnionG Number, Boolean', ->
      expect ->
        SubsetG(UnionG Number, Boolean) NumberT
      .to.not.throw TypeError

  describe 'checking type with IntersectionG', ->
    it 'compare IntegerT with IntersectionG Number, IntegerT', ->
      expect ->
        SubsetG(IntersectionG Number, IntegerT) IntegerT
      .to.not.throw TypeError

  describe 'checking two MaybeG', ->
    it 'compare MaybeG IntegerT with MaybeG Number', ->
      expect ->
        SubsetG(MaybeG Number) MaybeG(IntegerT)
      .to.not.throw TypeError

  describe 'checking UnionG type', ->
    it 'compare UnionG(DictT, FunctorT, TupleT) with TypeT', ->
      expect ->
        SubsetG(TypeT) UnionG(DictT, FunctorT, TupleT)
      .to.not.throw TypeError

  describe 'checking IntersectionG type', ->
    it 'compare IntersectionG(Number, IntegerT) with NumberT', ->
      expect ->
        SubsetG(NumberT) IntersectionG(IntegerT, Number)
      .to.not.throw TypeError

  describe 'checking IrreducibleG type', ->
    it 'compare two equal irreducible types', ->
      predicate = (x)-> /^t.*/.test x
      T1 = IrreducibleG 'T1', predicate
      T2 = IrreducibleG 'T2', predicate
      expect ->
        SubsetG(T2) T1
      .to.not.throw TypeError
      expect ->
        SubsetG(T1) T2
      .to.not.throw TypeError

    it 'compare two not equal irreducible types', ->
      expect ->
        SubsetG(NumberT) StringT
      .to.throw TypeError

  describe 'checking EnumG type', ->
    it 'compare EnumG(1, 2, 3) with NumberT', ->
      expect ->
        SubsetG(NumberT) EnumG(1, 2, 3)
      .to.not.throw TypeError

  describe 'checking subtype', ->
    it 'compare AsyncFunctionT with FunctionT', ->
      expect ->
        SubsetG(FunctionT) AsyncFunctionT
      .to.not.throw TypeError

  describe 'checking list type', ->
    it 'compare ListG(Number) with ArrayT', ->
      expect ->
        SubsetG(ArrayT) ListG(Number)
      .to.not.throw TypeError
    it 'compare ListG(Number) with ListT', ->
      expect ->
        SubsetG(ListT) ListG(Number)
      .to.not.throw TypeError
    it 'compare ListG(IntegerT) with ListG(Number)', ->
      expect ->
        SubsetG(ListG(Number)) ListG(IntegerT)
      .to.not.throw TypeError

  describe 'checking set type', ->
    it 'compare SetG(Number) with SetT', ->
      expect ->
        SubsetG(SetT) SetG(Number)
      .to.not.throw TypeError
    it 'compare SetG(IntegerT) with SetG(Number)', ->
      expect ->
        SubsetG(SetG(Number)) SetG(IntegerT)
      .to.not.throw TypeError

  describe 'checking dict type', ->
    it 'compare DictG(String, Number) with ObjectT', ->
      expect ->
        SubsetG(ObjectT) DictG(String, Number)
      .to.not.throw TypeError
    it 'compare DictG(String, Number) with DictT', ->
      expect ->
        SubsetG(DictT) DictG(String, Number)
      .to.not.throw TypeError
    it 'compare DictG(String, IntegerT) with DictG(String, Number)', ->
      expect ->
        SubsetG(DictG(String, Number)) DictG(String, IntegerT)
      .to.not.throw TypeError

  describe 'checking map type', ->
    it 'compare MapG(String, Number) with MapT', ->
      expect ->
        SubsetG(MapT) MapG(String, Number)
      .to.not.throw TypeError
    it 'compare MapG(Object, ListG Number) with MapG(Object, Array)', ->
      expect ->
        SubsetG(MapG(Object, Array)) MapG(Object, ListG Number)
      .to.not.throw TypeError

  describe 'checking tuple type', ->
    it 'compare TupleG(Number, Number) with ArrayT', ->
      expect ->
        SubsetG(ArrayT) TupleG(Number, Number)
      .to.not.throw TypeError
    it 'compare TupleG(Number, Number) with TupleT', ->
      expect ->
        SubsetG(TupleT) TupleG(Number, Number)
      .to.not.throw TypeError
    it 'compare TupleG(IntegerT, IntegerT) with TupleG(Number, Number)', ->
      expect ->
        SubsetG(TupleG(Number, Number)) TupleG(IntegerT, IntegerT)
      .to.not.throw TypeError

  describe 'checking func type', ->
    it 'compare FuncG(String, Number) with FunctionT', ->
      expect ->
        SubsetG(FunctionT) FuncG(String, Number)
      .to.not.throw TypeError
    it 'compare FuncG(Object, ListG Number) with FuncG(Object, Array)', ->
      expect ->
        SubsetG(FuncG(Object, Array)) FuncG(Object, ListG Number)
      .to.not.throw TypeError

  describe 'checking async type', ->
    it 'compare AsyncFuncG(String, Number) with FunctionT', ->
      expect ->
        SubsetG(FunctionT) AsyncFuncG(String, Number)
      .to.not.throw TypeError
    it 'compare AsyncFuncG(Object, ListG Number) with AsyncFuncG(Object, Array)', ->
      expect ->
        SubsetG(AsyncFuncG(Object, Array)) AsyncFuncG(Object, ListG Number)
      .to.not.throw TypeError

  describe 'checking generic type', ->
    it 'compare AccordG with FunctionT', ->
      expect ->
        SubsetG(FunctionT) AccordG
      .to.not.throw TypeError
    it 'compare AccordG with GenericT', ->
      expect ->
        SubsetG(GenericT) AccordG
      .to.not.throw TypeError

  describe 'checking mixin type', ->
    it 'compare ChainsMixin with FunctionT', ->
      expect ->
        SubsetG(FunctionT) ChainsMixin
      .to.not.throw TypeError
    it 'compare ChainsMixin with MixinT', ->
      expect ->
        SubsetG(MixinT) ChainsMixin
      .to.not.throw TypeError

  describe 'checking module type', ->
    it 'compare RC with FunctionT', ->
      expect ->
        SubsetG(FunctionT) RC
      .to.not.throw TypeError
    it 'compare RC with ModuleT', ->
      expect ->
        SubsetG(ModuleT) RC
      .to.not.throw TypeError
    it 'compare custom module with RC::Module', ->
      class TestModule extends RC
        @inheritProtected()
        @root __dirname
        @public @static kind: String
        @public prop: Number
        @initialize()
      class OnionInterface extends Interface
        @inheritProtected()
        @module TestModule
        @virtual @static kind: String
        @virtual prop: Number
        @initialize()
      expect ->
        SubsetG(RC::Module) TestModule
      .to.not.throw TypeError
      expect ->
        SubsetG(RC) TestModule
      .to.not.throw TypeError
      expect ->
        SubsetG(InterfaceG(prop: Number)) TestModule
      .to.throw TypeError
      expect ->
        SubsetG(OnionInterface) TestModule
      .to.not.throw TypeError

  describe 'checking class type', ->
    it 'compare CoreObject with FunctionT', ->
      expect ->
        SubsetG(FunctionT) CoreObject
      .to.not.throw TypeError
    it 'compare CoreObject with ClassT', ->
      expect ->
        SubsetG(ClassT) CoreObject
      .to.not.throw TypeError
    it 'compare custom module with CoreObject', ->
      class TestModule extends RC
        @inheritProtected()
        @root __dirname
        @initialize()
      class OnionInterface extends Interface
        @inheritProtected()
        @module TestModule
        @virtual @static kind: String
        @virtual prop: Number
        @initialize()
      class Tomato extends CoreObject
        @inheritProtected()
        @module TestModule
        @public @static kind: String
        @initialize()
      class Cucumber extends Tomato
        @inheritProtected()
        @module TestModule
        @public prop: Number
        @initialize()
      expect ->
        SubsetG(CoreObject) Cucumber
      .to.not.throw TypeError
      expect ->
        SubsetG(InterfaceG(prop: Number)) Cucumber
      .to.throw TypeError
      expect ->
        SubsetG(OnionInterface) Cucumber
      .to.not.throw TypeError

  describe 'checking interface type', ->
    it 'compare InterfaceG(size: Number) with ObjectT', ->
      expect ->
        SubsetG(ObjectT) InterfaceG(size: Number)
      .to.not.throw TypeError
    it 'compare InterfaceG(size: Number) with InterfaceT', ->
      expect ->
        SubsetG(InterfaceT) InterfaceG(size: Number)
      .to.not.throw TypeError
    it 'compare PromiseInterface with ObjectT', ->
      expect ->
        SubsetG(ObjectT) PromiseInterface
      .to.not.throw TypeError
    it 'compare PromiseInterface with InterfaceT', ->
      expect ->
        SubsetG(InterfaceT) PromiseInterface
      .to.not.throw TypeError
    it 'compare InterfaceG(color: Number, name: String) with InterfaceG(color: Number)', ->
      expect ->
        SubsetG(InterfaceG(color: Number)) InterfaceG(color: Number, name: String)
      .to.not.throw TypeError
    it 'compare custom module with CoreObject', ->
      class TestModule extends RC
        @inheritProtected()
        @root __dirname
        @initialize()
      class TomatoInterface extends Interface
        @inheritProtected()
        @module TestModule
        @virtual @static kind: String
        @virtual name: String
        @initialize()
      class CucumberInterface extends Interface
        @inheritProtected()
        @module TestModule
        @virtual @static kind: String
        @virtual name: String
        @virtual color: Number
        @initialize()
      expect ->
        SubsetG(TomatoInterface) CucumberInterface
      .to.not.throw TypeError
