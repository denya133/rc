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

describe 'UnionG', ->
  describe 'checking UnionG', ->
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
    it 'check null by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) null
      .to.not.throw TypeError
    it 'check undefined by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) undefined
      .to.not.throw TypeError
    it 'check yes by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) yes
      .to.not.throw TypeError
    it 'check string by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) 'string'
      .to.not.throw TypeError
    it 'check yes by Boolean | String', ->
      expect ->
        UnionG(Boolean, String) yes
      .to.not.throw TypeError
    it 'check string by Boolean | String', ->
      expect ->
        UnionG(Boolean, String) 'string'
      .to.not.throw TypeError
    it 'check {[key: String]: Boolean | String }', ->
      expect ->
        DictG(String, UnionG Boolean, String) {a: yes, b: 'yes', c: no, d: 'null'}
      .to.not.throw TypeError
    it 'check [String, Boolean | String]', ->
      expect ->
        TupleG(String, UnionG Boolean, String) ['', yes]
        TupleG(String, UnionG Boolean, String) ['yes', yes]
        TupleG(String, UnionG Boolean, String) ['yes', no]
        TupleG(String, UnionG Boolean, String) ['yes', 'null']
      .to.not.throw TypeError
    it 'check String | (String)=> Number', ->
      expect ->
        UnionG(String, FunctionT) ''
        UnionG(String, FunctionT) (->)
      .to.not.throw TypeError
    it 'check String | (Number & Integer)', ->
      expect ->
        UnionG(String, IntersectionG Number, IntegerT) ''
        UnionG(String, IntersectionG Number, IntegerT) 1
      .to.not.throw TypeError
    it 'check Number & (String | Integer)', ->
      expect ->
        IntersectionG(Number, UnionG String, IntegerT) 0
      .to.not.throw TypeError
    it 'check {name: Boolean | String}', ->
      expect ->
        StructG(name: UnionG Boolean, String) {name: 'name1'}
      .to.not.throw TypeError
    it 'check {name: Boolean | String}', ->
      expect ->
        StructG(name: UnionG Boolean, String) {name: yes}
      .to.not.throw TypeError
    it 'check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {size: 1}
      .to.not.throw TypeError
    it 'check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {size: 'medium'}
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
    it 'check Array< Boolean | String >', ->
      expect ->
        ListG(UnionG Boolean, String) [yes, 'yes', no, 'null']
      .to.not.throw TypeError
    it 'check yes by Boolean | GreenCucumber141', ->
      expect ->
        class GreenCucumber141
        UnionG(Boolean, SampleG GreenCucumber141) yes
      .to.not.throw TypeError
    it 'check new GreenCucumber142 by Boolean | GreenCucumber142', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber142 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        UnionG(Boolean, SampleG GreenCucumber142) new GreenCucumber142
      .to.not.throw TypeError
  describe 'throw when check not UnionG', ->
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
    it 'throw when check null by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) Symbol()
      .to.throw TypeError
    it 'throw when check undefined by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) new Error ''
      .to.throw TypeError
    it 'throw when check yes by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) 1
      .to.throw TypeError
    it 'throw when check string by Boolean | ?String', ->
      expect ->
        UnionG(Boolean, MaybeG String) 1
      .to.throw TypeError
    it 'throw when check yes by Boolean | String', ->
      expect ->
        UnionG(Boolean, String) new Date
      .to.throw TypeError
    it 'throw when check string by Boolean | String', ->
      expect ->
        UnionG(Boolean, String) 1
      .to.throw TypeError
    it 'throw when check {[key: String]: Boolean | String }', ->
      expect ->
        DictG(String, UnionG Boolean, String) {a: yes, b: 'yes', c: no, d: null}
      .to.throw TypeError
    it 'throw when check [String, Boolean | String]', ->
      expect ->
        TupleG(String, UnionG Boolean, String) ['', 1]
      .to.throw TypeError
    it 'throw when check String | (String)=> Number', ->
      expect ->
        UnionG(String, FunctionT) 1
      .to.throw TypeError
    it 'throw when check String | (Number & Integer)', ->
      expect ->
        UnionG(String, IntersectionG Number, IntegerT) 3.5
      .to.throw TypeError
    it 'throw when check Number & (String | Integer)', ->
      expect ->
        IntersectionG(Number, UnionG String, IntegerT) 3.5
      .to.throw TypeError
    it 'throw when check {name: Boolean | String}', ->
      expect ->
        StructG(name: UnionG Boolean, String) {name: 1}
      .to.throw TypeError
    it 'throw when check {name: Boolean | String}', ->
      expect ->
        StructG(name: UnionG Boolean, String) {names: yes}
      .to.throw TypeError
    it 'throw when check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {size: yes}
      .to.throw TypeError
    it 'throw when check {size: Number | String}', ->
      expect ->
        InterfaceG(size: UnionG Number, String) {sizes: 'medium'}
      .to.throw TypeError
    it 'throw when check yes by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') null
      .to.throw TypeError
    it 'throw when check 1 by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') '1'
      .to.throw TypeError
    it 'throw when check str by Boolean | 1 | str', ->
      expect ->
        UnionG(Boolean, EnumG 1, 'str') null
      .to.throw TypeError
    it 'throw when check Array< Boolean | String >', ->
      expect ->
        ListG(UnionG Boolean, String) [yes, 'yes', no, null]
      .to.throw TypeError
    it 'throw when check yes by Boolean | GreenCucumber143', ->
      expect ->
        class GreenCucumber143
        UnionG(Boolean, SampleG GreenCucumber143) 'yes'
      .to.throw TypeError
    it 'throw when check new Object by Boolean | GreenCucumber144', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber144 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        UnionG(Boolean, SampleG GreenCucumber144) new Object
      .to.throw TypeError
