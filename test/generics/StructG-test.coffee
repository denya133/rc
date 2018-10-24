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

describe 'StructG', ->
  describe 'checking StructG', ->
    it 'check complex struct', ->
      expect ->
        StructG(
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
    it 'check small struct', ->
      expect ->
        StructG(
          test: String, size: Number, getSize: Function
        ) {
          test: 'name1'
          size: 1
          getSize: ->
        }
      .to.not.throw TypeError
    it 'check nested struct', ->
      expect ->
        StructG(
          test: String, size: Number, child: StructG getSize: Function
        ) {
          test: 'name1'
          size: 1
          child: getSize: ->
        }
      .to.not.throw TypeError
    it 'check {test: {name: String} }', ->
      expect ->
        StructG(test: InterfaceG name: String) test: name: 'name1'
      .to.not.throw TypeError
    it 'check {[key: String]: {size: Number} }', ->
      expect ->
        DictG(String, StructG size: Number) {
          a: {size: 1}
          b: {size: 2}
          c: {size: 3}
        }
      .to.not.throw TypeError
    it 'check {size: 1 | 2 | 3}', ->
      expect ->
        StructG(size: EnumG 1, 2, 3) {size: 1}
      .to.not.throw TypeError
    it 'check Array< {size: Number} >', ->
      expect ->
        ListG(StructG(size: Number)) [
          {size: 1}
          {size: 2}
          {size: 3}
        ]
      .to.not.throw TypeError
    it 'check {size: ?Number} with undefined', ->
      expect ->
        StructG(size: MaybeG Number) {size: undefined}
      .to.not.throw TypeError
    it 'check {size: ?Number}', ->
      expect ->
        StructG(size: MaybeG Number) {size: 1}
      .to.not.throw TypeError
    it 'check [String, {size: Number}]', ->
      expect ->
        TupleG(String, StructG size: Number) ['', {size: 1}]
        TupleG(String, StructG size: Number) ['str', {size: 1}]
      .to.not.throw TypeError
    it 'check {size: Number | String}', ->
      expect ->
        StructG(size: UnionG Number, String) {size: 1}
      .to.not.throw TypeError
    it 'check {size: Number | String}', ->
      expect ->
        StructG(size: UnionG Number, String) {size: 'medium'}
      .to.not.throw TypeError
    it 'check {prop: Number & Integer}', ->
      expect ->
        StructG(prop: IntersectionG(Number, IntegerT)) prop: 0
        StructG(prop: IntersectionG(Number, IntegerT)) prop: 1
        StructG(prop: IntersectionG(Number, IntegerT)) prop: 10000000
        StructG(prop: IntersectionG(Number, IntegerT)) prop: -1999999
      .to.not.throw TypeError
    it 'check {tomato: Tomato171}', ->
      expect ->
        class Tomato171
        StructG(tomato: SampleG Tomato171) tomato: new Tomato171
      .to.not.throw TypeError
    it 'check {cuc: GreenCucumber171}', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber171 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        StructG(cuc: SampleG GreenCucumber171) cuc: GreenCucumber171.new()
      .to.not.throw TypeError
  describe 'throw when check not StructG', ->
    it 'throw when check complex struct', ->
      expect ->
        StructG(
          test: String, size: Number, getSize: Function
          time: Date
          isHidden: Boolean
          error: Error
        ) {}
      .to.throw TypeError
    it 'throw when check small struct', ->
      expect ->
        StructG(
          test: String, size: Number, getSize: Function
        ) {
          test: 'name1'
          time: new Date
          isHidden: no
          error: new Error
          getSize: ->
        }
      .to.throw TypeError
    it 'throw when check nested struct', ->
      expect ->
        StructG(
          test: String, size: Number, child: StructG getSize: Function
        ) {
          test: 'name1'
          size: 1
          child: getSizes: ->
        }
      .to.throw TypeError
    it 'throw when check {test: {name: String} }', ->
      expect ->
        StructG(test: InterfaceG name: String) test: name: 1
      .to.throw TypeError
    it 'throw when check {[key: String]: {size: Number} }', ->
      expect ->
        DictG(String, StructG size: Number) {
          a: {size: 1}
          b: {size: 2}
          c: {size: '3'}
        }
      .to.throw TypeError
    it 'throw when check {size: 1 | 2 | 3}', ->
      expect ->
        StructG(size: EnumG 1, 2, 3) {size: 4}
      .to.throw TypeError
    it 'throw when check Array< {size: Number} >', ->
      expect ->
        ListG(StructG(size: Number)) [
          {size: 1}
          {size: 2}
          {size: '3'}
        ]
      .to.throw TypeError
    it 'throw when check {size: ?Number} with undefined', ->
      expect ->
        StructG(size: MaybeG Number) {size: 'undefined'}
      .to.throw TypeError
    it 'throw when check {size: ?Number}', ->
      expect ->
        StructG(size: MaybeG Number) {size: Infinity}
      .to.throw TypeError
    it 'throw when check [String, {size: Number}]', ->
      expect ->
        TupleG(String, StructG size: Number) ['', {size: NaN}]
      .to.throw TypeError
    it 'throw when check {size: Number | String}', ->
      expect ->
        StructG(size: UnionG Number, String) {sizes: 1}
      .to.throw TypeError
    it 'throw when check {size: Number | String}', ->
      expect ->
        StructG(size: UnionG Number, String) {size: null}
      .to.throw TypeError
    it 'throw when check {prop: Number & Integer}', ->
      expect ->
        StructG(prop: IntersectionG(Number, IntegerT)) prop: 3.5
      .to.throw TypeError
    it 'throw when check {tomato: Tomato172}', ->
      expect ->
        class Tomato172
        StructG(tomato: SampleG Tomato172) cuc: new Object
      .to.throw TypeError
    it 'throw when check {cuc: GreenCucumber172}', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber172 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        StructG(cuc: SampleG GreenCucumber172) cuc: new Object
      .to.throw TypeError
