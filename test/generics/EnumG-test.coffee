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

describe 'EnumG', ->
  describe 'checking EnumG', ->
    it 'check one value in EnumG', ->
      expect ->
        EnumG([1]) 1
      .to.not.throw TypeError
    it 'check a | b | c', ->
      expect ->
        EnumG('a', 'b', 'c') 'c'
      .to.not.throw TypeError
    it 'check 1 | 2 | 3', ->
      expect ->
        EnumG(1, 2, 3) 3
      .to.not.throw TypeError
    it 'check yes by yes | no', ->
      expect ->
        EnumG([yes, no]) yes
      .to.not.throw TypeError
    it 'check no by yes | no', ->
      expect ->
        EnumG([yes, no]) no
      .to.not.throw TypeError
    it 'check null by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) null
      .to.not.throw TypeError
    it 'check undefined by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) undefined
      .to.not.throw TypeError
    it 'check Infinity by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) Infinity
      .to.not.throw TypeError
    it 'check NaN by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) NaN
      .to.not.throw TypeError
    it 'check Date by Number | String | Date', ->
      expect ->
        EnumG(Number, String, Date) Date
      .to.not.throw TypeError
    it 'check Error by Error | TypeError', ->
      expect ->
        EnumG(Error, TypeError) TypeError
      .to.not.throw TypeError
    it 'check 1 by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') 1
      .to.not.throw TypeError
    it 'check str by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') 'str'
      .to.not.throw TypeError
    it 'check null by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') null
      .to.not.throw TypeError
    it 'check undefined by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') undefined
      .to.not.throw TypeError
    it 'check yes by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') yes
      .to.not.throw TypeError
    it 'check 1 by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') 1
      .to.not.throw TypeError
    it 'check str by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') 'str'
      .to.not.throw TypeError
    it 'check Number & 0 | 1 | 2 | 3 | 4 | 5', ->
      expect ->
        IntersectionG(Number, EnumG [0..5]) 3
      .to.not.throw TypeError
    it 'check {[key: String]: 1 | 2 | 3 }', ->
      expect ->
        DictG(String, EnumG 1, 2, 3) {a: 1, b: 2, c: 3}
      .to.not.throw TypeError
    it 'check Array< a | b | c >', ->
      expect ->
        ListG(EnumG 'a', 'b', 'c') ['a', 'b', 'c', 'a', 'b', 'c']
      .to.not.throw TypeError
    it 'check [String, a | b | c]', ->
      expect ->
        TupleG(String, EnumG 'a', 'b', 'c') ['key', 'a']
      .to.not.throw TypeError
    it 'check {name: name | fullname}', ->
      expect ->
        StructG(name: EnumG 'name', 'fullname') {name: 'name'}
      .to.not.throw TypeError
    it 'check {size: 1 | 2 | 3}', ->
      expect ->
        InterfaceG(size: EnumG 1, 2, 3) {size: 1}
      .to.not.throw TypeError
  describe 'throw when check not EnumG', ->
    it 'throw when check one value in EnumG', ->
      expect ->
        EnumG() 1
      .to.throw TypeError
    it 'throw when check a | b | c', ->
      expect ->
        EnumG('a', 'b', 'c') 'd'
      .to.throw TypeError
    it 'throw when check 1 | 2 | 3', ->
      expect ->
        EnumG(1, 2, 3) 4
      .to.throw TypeError
    it 'throw when check yes by yes | no', ->
      expect ->
        EnumG([yes, no]) 'yes'
      .to.throw TypeError
    it 'throw when check no by yes | no', ->
      expect ->
        EnumG([yes, no]) 'no'
      .to.throw TypeError
    it 'throw when check null by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) 'null'
      .to.throw TypeError
    it 'throw when check undefined by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) 'undefined'
      .to.throw TypeError
    it 'throw when check Infinity by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) 'Infinity'
      .to.throw TypeError
    it 'throw when check NaN by null | undefined | yes | no | Infinity | NaN', ->
      expect ->
        EnumG(null, undefined, yes, no, Infinity, NaN) 'NaN'
      .to.throw TypeError
    it 'throw when check Date by Number | String | Date', ->
      expect ->
        EnumG(Number, String, Date) new Date
      .to.throw TypeError
    it 'throw when check Error by Error | TypeError', ->
      expect ->
        EnumG(Error, TypeError) ReferenceError
      .to.throw TypeError
    it 'throw when check 1 by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') '1'
      .to.throw TypeError
    it 'throw when check str by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') 'string'
      .to.throw TypeError
    it 'throw when check yes by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') null
      .to.throw TypeError
    it 'throw when check 1 by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') undefined
      .to.throw TypeError
    it 'throw when check str by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') 'yes'
      .to.throw TypeError
    it 'throw when check Number & 0 | 1 | 2 | 3 | 4 | 5', ->
      expect ->
        IntersectionG(Number, EnumG [0..5]) 7
      .to.throw TypeError
    it 'throw when check {[key: String]: 1 | 2 | 3 }', ->
      expect ->
        DictG(String, EnumG 1, 2, 3) {a: 1, b: 2, c: 4}
      .to.throw TypeError
    it 'throw when check Array< a | b | c >', ->
      expect ->
        ListG(EnumG 'a', 'b', 'c') ['a', 'b', 'c', 'a', 'b', 'd']
      .to.throw TypeError
    it 'throw when check [String, a | b | c]', ->
      expect ->
        TupleG(String, EnumG 'a', 'b', 'c') ['key', null]
      .to.throw TypeError
    it 'throw when check {name: name | fullname}', ->
      expect ->
        StructG(name: EnumG 'name', 'fullname') {name: ''}
      .to.throw TypeError
    it 'throw when check {size: 1 | 2 | 3}', ->
      expect ->
        InterfaceG(size: EnumG 1, 2, 3) {size: 'medium'}
      .to.throw TypeError
