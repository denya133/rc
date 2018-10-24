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

describe 'InterfaceG', ->
  describe 'checking InterfaceG', ->
    it 'check complex interface', ->
      expect ->
        InterfaceG(
          test: String, size: Number, getSize: Function
          time: Date
          isHidden: Boolean
          error: Error
        ) {
          test: 'name1'
          size: 1
          time: new Date
          isHidden: no
          error: new Error
          getSize: ->
        }
      .to.not.throw TypeError
    it 'check small interface', ->
      expect ->
        InterfaceG(
          test: String, size: Number, getSize: Function
        ) {
          test: 'name1'
          size: 1
          time: new Date
          isHidden: no
          error: new Error
          getSize: ->
        }
      .to.not.throw TypeError
    it 'check nested interface', ->
      expect ->
        InterfaceG(
          test: String, size: Number, child: InterfaceG getSize: Function
        ) {
          test: 'name1'
          size: 1
          child: getSize: ->
        }
      .to.not.throw TypeError
    it 'check {test: {name: String} }', ->
      expect ->
        InterfaceG(test: StructG name: String) test: name: 'name1'
      .to.not.throw TypeError
    it 'check {[key: String]: {size: Number} }', ->
      expect ->
        DictG(String, InterfaceG size: Number) {
          a: {size: 1}
          b: {size: 2}
          c: {size: 3}
        }
      .to.not.throw TypeError
    it 'check {size: 1 | 2 | 3}', ->
      expect ->
        InterfaceG(size: EnumG 1, 2, 3) {size: 1}
      .to.not.throw TypeError
    it 'check Array< {size: Number} >', ->
      expect ->
        ListG(InterfaceG(size: Number)) [
          {size: 1}
          {size: 2}
          {size: 3}
        ]
      .to.not.throw TypeError
    it 'check {size: ?Number} with undefined', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: undefined}
      .to.not.throw TypeError
    it 'check {size: ?Number}', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: 1}
      .to.not.throw TypeError
    it 'check [String, {size: Number}]', ->
      expect ->
        TupleG(String, InterfaceG size: Number) ['', {size: 1}]
        TupleG(String, InterfaceG size: Number) ['str', {size: 1}]
      .to.not.throw TypeError
    it 'check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {size: 1}
      .to.not.throw TypeError
    it 'check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {size: 'medium'}
      .to.not.throw TypeError
    it 'check {prop: Number & Integer}', ->
      expect ->
        InterfaceG(prop: IntersectionG(Number, IntegerT)) prop: 0
        InterfaceG(prop: IntersectionG(Number, IntegerT)) prop: 1
        InterfaceG(prop: IntersectionG(Number, IntegerT)) prop: 10000000
        InterfaceG(prop: IntersectionG(Number, IntegerT)) prop: -1999999
      .to.not.throw TypeError
    it 'check {tomato: Tomato161}', ->
      expect ->
        class Tomato161
        InterfaceG(tomato: SampleG Tomato161) tomato: new Tomato161
      .to.not.throw TypeError
    it 'check {cuc: GreenCucumber161}', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber161 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        InterfaceG(cuc: SampleG GreenCucumber161) cuc: GreenCucumber161.new()
      .to.not.throw TypeError
  describe 'throw when check not InterfaceG', ->
    it 'throw when check complex interface', ->
      expect ->
        InterfaceG(
          test: String, size: Number, getSize: Function
          time: Date
          isHidden: Boolean
          error: Error
        ) {}
      .to.throw TypeError
    it 'throw when check small interface', ->
      expect ->
        InterfaceG(
          test: String, size: Number, getSize: Function
        ) {
          test: 'name1'
          time: new Date
          isHidden: no
          error: new Error
          getSize: ->
        }
      .to.throw TypeError
    it 'throw when check nested interface', ->
      expect ->
        InterfaceG(
          test: String, size: Number, child: InterfaceG getSize: Function
        ) {
          test: 'name1'
          size: 1
          child: getSizes: ->
        }
      .to.throw TypeError
    it 'throw when check {test: {name: String} }', ->
      expect ->
        InterfaceG(test: StructG name: String) test: name: 'name1', size: 1
      .to.throw TypeError
    it 'throw when check {[key: String]: {size: Number} }', ->
      expect ->
        DictG(String, InterfaceG size: Number) {
          a: {size: 1}
          b: {size: 2}
          c: {size: '3'}
        }
      .to.throw TypeError
    it 'throw when check {size: 1 | 2 | 3}', ->
      expect ->
        InterfaceG(size: EnumG 1, 2, 3) {size: 4}
      .to.throw TypeError
    it 'throw when check Array< {size: Number} >', ->
      expect ->
        ListG(InterfaceG(size: Number)) [
          {size: 1}
          {size: 2}
          {size: '3'}
        ]
      .to.throw TypeError
    it 'throw when check {size: ?Number} with undefined', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: 'undefined'}
      .to.throw TypeError
    it 'throw when check {size: ?Number}', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: Infinity}
      .to.throw TypeError
    it 'throw when check [String, {size: Number}]', ->
      expect ->
        TupleG(String, InterfaceG size: Number) ['', {size: NaN}]
      .to.throw TypeError
    it 'throw when check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {sizes: 1}
      .to.throw TypeError
    it 'throw when check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {size: null}
      .to.throw TypeError
    it 'throw when check {prop: Number & Integer}', ->
      expect ->
        InterfaceG(prop: IntersectionG(Number, IntegerT)) prop: 3.5
      .to.throw TypeError
    it 'throw when check {tomato: Tomato162}', ->
      expect ->
        class Tomato162
        InterfaceG(tomato: SampleG Tomato162) cuc: new Object
      .to.throw TypeError
    it 'throw when check {cuc: GreenCucumber162}', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber162 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        InterfaceG(cuc: SampleG GreenCucumber162) cuc: new Object
      .to.throw TypeError
