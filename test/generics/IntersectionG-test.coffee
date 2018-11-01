{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  IntegerT
  FunctionT
  ListG
  SampleG
  InterfaceG
  StructG
  TupleG
  DictG
  EnumG
  IntersectionG
  UnionG
  MaybeG
} = RC::

describe 'IntersectionG', ->
  describe 'checking IntersectionG', ->
    it 'check Number & Integer', ->
      expect ->
        IntersectionG(Number, IntegerT) 0
        IntersectionG(Number, IntegerT) 1
        IntersectionG(Number, IntegerT) -16565555
        IntersectionG(Number, IntegerT) 199999
      .to.not.throw TypeError
    it 'check Number & 0 | 1 | 2 | 3 | 4 | 5', ->
      expect ->
        IntersectionG(Number, EnumG [0..5]) 3
      .to.not.throw TypeError
    it 'check Number & (String | Integer)', ->
      expect ->
        IntersectionG(Number, UnionG String, IntegerT) 0
      .to.not.throw TypeError
  describe 'throw when check not IntersectionG', ->
    it 'throw when check Number & Integer', ->
      expect ->
        IntersectionG(Number, IntegerT) 3.5
      .to.throw TypeError
    it 'throw when check Number & 0 | 1 | 2 | 3 | 4 | 5', ->
      expect ->
        IntersectionG(Number, EnumG [0..5]) 7
      .to.throw TypeError
    it 'throw when check Number & (String | Integer)', ->
      expect ->
        IntersectionG(Number, UnionG String, IntegerT) 'string'
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        IntersectionG(Number, IntegerT) 'string'
      .to.throw TypeError
    it 'throw when check date', ->
      expect ->
        IntersectionG(Number, IntegerT) new Date
      .to.throw TypeError
    it 'throw when check boolean', ->
      expect ->
        IntersectionG(Number, IntegerT) yes
      .to.throw TypeError
    it 'throw when check error', ->
      expect ->
        IntersectionG(Number, IntegerT) new Error
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        IntersectionG(Number, IntegerT) Symbol()
      .to.throw TypeError
    it 'throw when check map', ->
      expect ->
        IntersectionG(Number, IntegerT) new Map
      .to.throw TypeError
    it 'throw when check set', ->
      expect ->
        IntersectionG(Number, IntegerT) new Set
      .to.throw TypeError
    it 'throw when check buffer', ->
      expect ->
        IntersectionG(Number, IntegerT) Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        IntersectionG(Number, IntegerT) []
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        InterfaceG(test123: String) RC::CoreObject
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        IntersectionG(Number, IntegerT) (->)
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        IntersectionG(Number, IntegerT) null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        IntersectionG(Number, IntegerT) undefined
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        IntersectionG(Number, IntegerT) Promise.resolve()
      .to.throw TypeError
    it 'throw when check regexp', ->
      expect ->
        IntersectionG(Number, IntegerT) /.*/
      .to.throw TypeError
