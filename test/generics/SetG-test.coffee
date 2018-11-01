{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  IntegerT
  ListT
  ListG
  SetG
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

describe 'SetG', ->
  describe 'checking SetG', ->
    it 'empty Set', ->
      expect ->
        SetG(String) new Set
      .to.not.throw TypeError
    it 'check Set< String >', ->
      expect ->
        SetG(String) new Set ['a', 'b', 'c']
    it 'check Set< Array <String > >', ->
      expect ->
        SetG(ListG String) new Set [['a', 'b', 'c']]
      .to.not.throw TypeError
    it 'check Set< Number >', ->
      expect ->
        SetG(Number) new Set [1, 2, 3]
      .to.not.throw TypeError
    it 'check Set< Boolean >', ->
      expect ->
        SetG(Boolean) new Set [yes, yes, no]
      .to.not.throw TypeError
    it 'check Set< Date >', ->
      expect ->
        SetG(Date) new Set [new Date(), new Date()]
      .to.not.throw TypeError
    it 'check Set< Error >', ->
      expect ->
        SetG(Error) new Set [new Error('Error'), new Error('Error')]
      .to.not.throw TypeError
    it 'check Set< ?Boolean >', ->
      expect ->
        SetG(MaybeG Boolean) new Set [yes, yes, no, null]
      .to.not.throw TypeError
    it 'check Set< Boolean | String >', ->
      expect ->
        SetG(UnionG Boolean, String) new Set [yes, 'yes', no, 'null']
      .to.not.throw TypeError
    it 'check Set< Number & Integer >', ->
      expect ->
        SetG(IntersectionG Number, IntegerT) new Set [1, 2, 3]
      .to.not.throw TypeError
    it 'check Set< 1 | 2 | 3 >', ->
      expect ->
        SetG(EnumG 1, 2, 3) new Set [1, 2, 3]
      .to.not.throw TypeError
    it 'check Set< {[String]: Number} >', ->
      expect ->
        SetG(DictG String, Number) new Set [{a: 1}, {b: 2}, {c: 3}]
      .to.not.throw TypeError
    it 'check Set< (String)=> Number >', ->
      expect ->
        SetG(FuncG String, Number) new Set [
          -> 1
        ,
          -> 2
        ,
          -> 3
        ]
      .to.not.throw TypeError
    it 'check Set< [String, Function] >', ->
      expect ->
        SetG(TupleG String, Function) new Set [
          ['a', (->)]
          ['b', (->)]
          ['c', (->)]
        ]
      .to.not.throw TypeError
    it 'check Set< {name: String} >', ->
      expect ->
        SetG(StructG name: String) new Set [
          {name: 'name1'}
          {name: 'name2'}
          {name: 'name3'}
        ]
      .to.not.throw TypeError
    it 'check Set< {size: Number} >', ->
      expect ->
        SetG(InterfaceG size: Number) new Set [
          {size: 1}
          {size: 2}
          {size: 3}
        ]
      .to.not.throw TypeError
    it 'check Set< GreenCucumber181 >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber181 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        SetG(SampleG GreenCucumber181) new Set [GreenCucumber181.new()]
      .to.not.throw TypeError
  describe 'throw when check not SetG', ->
    it 'throw when not check Set< String > (has null)', ->
      expect ->
        SetG(String) new Set ['a', 'b', 'c', null]
      .to.throw TypeError
    it 'throw when check Set< Array <String > >', ->
      expect ->
        SetG(ListG String) new Set [{}]
      .to.throw TypeError
    it 'throw when not check Set< String > (has undefined)', ->
      expect ->
        SetG(String) new Set ['a', 'b', 'c', undefined]
      .to.throw TypeError
    it 'throw when not check Set< String >', ->
      expect ->
        SetG(String) new Set ['a', 'b', 'c', 1]
      .to.throw TypeError
    it 'throw when not check Set< Number >', ->
      expect ->
        SetG(Number) new Set [1, 2, '3']
      .to.throw TypeError
    it 'throw when not check Set< Boolean >', ->
      expect ->
        SetG(Boolean) new Set [yes, yes, no, 1, 'yes']
      .to.throw TypeError
    it 'throw when not check Set< Date >', ->
      expect ->
        SetG(Date) new Set [new Date(), Date.now()]
      .to.throw TypeError
    it 'throw when not check Set< Error >', ->
      expect ->
        SetG(Error) new Set [new Error('Error'), 'Error']
      .to.throw TypeError
    it 'throw when not check Set< ?Boolean >', ->
      expect ->
        SetG(MaybeG(Boolean)) new Set [yes, yes, no, null, 'undefined']
      .to.throw TypeError
    it 'throw when not check Set< Boolean | String >', ->
      expect ->
        SetG(UnionG(Boolean, String)) new Set [yes, 'yes', no, 0]
      .to.throw TypeError
    it 'throw when not check Set< Number & Integer >', ->
      expect ->
        SetG(IntersectionG(Number, IntegerT)) new Set [1, 2, 3.5]
      .to.throw TypeError
    it 'throw when not check Set< 1 | 2 | 3 >', ->
      expect ->
        SetG(EnumG 1, 2, 3) new Set [1, 2, 3, 4]
      .to.throw TypeError
    it 'throw when not check Set< {[String]: Number} >', ->
      expect ->
        SetG(DictG(String, Number)) new Set [{a: 1}, {b: 2.5}, {c: '3'}]
      .to.throw TypeError
    it 'throw when not check Set< (String)=> Number >', ->
      expect ->
        SetG(FuncG(String, Number)) new Set [
          -> 1
        ,
          -> 2
        ,
          3
        ]
      .to.throw TypeError
    it 'throw when not check Set< [String, Function] >', ->
      expect ->
        SetG(TupleG(String, Function)) new Set [
          ['a', (->)]
          ['b', (->)]
          ['c', '->']
        ]
      .to.throw TypeError
    it 'throw when not check Set< {name: String} >', ->
      expect ->
        SetG(StructG(name: String)) new Set [
          {name: 'name1'}
          {name: 'name2'}
          {name: 3}
        ]
      .to.throw TypeError
    it 'throw when not check Set< {size: Number} >', ->
      expect ->
        SetG(InterfaceG(size: Number)) new Set [
          {size: 1}
          {size: 2}
          {size: '3'}
        ]
      .to.throw TypeError
    it 'throw when not check Set< GreenCucumber182 >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber182 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        SetG(SampleG(GreenCucumber182)) new Set [new Object ]
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        InterfaceG(test: String) 'string'
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        InterfaceG(test: String) 1
      .to.throw TypeError
    it 'throw when check date', ->
      expect ->
        InterfaceG(test: String) new Date
      .to.throw TypeError
    it 'throw when check boolean', ->
      expect ->
        InterfaceG(test: String) yes
      .to.throw TypeError
    it 'throw when check error', ->
      expect ->
        InterfaceG(test: String) new Error
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        InterfaceG(test: String) Symbol()
      .to.throw TypeError
    it 'throw when check map', ->
      expect ->
        InterfaceG(test: String) new Map
      .to.throw TypeError
    it 'throw when check buffer', ->
      expect ->
        InterfaceG(test: String) Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        InterfaceG(test: String) []
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        InterfaceG(test123: String) RC::CoreObject
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        InterfaceG(test: String) (->)
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        InterfaceG(test: String) null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        InterfaceG(test: String) undefined
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        InterfaceG(test: String) Promise.resolve()
      .to.throw TypeError
    it 'throw when check regexp', ->
      expect ->
        InterfaceG(test: String) /.*/
      .to.throw TypeError
