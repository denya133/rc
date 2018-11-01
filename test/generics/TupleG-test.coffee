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

describe 'TupleG', ->
  describe 'checking TupleG', ->
    it 'check [Number, String]', ->
      expect ->
        TupleG(Number, String) [1, '']
      .to.not.throw TypeError
    it 'check [Number, Number, String]', ->
      expect ->
        TupleG(Number, Number, String) [199999, 0, '']
      .to.not.throw TypeError
    it 'check [String, Number]', ->
      expect ->
        TupleG(String, Number) ['', 1]
        TupleG(String, Number) ['a', 1]
        TupleG(String, Number) ['a', 0]
        TupleG(String, Number) ['a', 0.9563]
        TupleG(String, Number) ['a', 1000000]
        TupleG(String, Number) ['a', -19999999]
      .to.not.throw TypeError
    it 'check [Boolean, Date]', ->
      expect ->
        TupleG(Boolean, Date) [yes, new Date()]
        TupleG(Boolean, Date) [no, new Date()]
      .to.not.throw TypeError
    it 'check [Date, Boolean]', ->
      expect ->
        TupleG(Date, Boolean) [new Date(), yes]
        TupleG(Date, Boolean) [new Date(), no]
      .to.not.throw TypeError
    it 'check [Error, ?Boolean]', ->
      expect ->
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), null]
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), undefined]
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), yes]
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), no]
      .to.not.throw TypeError
    it 'check [String, Boolean | String]', ->
      expect ->
        TupleG(String, UnionG(Boolean, String)) ['', yes]
        TupleG(String, UnionG(Boolean, String)) ['yes', yes]
        TupleG(String, UnionG(Boolean, String)) ['yes', no]
        TupleG(String, UnionG(Boolean, String)) ['yes', 'null']
      .to.not.throw TypeError
    it 'check [String, Number & Integer]', ->
      expect ->
        TupleG(String, IntersectionG(Number, IntegerT)) ['', 0]
        TupleG(String, IntersectionG(Number, IntegerT)) ['str', 1]
        TupleG(String, IntersectionG(Number, IntegerT)) ['str', 10000000]
        TupleG(String, IntersectionG(Number, IntegerT)) ['str', -1999999]
      .to.not.throw TypeError
    it 'check [String, 1 | 2 | 3 ]', ->
      expect ->
        TupleG(String, EnumG 1, 2, 3) ['', 1]
        TupleG(String, EnumG 1, 2, 3) ['str', 1]
        TupleG(String, EnumG 1, 2, 3) ['str', 2]
        TupleG(String, EnumG 1, 2, 3) ['str', 3]
      .to.not.throw TypeError
    it 'check [String, {[key: String]: Number}]', ->
      expect ->
        TupleG(String, DictG(String, Number)) ['', {a: 1, b: 2, c: 3}]
        TupleG(String, DictG(String, Number)) ['str', {a: 1, b: 2, c: 3}]
      .to.not.throw TypeError
    it 'check [String, (String)=> Number]', ->
      expect ->
        TupleG(String, FuncG(String, Number)) ['', (->)]
        TupleG(String, FuncG(String, Number)) ['str', (->)]
      .to.not.throw TypeError
    it 'check [String, Array< [String] >]', ->
      expect ->
        TupleG(String, ListG(String)) ['', ['a', 'b', 'c']]
        TupleG(String, ListG(String)) ['str', ['a', 'b', 'c']]
      .to.not.throw TypeError
    it 'check [String, {name: String}]', ->
      expect ->
        TupleG(String, StructG(name: String)) ['', {name: 'name1'}]
        TupleG(String, StructG(name: String)) ['str', {name: 'name1'}]
      .to.not.throw TypeError
    it 'check [String, {size: Number}]', ->
      expect ->
        TupleG(String, InterfaceG(size: Number)) ['', {size: 1}]
        TupleG(String, InterfaceG(size: Number)) ['str', {size: 1}]
      .to.not.throw TypeError
    it 'check [String, Cucumber]', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber126 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        TupleG(String, SampleG(GreenCucumber126)) ['', GreenCucumber126.new()]
        TupleG(String, SampleG(GreenCucumber126)) ['a', GreenCucumber126.new()]
      .to.not.throw TypeError
  describe 'throw when check not TupleG', ->
    it 'throw when empty [String]', ->
      expect ->
        TupleG(String) []
      .to.throw TypeError
    it 'throw when not check [String] (but two args)', ->
      expect ->
        TupleG(String) ['a', 'b']
      .to.throw TypeError
    it 'throw when not check [String] (has null)', ->
      expect ->
        TupleG(String) ['a', null]
      .to.throw TypeError
    it 'throw when not check [String] (has undefined)', ->
      expect ->
        TupleG(String) ['a', undefined]
      .to.throw TypeError
    it 'throw when not check [String, String] (has null)', ->
      expect ->
        TupleG(String, String) ['a', null]
      .to.throw TypeError
    it 'throw when not check [String, String] (has undefined)', ->
      expect ->
        TupleG(String, String) ['a', undefined]
      .to.throw TypeError
    it 'throw when check [Number, String]', ->
      expect ->
        TupleG(Number, String) [NaN, '']
      .to.throw TypeError
    it 'throw when check [Number, Number, String]', ->
      expect ->
        TupleG(Number, Number, String) [Infinity, 0, '']
      .to.throw TypeError
    it 'throw when check [String, Number]', ->
      expect ->
        TupleG(String, Number) ['', Infinity]
      .to.throw TypeError
    it 'throw when check [Boolean, Date]', ->
      expect ->
        TupleG(Boolean, Date) [yes, Date.now()]
      .to.throw TypeError
    it 'throw when check [Date, Boolean]', ->
      expect ->
        TupleG(Date, Boolean) [Date.now(), yes]
      .to.throw TypeError
    it 'throw when check [Error, ?Boolean] (not Error)', ->
      expect ->
        TupleG(Error, MaybeG(Boolean)) ['Error', null]
      .to.throw TypeError
    it 'throw when check [Error, ?Boolean] (not ?Boolean)', ->
      expect ->
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), 'undefined']
      .to.throw TypeError
    it 'throw when check [String, Boolean | String]', ->
      expect ->
        TupleG(String, UnionG(Boolean, String)) ['', undefined]
      .to.throw TypeError
    it 'throw when check [String, Number & Integer]', ->
      expect ->
        TupleG(String, IntersectionG(Number, IntegerT)) ['', 3.5]
      .to.throw TypeError
    it 'throw when check [String, 1 | 2 | 3]', ->
      expect ->
        TupleG(String, EnumG 1, 2, 3) ['', 0]
      .to.throw TypeError
    it 'throw when check [String, {[key: String]: Number}]', ->
      expect ->
        TupleG(String, DictG(String, Number)) ['', {a: 'a', b: 2, c: 3}]
      .to.throw TypeError
    it 'throw when check [String, (String)=> Number]', ->
      expect ->
        TupleG(String, FuncG(String, Number)) ['', 'function(){}']
      .to.throw TypeError
    it 'throw when check [String, Array< [String] >]', ->
      expect ->
        TupleG(String, ListG(String)) ['', [1, 2, 3]]
      .to.throw TypeError
    it 'throw when check [String, {name: String}]', ->
      expect ->
        TupleG(String, StructG(name: String)) ['', {names: 'name1'}]
      .to.throw TypeError
    it 'throw when check [String, {size: Number}]', ->
      expect ->
        TupleG(String, InterfaceG(size: Number)) ['', {size: 'medium'}]
      .to.throw TypeError
    it 'throw when check [ String, Cucumber ]', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber127 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        TupleG(String, SampleG(GreenCucumber127)) ['', new Object]
      .to.throw TypeError
