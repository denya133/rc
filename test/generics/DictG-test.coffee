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

describe 'DictG', ->
  describe 'checking DictG', ->
    it 'empty {[key: String]: String }', ->
      expect ->
        DictG(String, String) {}
      .to.not.throw TypeError
    it 'check {[key: Symbol]: String }', ->
      expect ->
        DictG(Symbol, String) {
          [Symbol('a')]: 'a'
          [Symbol('b')]: 'b'
          [Symbol('c')]: 'c'
        }
      .to.not.throw TypeError
    it 'check {[key: String]: String }', ->
      expect ->
        DictG(String, String) {a: 'a', b: 'b', c: 'c'}
      .to.not.throw TypeError
    it 'check {[key: String]: Number }', ->
      expect ->
        DictG(String, Number) {a: 1, b: 2, c: 3}
      .to.not.throw TypeError
    it 'check {[key: String]: Boolean }', ->
      expect ->
        DictG(String, Boolean) {a: yes, b: yes, c: no}
      .to.not.throw TypeError
    it 'check {[key: String]: Date }', ->
      expect ->
        DictG(String, Date) {a: new Date(), b: new Date()}
      .to.not.throw TypeError
    it 'check {[key: String]: Error }', ->
      expect ->
        DictG(String, Error) {a: new Error('Error'), b: new Error('Error')}
      .to.not.throw TypeError
    it 'check {[key: String]: ?Boolean }', ->
      expect ->
        DictG(String, MaybeG(Boolean)) {a: yes, b: yes, c: no, d: null}
      .to.not.throw TypeError
    it 'check {[key: String]: Boolean | String }', ->
      expect ->
        DictG(String, UnionG(Boolean, String)) {a: yes, b: 'yes', c: no, d: 'null'}
      .to.not.throw TypeError
    it 'check {[key: String]: Number & Integer }', ->
      expect ->
        DictG(String, IntersectionG(Number, IntegerT)) {a: 1, b: 2, c: 3}
      .to.not.throw TypeError
    it 'check {[key: String]: 1 | 2 | 3 }', ->
      expect ->
        DictG(String, EnumG 1, 2, 3) {a: 1, b: 2, c: 3}
      .to.not.throw TypeError
    it 'check {[key: String]: Array< String > }', ->
      expect ->
        DictG(String, ListG(String)) {
          a: ['a', 'b', 'c']
          b: ['a', 'b', 'c']
          c: ['a', 'b', 'c']
        }
      .to.not.throw TypeError
    it 'check {[key: String]: (String)=> Number }', ->
      expect ->
        DictG(String, FuncG(String, Number)) {
          a: -> 1
          b: -> 2
          c: -> 3
        }
      .to.not.throw TypeError
    it 'check {[key: String]: [String, Function] }', ->
      expect ->
        DictG(String, TupleG(String, Function)) {
          a: ['a', (->)]
          b: ['b', (->)]
          c: ['c', (->)]
        }
      .to.not.throw TypeError
    it 'check {[key: String]: {name: String} }', ->
      expect ->
        DictG(String, StructG(name: String)) {
          a: {name: 'name1'}
          b: {name: 'name2'}
          c: {name: 'name3'}
        }
      .to.not.throw TypeError
    it 'check {[key: String]: {size: Number} }', ->
      expect ->
        DictG(String, InterfaceG(size: Number)) {
          a: {size: 1}
          b: {size: 2}
          c: {size: 3}
        }
      .to.not.throw TypeError
    it 'check {[key: String]: Cucumber }', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber124 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        DictG(String, SampleG(GreenCucumber124)) {a: GreenCucumber124.new(), b: new GreenCucumber124}
      .to.not.throw TypeError
  describe 'throw when check not DictG', ->
    it 'throw when not check {[key: String]: String } (has null)', ->
      expect ->
        DictG(String, String) {a: 'a', b: 'b', c: 'c', d: null}
      .to.throw TypeError
    it 'throw when not check {[key: String]: String } (has undefined)', ->
      expect ->
        DictG(String, String) {a: 'a', b: 'b', c: 'c', d: undefined}
      .to.throw TypeError
    it 'throw when check {[key: Symbol]: String }', ->
      expect ->
        DictG(Symbol, String) {
          [Symbol('a')]: 'a'
          [Symbol('b')]: 'b'
          c: 'c'
        }
      .to.not.throw TypeError
    it 'throw when check {[key: Number]: String }', ->
      expect ->
        DictG(Number, String) {1: 'a', 2: 'b', 3: 'c'}
      .to.throw TypeError
    it 'throw when check {[key: String]: String }', ->
      expect ->
        DictG(String, String) {a: 'a', b: 'b', c: 3}
      .to.throw TypeError
    it 'throw when check {[key: String]: Number }', ->
      expect ->
        DictG(String, Number) {a: 1, b: 2, c: '3'}
      .to.throw TypeError
    it 'throw when check {[key: String]: Boolean }', ->
      expect ->
        DictG(String, Boolean) {a: yes, b: yes, c: 'no'}
      .to.throw TypeError
    it 'throw when check {[key: String]: Date }', ->
      expect ->
        DictG(String, Date) {a: new Date(), b: Date().now()}
      .to.throw TypeError
    it 'throw when check {[key: String]: Error }', ->
      expect ->
        DictG(String, Error) {a: new Error('Error'), b: 'Error'}
      .to.throw TypeError
    it 'throw when check {[key: String]: ?Boolean }', ->
      expect ->
        DictG(String, MaybeG(Boolean)) {a: yes, b: yes, c: no, d: 'null'}
      .to.throw TypeError
    it 'throw when check {[key: String]: Boolean | String }', ->
      expect ->
        DictG(String, UnionG(Boolean, String)) {a: yes, b: 'yes', c: no, d: 1}
      .to.throw TypeError
    it 'throw when check {[key: String]: Number & Integer }', ->
      expect ->
        DictG(String, IntersectionG(Number, IntegerT)) {a: 1, b: 2, c: 3.5}
      .to.throw TypeError
    it 'throw when check {[key: String]: 1 | 2 | 3 }', ->
      expect ->
        DictG(String, EnumG 1, 2, 3) {a: 1, b: 2, c: 3, d: 'string'}
      .to.throw TypeError
    it 'throw when check {[key: String]: Array< String > }', ->
      expect ->
        DictG(String, ListG(String)) {
          a: ['a', 'b', 'c']
          b: ['a', 'b', 'c']
          c: 3
        }
      .to.throw TypeError
    it 'throw when check {[key: String]: (String)=> Number }', ->
      expect ->
        DictG(String, FuncG(String, Number)) {
          a: -> 1
          b: -> 2
          c: 3
        }
      .to.throw TypeError
    it 'throw when check {[key: String]: [String, Function] }', ->
      expect ->
        DictG(String, TupleG(String, Function)) {
          a: ['a', (->)]
          b: ['b', (->)]
          c: ['c', 'function(){}']
        }
      .to.throw TypeError
    it 'throw when check {[key: String]: {name: String} }', ->
      expect ->
        DictG(String, StructG(name: String)) {
          a: {name: 'name1'}
          b: {name: 'name2'}
          c: {name: 3}
        }
      .to.throw TypeError
    it 'throw when check {[key: String]: {size: Number} }', ->
      expect ->
        DictG(String, InterfaceG(size: Number)) {
          a: {size: 1}
          b: {size: 2}
          c: {size: '3'}
        }
      .to.throw TypeError
    it 'throw when check {[key: String]: Cucumber }', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber125 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        DictG(String, SampleG(GreenCucumber125)) {a: GreenCucumber125.new(), b: new Object({})}
      .to.throw TypeError
