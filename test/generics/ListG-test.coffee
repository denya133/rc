{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  IntegerT
  ListT
  ListG
  SampleG
  InterfaceG
  StructG
  TupleG
  FuncG
  DictG
  EnumG
  IntersectionG
  UnionG
  MaybeG
} = RC::

describe 'ListG', ->
  describe 'checking ListG', ->
    it 'check Array< String >', ->
      expect ->
        ListG(String) ['a', 'b', 'c']
      .to.not.throw TypeError
    it 'check Array< Number >', ->
      expect ->
        ListG(Number) [1, 2, 3]
      .to.not.throw TypeError
    it 'check Array< Boolean >', ->
      expect ->
        ListG(Boolean) [yes, yes, no]
      .to.not.throw TypeError
    it 'check Array< Date >', ->
      expect ->
        ListG(Date) [new Date(), new Date()]
      .to.not.throw TypeError
    it 'check Array< Error >', ->
      expect ->
        ListG(Error) [new Error('Error'), new Error('Error')]
      .to.not.throw TypeError
    it 'check Array< ?Boolean >', ->
      expect ->
        ListG(MaybeG(Boolean)) [yes, yes, no, null]
      .to.not.throw TypeError
    it 'check Array< Boolean | String >', ->
      expect ->
        ListG(UnionG(Boolean, String)) [yes, 'yes', no, 'null']
      .to.not.throw TypeError
    it 'check Array< Number & Integer >', ->
      expect ->
        ListG(IntersectionG(Number, IntegerT)) [1, 2, 3]
      .to.not.throw TypeError
    it 'check Array< 1, 2, 3 >', ->
      expect ->
        ListG(EnumG([1, 2, 3])) [1, 2, 3]
      .to.not.throw TypeError
    it 'check Array< {[String]: Number} >', ->
      expect ->
        ListG(DictG(String, Number)) [{a: 1}, {b: 2}, {c: 3}]
      .to.not.throw TypeError
    it 'check Array< (String)=> Number >', ->
      expect ->
        ListG(FuncG(String, Number)) [
          -> 1
        ,
          -> 2
        ,
          -> 3
        ]
      .to.not.throw TypeError
    it 'check Array< [String, Function] >', ->
      expect ->
        ListG(TupleG(String, Function)) [
          ['a', (->)]
          ['b', (->)]
          ['c', (->)]
        ]
      .to.not.throw TypeError
    it 'check Array< {name: String} >', ->
      expect ->
        ListG(StructG(name: String)) [
          {name: 'name1'}
          {name: 'name2'}
          {name: 'name3'}
        ]
      .to.not.throw TypeError
    it 'check Array< {size: Number} >', ->
      expect ->
        ListG(InterfaceG(size: Number)) [
          {size: 1}
          {size: 2}
          {size: 3}
        ]
      .to.not.throw TypeError
    it 'check Array< Cucumber >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber123 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        ListG(SampleG(GreenCucumber123)) [GreenCucumber123.new(), new GreenCucumber123]
      .to.not.throw TypeError
  describe 'throw when check not ListG', ->
    it 'throw when empty Array', ->
      expect ->
        ListG(String) []
      .to.throw TypeError
    it 'throw when not check Array< String > (has null)', ->
      expect ->
        ListG(String) ['a', 'b', 'c', null]
      .to.throw TypeError
    it 'throw when not check Array< String > (has undefined)', ->
      expect ->
        ListG(String) ['a', 'b', 'c', undefined]
      .to.throw TypeError
    it 'throw when not check Array< String >', ->
      expect ->
        ListG(String) ['a', 'b', 'c', 1]
      .to.throw TypeError
    it 'throw when not check Array< Number >', ->
      expect ->
        ListG(Number) [1, 2, '3']
      .to.throw TypeError
    it 'throw when not check Array< Boolean >', ->
      expect ->
        ListG(Boolean) [yes, yes, no, 1, 'yes']
      .to.throw TypeError
    it 'throw when not check Array< Date >', ->
      expect ->
        ListG(Date) [new Date(), Date.now()]
      .to.throw TypeError
    it 'throw when not check Array< Error >', ->
      expect ->
        ListG(Error) [new Error('Error'), 'Error']
      .to.throw TypeError
    it 'throw when not check Array< ?Boolean >', ->
      expect ->
        ListG(MaybeG(Boolean)) [yes, yes, no, null, 'undefined']
      .to.throw TypeError
    it 'throw when not check Array< Boolean | String >', ->
      expect ->
        ListG(UnionG(Boolean, String)) [yes, 'yes', no, 0]
      .to.throw TypeError
    it 'throw when not check Array< Number & Integer >', ->
      expect ->
        ListG(IntersectionG(Number, IntegerT)) [1, 2, 3.5]
      .to.throw TypeError
    it 'throw when not check Array< 1, 2, 3 >', ->
      expect ->
        ListG(EnumG([1, 2, 3])) [1, 2, 3, 4]
      .to.throw TypeError
    it 'throw when not check Array< {[String]: Number} >', ->
      expect ->
        ListG(DictG(String, Number)) [{a: 1}, {b: 2.5}, {c: '3'}]
      .to.throw TypeError
    it 'throw when not check Array< (String)=> Number >', ->
      expect ->
        ListG(FuncG(String, Number)) [
          -> 1
        ,
          -> 2
        ,
          3
        ]
      .to.throw TypeError
    it 'throw when not check Array< [String, Function] >', ->
      expect ->
        ListG(TupleG(String, Function)) [
          ['a', (->)]
          ['b', (->)]
          ['c', '->']
        ]
      .to.throw TypeError
    it 'throw when not check Array< {name: String} >', ->
      expect ->
        ListG(StructG(name: String)) [
          {name: 'name1'}
          {name: 'name2'}
          {name: 3}
        ]
      .to.throw TypeError
    it 'throw when not check Array< {size: Number} >', ->
      expect ->
        ListG(InterfaceG(size: Number)) [
          {size: 1}
          {size: 2}
          {size: '3'}
        ]
      .to.throw TypeError
    it 'throw when not check Array< {size: Number} >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class Cucumber extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        ListG(SampleG(Cucumber)) [new Cucumber, new Object({})]
      .to.throw TypeError
