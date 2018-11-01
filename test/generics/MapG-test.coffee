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
  MapG
  EnumG
  IntersectionG
  UnionG
  MaybeG
} = RC::

describe 'MapG', ->
  describe 'checking MapG', ->
    it 'empty Map< String, String>', ->
      expect ->
        MapG(String, String) new Map
      .to.not.throw TypeError
    it 'empty Map< String, {[key: String]: String } >', ->
      expect ->
        MapG(String, DictG String, String) new Map [['key', {}]]
      .to.not.throw TypeError
    it 'check Map< Symbol, String >', ->
      expect ->
        MapG(Symbol, String) new Map [
          [Symbol('a'), 'a']
          [Symbol('b'), 'b']
          [Symbol('c'), 'c']
        ]
      .to.not.throw TypeError
    it 'check Map< Number, String>', ->
      expect ->
        MapG(Number, String) new Map [[new Number(1), 'str']]
      .to.not.throw TypeError
    it 'check Map< Boolean, String>', ->
      expect ->
        MapG(Boolean, String) new Map [[new Boolean(yes), 'str']]
      .to.not.throw TypeError
    it 'check Map< Date, String>', ->
      expect ->
        MapG(Date, String) new Map [[new Date(), 'str']]
      .to.not.throw TypeError
    it 'check Map< Error, String>', ->
      expect ->
        MapG(Error, String) new Map [[new Error(), 'str']]
      .to.not.throw TypeError
    it 'check Map< Object, String>', ->
      expect ->
        MapG(Object, String) new Map [[new Object(), 'str']]
      .to.not.throw TypeError
    it 'check Map< String, String>', ->
      expect ->
        MapG(String, String) new Map [['str', 'str']]
      .to.not.throw TypeError
    it 'check Map< String, Number>', ->
      expect ->
        MapG(String, Number) new Map [['str', 1]]
      .to.not.throw TypeError
    it 'check Map< String, Boolean>', ->
      expect ->
        MapG(String, Boolean) new Map [['str', yes]]
      .to.not.throw TypeError
    it 'check Map< String, Date>', ->
      expect ->
        MapG(String, Date) new Map [['str', new Date()]]
      .to.not.throw TypeError
    it 'check Map< String, Error>', ->
      expect ->
        MapG(String, Error) new Map [['str', new Error]]
      .to.not.throw TypeError
    it 'check Map< String, ?Boolean>', ->
      expect ->
        MapG(String, MaybeG(Boolean)) new Map [['1', yes], ['2', no], ['3', null], ['4', undefined]]
      .to.not.throw TypeError
    it 'check Map< String, Boolean | String >', ->
      expect ->
        MapG(String, UnionG(Boolean, String)) new Map [['1', yes], ['2', 'no'], ['3', 'null']]
      .to.not.throw TypeError
    it 'check Map< String, Number & Integer >', ->
      expect ->
        MapG(String, IntersectionG(Number, IntegerT)) new Map [['1', 1], ['2', 2], ['3', 3], ['4', 4]]
      .to.not.throw TypeError
    it 'check Map< String, 1 | 2 | 3 >', ->
      expect ->
        MapG(String, EnumG 1, 2, 3) new Map [['1', 1], ['2', 2], ['3', 3]]
      .to.not.throw TypeError
    it 'check Map< String, Array< String > >', ->
      expect ->
        MapG(String, ListG(String)) new Map [
          ['a', ['a', 'b', 'c']]
          ['b', ['a', 'b', 'c']]
          ['c', ['a', 'b', 'c']]
        ]
      .to.not.throw TypeError
    it 'check Map< String, (String)=> Number >', ->
      expect ->
        MapG(String, FuncG(String, Number)) new Map [
          ['a', -> 1]
          ['b', -> 2]
          ['c', -> 3]
        ]
      .to.not.throw TypeError
    it 'check Map< String, [String, Function] >', ->
      expect ->
        MapG(String, TupleG(String, Function)) new Map [
          ['a', ['a', (->)]]
          ['b', ['b', (->)]]
          ['c', ['c', (->)]]
        ]
      .to.not.throw TypeError
    it 'check Map< String, {name: String} >', ->
      expect ->
        MapG(String, StructG(name: String)) new Map [
          ['a', {name: 'name1'}]
          ['b', {name: 'name2'}]
          ['c', {name: 'name3'}]
        ]
      .to.not.throw TypeError
    it 'check Map< String, {size: Number} >', ->
      expect ->
        MapG(String, InterfaceG(size: Number)) new Map [
          ['a', {size: 1}]
          ['b', {size: 2}]
          ['c', {size: 3}]
        ]
      .to.not.throw TypeError
    it 'check Map< String, GreenCucumber191 >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber191 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        MapG(String, SampleG(GreenCucumber191)) new Map [['a', GreenCucumber191.new()]]
      .to.not.throw TypeError
  describe 'throw when check not MapG', ->
    it 'throw when empty Map< String, {[key: String]: String } >', ->
      expect ->
        MapG(String, DictG String, String) new Map [[{}, {}]]
      .to.throw TypeError
    it 'throw when check Map< Symbol, String >', ->
      expect ->
        MapG(Symbol, String) new Map [
          [Symbol('a'), 'a']
          [Symbol('b'), 'b']
          ['c', 'c']
        ]
      .to.throw TypeError
    it 'throw when check Map< Number, String>', ->
      expect ->
        MapG(Number, String) new Map [[null, 'str']]
      .to.throw TypeError
    it 'throw when check Map< Boolean, String>', ->
      expect ->
        MapG(Boolean, String) new Map [[undefined, 'str']]
      .to.throw TypeError
    it 'throw when check Map< Date, String>', ->
      expect ->
        MapG(Date, String) new Map [[new Number(), 'str']]
      .to.throw TypeError
    it 'throw when check Map< Error, String>', ->
      expect ->
        MapG(Error, String) new Map [[new Object(), 'str']]
      .to.throw TypeError
    it 'throw when check Map< Object, String>', ->
      expect ->
        MapG(Object, String) new Map [[1, 'str']]
      .to.throw TypeError
    it 'throw when check Map< String, String>', ->
      expect ->
        MapG(String, String) new Map [['str', 1]]
      .to.throw TypeError
    it 'throw when check Map< String, Number>', ->
      expect ->
        MapG(String, Number) new Map [['str', '1']]
      .to.throw TypeError
    it 'throw when check Map< String, Boolean>', ->
      expect ->
        MapG(String, Boolean) new Map [['str', 'yes']]
      .to.throw TypeError
    it 'throw when check Map< String, Date>', ->
      expect ->
        MapG(String, Date) new Map [['str', Date.now()]]
      .to.throw TypeError
    it 'throw when check Map< String, Error>', ->
      expect ->
        MapG(String, Error) new Map [['str', 'Error']]
      .to.throw TypeError
    it 'throw when check Map< String, ?Boolean>', ->
      expect ->
        MapG(String, MaybeG(Boolean)) new Map [['1', yes], ['2', no], ['3', null], ['4', 'undefined']]
      .to.throw TypeError
    it 'throw when check Map< String, Boolean | String >', ->
      expect ->
        MapG(String, UnionG(Boolean, String)) new Map [['1', yes], ['2', 'no'], ['3', 1]]
      .to.throw TypeError
    it 'throw when check Map< String, Number & Integer >', ->
      expect ->
        MapG(String, IntersectionG(Number, IntegerT)) new Map [['1', 1], ['2', 2], ['3', 3], ['4', 3.5]]
      .to.throw TypeError
    it 'throw when check Map< String, 1 | 2 | 3 >', ->
      expect ->
        MapG(String, EnumG 1, 2, 3) new Map [['1', 1], ['2', 2], ['3', 4]]
      .to.throw TypeError
    it 'throw when check Map< String, Array< String > >', ->
      expect ->
        MapG(String, ListG(String)) new Map [
          ['a', ['a', 'b', 'c']]
          ['b', ['a', 'b', 'c']]
          ['c', 1]
        ]
      .to.throw TypeError
    it 'throw when check Map< String, (String)=> Number >', ->
      expect ->
        MapG(String, FuncG(String, Number)) new Map [
          ['a', -> 1]
          ['b', -> 2]
          ['c', '3']
        ]
      .to.throw TypeError
    it 'throw when check Map< String, [String, Function] >', ->
      expect ->
        MapG(String, TupleG(String, Function)) new Map [
          ['a', ['a', (->)]]
          ['b', ['b', (->)]]
          ['c', ['c', 1]]
        ]
      .to.throw TypeError
    it 'throw when check Map< String, {name: String} >', ->
      expect ->
        MapG(String, StructG(name: String)) new Map [
          ['a', {name: 'name1'}]
          ['b', {name: 'name2'}]
          ['c', {name: 2}]
        ]
      .to.throw TypeError
    it 'throw when check Map< String, {size: Number} >', ->
      expect ->
        MapG(String, InterfaceG(size: Number)) new Map [
          ['a', {size: 1}]
          ['b', {size: 2}]
          ['c', {size: 'medium'}]
        ]
      .to.throw TypeError
    it 'throw when check Map< String, GreenCucumber192 >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber192 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        MapG(String, SampleG(GreenCucumber192)) new Map [['a', new Object]]
      .to.throw TypeError
