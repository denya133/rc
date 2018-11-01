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

describe 'MaybeG', ->
  describe 'checking MaybeG', ->
    it 'check null by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) null
      .to.not.throw TypeError
    it 'check undefined by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) undefined
      .to.not.throw TypeError
    it 'check yes by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) yes
      .to.not.throw TypeError
    it 'check string by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) 'string'
      .to.not.throw TypeError
    it 'check {[key: String]: ?Boolean }', ->
      expect ->
        DictG(String, MaybeG(Boolean)) {a: yes, b: yes, c: no, d: null}
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
    it 'check Array< ?Boolean >', ->
      expect ->
        ListG(MaybeG(Boolean)) [yes, yes, no, null]
      .to.not.throw TypeError
    it 'check null by ?GreenCucumber151', ->
      expect ->
        class GreenCucumber151
        MaybeG(SampleG GreenCucumber151) null
      .to.not.throw TypeError
    it 'check undefined by ?GreenCucumber152', ->
      expect ->
        class GreenCucumber152
        MaybeG(SampleG GreenCucumber152) undefined
      .to.not.throw TypeError
    it 'check instance by ?GreenCucumber153', ->
      expect ->
        class GreenCucumber153
        MaybeG(SampleG GreenCucumber153) new GreenCucumber153
      .to.not.throw TypeError
    it 'check [Error, ?Boolean]', ->
      expect ->
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), null]
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), undefined]
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), yes]
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), no]
      .to.not.throw TypeError
    it 'check ?String', ->
      expect ->
        MaybeG(String) 'a'
      .to.not.throw TypeError
    it 'check ?Number', ->
      expect ->
        MaybeG(Number) 1
      .to.not.throw TypeError
    it 'check ?Boolean', ->
      expect ->
        MaybeG(Boolean) yes
      .to.not.throw TypeError
    it 'check ?Date', ->
      expect ->
        MaybeG(Date) new Date()
      .to.not.throw TypeError
    it 'check ?Error', ->
      expect ->
        MaybeG(Error) new Error('Error')
      .to.not.throw TypeError
    it 'check ?(Number & Integer)', ->
      expect ->
        MaybeG(IntersectionG Number, IntegerT) null
        MaybeG(IntersectionG Number, IntegerT) 19999
      .to.not.throw TypeError
    it 'check ?()=>', ->
      expect ->
        MaybeG(FunctionT) null
        MaybeG(FunctionT) (->)
      .to.not.throw TypeError
    it 'check {name: ?String}', ->
      expect ->
        StructG(name: MaybeG String) {name: 'name1'}
      .to.not.throw TypeError
    it 'check {name: ?String} with null', ->
      expect ->
        StructG(name: MaybeG String) {name: null}
      .to.not.throw TypeError
    it 'check {size: ?Number} with undefined', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: undefined}
      .to.not.throw TypeError
    it 'check {size: ?Number}', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: 1}
      .to.not.throw TypeError
  describe 'throw when check not MaybeG', ->
    it 'throw when check null by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) Symbol()
      .to.throw TypeError
    it 'throw when check undefined by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) new Error ''
      .to.throw TypeError
    it 'throw when check yes by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) new Date
      .to.throw TypeError
    it 'throw when check string by ?(Boolean | String)', ->
      expect ->
        MaybeG(UnionG Boolean, String) 1
      .to.throw TypeError
    it 'throw when check {[key: String]: ?Boolean }', ->
      expect ->
        DictG(String, MaybeG(Boolean)) {a: yes, b: yes, c: no, d: 'null'}
      .to.throw TypeError
    it 'throw when check 1 by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') '1'
      .to.throw TypeError
    it 'throw when check str by ?(1 | str)', ->
      expect ->
        MaybeG(EnumG 1, 'str') 'string'
      .to.throw TypeError
    it 'throw when not check Array< ?Boolean >', ->
      expect ->
        ListG(MaybeG(Boolean)) [yes, yes, no, null, 'undefined']
      .to.throw TypeError
    it 'throw when check null by ?GreenCucumber154', ->
      expect ->
        class GreenCucumber154
        MaybeG(SampleG GreenCucumber154) 1
      .to.throw TypeError
    it 'throw when check undefined by ?GreenCucumber155', ->
      expect ->
        class GreenCucumber155
        MaybeG(SampleG GreenCucumber155) 'undefined'
      .to.throw TypeError
    it 'throw when check instance by ?GreenCucumber156', ->
      expect ->
        class GreenCucumber156
        MaybeG(SampleG GreenCucumber156) new Object
      .to.throw TypeError
    it 'throw when check [Error, ?Boolean] (not Error)', ->
      expect ->
        TupleG(Error, MaybeG(Boolean)) ['Error', null]
      .to.throw TypeError
    it 'throw when check [Error, ?Boolean] (not ?Boolean)', ->
      expect ->
        TupleG(Error, MaybeG(Boolean)) [new Error('Error'), 'undefined']
      .to.throw TypeError
    it 'throw when check ?String', ->
      expect ->
        MaybeG(String) 1
      .to.throw TypeError
    it 'throw when check ?Number', ->
      expect ->
        MaybeG(Number) '1'
      .to.throw TypeError
    it 'throw when check ?Boolean', ->
      expect ->
        MaybeG(Boolean) 'yes'
      .to.throw TypeError
    it 'throw when check ?Date', ->
      expect ->
        MaybeG(Date) Date.now()
      .to.throw TypeError
    it 'throw when check ?Error', ->
      expect ->
        MaybeG(Error) 'Error'
      .to.throw TypeError
    it 'throw when check ?(Number & Integer)', ->
      expect ->
        MaybeG(IntersectionG Number, IntegerT) 3.5
      .to.throw TypeError
    it 'throw when check ?()=>', ->
      expect ->
        MaybeG(FunctionT) '(->)'
      .to.throw TypeError
    it 'throw when check {name: ?String}', ->
      expect ->
        StructG(name: MaybeG String) {name: 1}
      .to.throw TypeError
    it 'throw when check {name: ?String}', ->
      expect ->
        StructG(name: MaybeG String) {name: yes}
      .to.throw TypeError
    it 'throw when check {size: ?Number}', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: 'undefined'}
      .to.throw TypeError
    it 'throw when check {size: ?Number}', ->
      expect ->
        InterfaceG(size: MaybeG Number) {size: yes}
      .to.throw TypeError
