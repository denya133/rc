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

describe 'SampleG', ->
  describe 'checking SampleG', ->
    it 'check null by ?GreenCucumber128', ->
      expect ->
        class GreenCucumber128
        MaybeG(SampleG GreenCucumber128) null
      .to.not.throw TypeError
    it 'check undefined by ?GreenCucumber129', ->
      expect ->
        class GreenCucumber129
        MaybeG(SampleG GreenCucumber129) undefined
      .to.not.throw TypeError
    it 'check instance by ?GreenCucumber130', ->
      expect ->
        class GreenCucumber130
        MaybeG(SampleG GreenCucumber130) new GreenCucumber130
      .to.not.throw TypeError
    it 'check yes by Boolean | GreenCucumber131', ->
      expect ->
        class GreenCucumber131
        UnionG(Boolean, SampleG GreenCucumber131) yes
      .to.not.throw TypeError
    it 'check new GreenCucumber132 by Boolean | GreenCucumber131', ->
      expect ->
        class GreenCucumber132
        UnionG(Boolean, SampleG GreenCucumber132) new GreenCucumber132
      .to.not.throw TypeError
    it 'check {[String]: GreenCucumber133}', ->
      expect ->
        class GreenCucumber133
        DictG(String, SampleG GreenCucumber133) a: new GreenCucumber133
      .to.not.throw TypeError
    it 'check [String, GreenCucumber134]', ->
      expect ->
        class GreenCucumber134
        TupleG(String, SampleG GreenCucumber134) ['a', new GreenCucumber134]
      .to.not.throw TypeError
    it 'check {cuc: GreenCucumber135}', ->
      expect ->
        class GreenCucumber135
        StructG(cuc: SampleG GreenCucumber135) cuc: new GreenCucumber135
      .to.not.throw TypeError
    it 'check {size: GreenCucumber136}', ->
      expect ->
        class GreenCucumber136
        InterfaceG(size: SampleG GreenCucumber136) size: new GreenCucumber136
      .to.not.throw TypeError
    it 'check Array< GreenCucumber >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber137 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        ListG(SampleG(GreenCucumber137)) [GreenCucumber137.new(), new GreenCucumber137]
      .to.not.throw TypeError
  describe 'throw when check not SampleG', ->
    it 'throw when check null by ?GreenCucumber128', ->
      expect ->
        class GreenCucumber128
        MaybeG(SampleG GreenCucumber128) 1
      .to.throw TypeError
    it 'throw when check undefined by ?GreenCucumber129', ->
      expect ->
        class GreenCucumber129
        MaybeG(SampleG GreenCucumber129) 'undefined'
      .to.throw TypeError
    it 'throw when check instance by ?GreenCucumber130', ->
      expect ->
        class GreenCucumber130
        MaybeG(SampleG GreenCucumber130) new Object
      .to.throw TypeError
    it 'throw when check yes by Boolean | GreenCucumber131', ->
      expect ->
        class GreenCucumber131
        UnionG(Boolean, SampleG GreenCucumber131) new Date()
      .to.throw TypeError
    it 'throw when check new GreenCucumber132 by Boolean | GreenCucumber132', ->
      expect ->
        class GreenCucumber132
        UnionG(Boolean, SampleG GreenCucumber132) new Object
      .to.throw TypeError
    it 'throw when check {[String]: GreenCucumber133}', ->
      expect ->
        class GreenCucumber133
        DictG(String, SampleG GreenCucumber133) a: new Object
      .to.throw TypeError
    it 'throw when check [String, GreenCucumber134]', ->
      expect ->
        class GreenCucumber134
        TupleG(String, SampleG GreenCucumber134) ['a', new Object]
      .to.throw TypeError
    it 'throw when check {cuc: GreenCucumber135}', ->
      expect ->
        class GreenCucumber135
        StructG(cuc: SampleG GreenCucumber135) cuc: new Object
      .to.throw TypeError
    it 'throw when check {size: GreenCucumber136}', ->
      expect ->
        class GreenCucumber136
        InterfaceG(size: SampleG GreenCucumber136) size: new Object
      .to.throw TypeError
    it 'throw when check Array< GreenCucumber >', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class GreenCucumber137 extends RC::CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        ListG(SampleG(GreenCucumber137)) [GreenCucumber137.new(), new Object]
      .to.throw TypeError
