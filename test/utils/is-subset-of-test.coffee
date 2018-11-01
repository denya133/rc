{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  isSubsetOf
  NilT, AnyT
  StringT, NumberT, IntegerT, BooleanT, ObjectT, ArrayT
  GeneratorFunctionT, GeneratorT, FunctionT, AsyncFunctionT, FunctorT
  TupleT, MapT, DictT, SetT, ListT, TypeT
  ClassT, ModuleT, InterfaceT, MixinT, GenericT
  InterfaceG, AccordG, AsyncFuncG, FuncG, TupleG, MapG, DictG, SetG, ListG, EnumG, IrreducibleG, IntersectionG, UnionG, MaybeG
  Interface, PromiseInterface, CoreObject, ChainsMixin
} = RC::

describe 'Utils.isSubsetOf', ->
  describe 'checking NilT and AnyT', ->
    it 'compare equal types', ->
      expect isSubsetOf NilT, NilT
      .to.equal yes
    it 'compare NilT with AnyT', ->
      expect isSubsetOf NilT, AnyT
      .to.equal no
    it 'compare not NilT with AnyT', ->
      expect isSubsetOf StringT, AnyT
      .to.equal yes

  describe 'checking type with MaybeG', ->
    it 'compare NilT with MaybeG Number', ->
      expect isSubsetOf NilT, MaybeG Number
      .to.equal yes
    it 'compare NumberT with MaybeG Number', ->
      expect isSubsetOf NumberT, MaybeG Number
      .to.equal yes

  describe 'checking type with UnionG', ->
    it 'compare BooleanT with UnionG Number, Boolean', ->
      expect isSubsetOf BooleanT, UnionG Number, Boolean
      .to.equal yes
    it 'compare NumberT with UnionG Number, Boolean', ->
      expect isSubsetOf NumberT, UnionG Number, Boolean
      .to.equal yes

  describe 'checking type with IntersectionG', ->
    it 'compare IntegerT with IntersectionG Number, IntegerT', ->
      expect isSubsetOf IntegerT, IntersectionG Number, IntegerT
      .to.equal yes

  describe 'checking two MaybeG', ->
    it 'compare MaybeG IntegerT with MaybeG Number', ->
      expect isSubsetOf MaybeG(IntegerT), MaybeG Number
      .to.equal yes

  describe 'checking UnionG type', ->
    it 'compare UnionG(DictT, FunctorT, TupleT) with TypeT', ->
      expect isSubsetOf UnionG(DictT, FunctorT, TupleT), TypeT
      .to.equal yes

  describe 'checking IntersectionG type', ->
    it 'compare IntersectionG(Number, IntegerT) with NumberT', ->
      expect isSubsetOf IntersectionG(IntegerT, Number), NumberT
      .to.equal yes

  describe 'checking IrreducibleG type', ->
    it 'compare two equal irreducible types', ->
      predicate = (x)-> /^t.*/.test x
      T1 = IrreducibleG 'T1', predicate
      T2 = IrreducibleG 'T2', predicate
      expect isSubsetOf T1, T2
      .to.equal yes

    it 'compare two not equal irreducible types', ->
      expect isSubsetOf StringT, NumberT
      .to.equal no

  describe 'checking EnumG type', ->
    it 'compare EnumG(1, 2, 3) with NumberT', ->
      expect isSubsetOf EnumG(1, 2, 3), NumberT
      .to.equal yes

  describe 'checking subtype', ->
    it 'compare AsyncFunctionT with FunctionT', ->
      expect isSubsetOf AsyncFunctionT, FunctionT
      .to.equal yes

  describe 'checking list type', ->
    it 'compare ListG(Number) with ArrayT', ->
      expect isSubsetOf ListG(Number), ArrayT
      .to.equal yes
    it 'compare ListG(Number) with ListT', ->
      expect isSubsetOf ListG(Number), ListT
      .to.equal yes
    it 'compare ListG(IntegerT) with ListG(Number)', ->
      expect isSubsetOf ListG(IntegerT), ListG(Number)
      .to.equal yes

  describe 'checking set type', ->
    it 'compare SetG(Number) with SetT', ->
      expect isSubsetOf SetG(Number), SetT
      .to.equal yes
    it 'compare SetG(IntegerT) with SetG(Number)', ->
      expect isSubsetOf SetG(IntegerT), SetG(Number)
      .to.equal yes

  describe 'checking dict type', ->
    it 'compare DictG(String, Number) with ObjectT', ->
      expect isSubsetOf DictG(String, Number), ObjectT
      .to.equal yes
    it 'compare DictG(String, Number) with DictT', ->
      expect isSubsetOf DictG(String, Number), DictT
      .to.equal yes
    it 'compare DictG(String, IntegerT) with DictG(String, Number)', ->
      expect isSubsetOf DictG(String, IntegerT), DictG(String, Number)
      .to.equal yes

  describe 'checking map type', ->
    it 'compare MapG(String, Number) with MapT', ->
      expect isSubsetOf MapG(String, Number), MapT
      .to.equal yes
    it 'compare MapG(Object, ListG Number) with MapG(Object, Array)', ->
      expect isSubsetOf MapG(Object, ListG Number), MapG(Object, Array)
      .to.equal yes

  describe 'checking tuple type', ->
    it 'compare TupleG(Number, Number) with ArrayT', ->
      expect isSubsetOf TupleG(Number, Number), ArrayT
      .to.equal yes
    it 'compare TupleG(Number, Number) with TupleT', ->
      expect isSubsetOf TupleG(Number, Number), TupleT
      .to.equal yes
    it 'compare TupleG(IntegerT, IntegerT) with TupleG(Number, Number)', ->
      expect isSubsetOf TupleG(IntegerT, IntegerT), TupleG(Number, Number)
      .to.equal yes

  describe 'checking func type', ->
    it 'compare FuncG(String, Number) with FunctionT', ->
      expect isSubsetOf FuncG(String, Number), FunctionT
      .to.equal yes
    it 'compare FuncG(Object, ListG Number) with FuncG(Object, Array)', ->
      expect isSubsetOf FuncG(Object, ListG Number), FuncG(Object, Array)
      .to.equal yes

  describe 'checking async type', ->
    it 'compare AsyncFuncG(String, Number) with FunctionT', ->
      expect isSubsetOf AsyncFuncG(String, Number), FunctionT
      .to.equal yes
    it 'compare AsyncFuncG(Object, ListG Number) with AsyncFuncG(Object, Array)', ->
      expect isSubsetOf AsyncFuncG(Object, ListG Number), AsyncFuncG(Object, Array)
      .to.equal yes

  describe 'checking generic type', ->
    it 'compare AccordG with FunctionT', ->
      expect isSubsetOf AccordG, FunctionT
      .to.equal yes
    it 'compare AccordG with GenericT', ->
      expect isSubsetOf AccordG, GenericT
      .to.equal yes

  describe 'checking mixin type', ->
    it 'compare ChainsMixin with FunctionT', ->
      expect isSubsetOf ChainsMixin, FunctionT
      .to.equal yes
    it 'compare ChainsMixin with MixinT', ->
      expect isSubsetOf ChainsMixin, MixinT
      .to.equal yes

  describe 'checking module type', ->
    it 'compare RC with FunctionT', ->
      expect isSubsetOf RC, FunctionT
      .to.equal yes
    it 'compare RC with ModuleT', ->
      expect isSubsetOf RC, ModuleT
      .to.equal yes
    it 'compare custom module with RC::Module', ->
      class TestModule extends RC
        @inheritProtected()
        @root __dirname
        @initialize()
      expect isSubsetOf TestModule, RC::Module
      .to.equal yes

  describe 'checking class type', ->
    it 'compare CoreObject with FunctionT', ->
      expect isSubsetOf CoreObject, FunctionT
      .to.equal yes
    it 'compare CoreObject with ClassT', ->
      expect isSubsetOf CoreObject, ClassT
      .to.equal yes
    it 'compare custom module with CoreObject', ->
      class TestModule extends RC
        @inheritProtected()
        @root __dirname
        @initialize()
      class Tomato extends CoreObject
        @inheritProtected()
        @module TestModule
        @initialize()
      class Cucumber extends Tomato
        @inheritProtected()
        @module TestModule
        @initialize()
      expect isSubsetOf Cucumber, CoreObject
      .to.equal yes

  describe 'checking interface type', ->
    it 'compare InterfaceG(size: Number) with ObjectT', ->
      expect isSubsetOf InterfaceG(size: Number), ObjectT
      .to.equal yes
    it 'compare InterfaceG(size: Number) with InterfaceT', ->
      expect isSubsetOf InterfaceG(size: Number), InterfaceT
      .to.equal yes
    it 'compare PromiseInterface with ObjectT', ->
      expect isSubsetOf PromiseInterface, ObjectT
      .to.equal yes
    it 'compare PromiseInterface with InterfaceT', ->
      expect isSubsetOf PromiseInterface, InterfaceT
      .to.equal yes
    it 'compare InterfaceG(color: Number, name: String) with InterfaceG(color: Number)', ->
      expect isSubsetOf InterfaceG(color: Number, name: String), InterfaceG(color: Number)
      .to.equal yes
    it 'compare custom module with CoreObject', ->
      class TestModule extends RC
        @inheritProtected()
        @root __dirname
        @initialize()
      class TomatoInterface extends Interface
        @inheritProtected()
        @module TestModule
        @virtual name: String
        @initialize()
      class CucumberInterface extends Interface
        @inheritProtected()
        @module TestModule
        @virtual name: String
        @virtual color: Number
        @initialize()
      expect isSubsetOf CucumberInterface, TomatoInterface
      .to.equal yes
