{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  IntegerT
  Declare
  Interface
  StructG
  FuncG
  UnionG
  MaybeG
  Utils: { _ }
} = RC::

describe 'Declare', ->
  class TestModule extends RC
    @inheritProtected()
    @root __dirname
    @initialize()
  TomatoT = Declare 'TomatoT'
  tomStruct = StructG key: String
  CucumberT = Declare 'CucumberT'
  funcT = FuncG String, String
  funcT.of (x)-> x
  uT = UnionG Number, IntegerT
  OnionT = Declare 'OnionT'
  CarrotT = Declare 'CarrotT'
  TestModule.defineType TomatoT
  TestModule.defineType CucumberT
  TestModule.defineType OnionT
  TestModule.defineType CarrotT
  describe 'create new declaration', ->
    it 'check define of declaration', ->
      assert _.isFunction(TomatoT.define), 'define must be a function'
    it 'check name of declaration', ->
      expect TomatoT.name
      .to.equal 'TomatoT'
    it 'check displayName of declaration', ->
      expect TomatoT.displayName
      .to.equal 'TomatoT'
    it 'check meta of declaration', ->
      expect TomatoT.meta
      .to.deep.equal {
        kind: 'declare'
        name: 'TomatoT'
        identity: yes
      }
  describe 'main exeptions', ->
    it 'throw when call new', ->
      expect ->
        new TomatoT
      .to.throw TypeError
    it 'throw when checking before define', ->
      expect ->
        TomatoT 'tomato'
      .to.throw TypeError
  describe 'check define', ->
    it 'call define', ->
      expect ->
        TomatoT.define tomStruct
      .to.not.throw TypeError
    it 'check old meta of declaration', ->
      expect TomatoT.meta
      .to.not.deep.equal {
        kind: 'declare'
        name: 'TomatoT'
        identity: yes
      }
    it 'throw when call define second', ->
      expect ->
        TomatoT.define tomStruct
      .to.throw TypeError
    it 'check `Type` of declaration', ->
      expect TomatoT.Type
      .to.equal tomStruct
    it 'check `is` of declaration', ->
      expect TomatoT.is
      .to.equal tomStruct.is
    it 'check `of` of declaration', ->
      CucumberT.define funcT
      expect CucumberT.of
      .to.equal funcT.of
  describe 'checking simple values', ->
    it 'check correct value', ->
      expect ->
        TomatoT key: 'tomato'
      .to.not.throw TypeError
    it 'throw when check empty value', ->
      expect ->
        TomatoT()
      .to.throw TypeError
    it 'throw when check incorrect value', ->
      expect ->
        TomatoT key: 123
      .to.throw TypeError
    it 'throw when check incorrect key', ->
      expect ->
        TomatoT prop: 'tomato'
      .to.throw TypeError
  describe 'checking union values', ->
    it 'throw when check without `dispatch` of declaration', ->
      OnionT.define uT
      expect ->
        OnionT 123
      .to.throw TypeError
    it 'check union declaration', ->
      CarrotT.dispatch = (x)-> switch x
        when 123
          IntegerT
        else
          Number
      CarrotT.define uT
      expect CarrotT.dispatch
      .to.equal CarrotT.Type.dispatch
      expect ->
        CarrotT 123
      .to.not.throw TypeError
    it 'throw when check incorrect value by union', ->
      expect ->
        CarrotT 'Carrot'
      .to.throw TypeError
  describe 'checking values by interface', ->
    it 'check definition of interface', ->
      PotatoT = Declare 'PotatoInterface'
      TestModule.defineType PotatoT
      class PotatoInterface extends Interface
        @inheritProtected()
        @module TestModule
        @public fry: Boolean
        @initialize()
      expect ->
        PotatoT fry: yes
      .to.not.throw TypeError
    it 'check circular definition of interface', ->
      AppleT = Declare 'AppleInterface'
      TestModule.defineType AppleT
      class AppleInterface extends Interface
        @inheritProtected()
        @module TestModule
        @public child: MaybeG AppleT
        @initialize()
      expect ->
        AppleT child: child: child: child: child: child: child: null
      .to.not.throw TypeError
      expect ->
        appleA = child: null
        appleB = child: appleA
        appleA.child = appleB
        AppleT appleA
      .to.not.throw TypeError
