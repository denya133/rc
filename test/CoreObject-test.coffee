{ expect } = require 'chai'
RC = require '../lib'
CoreObject = RC::CoreObject
Mixin = RC::Mixin

describe 'CoreObject', ->
  describe 'constructor', ->
    it 'should be created (via `new` operator)', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @Module: Test
        new Test::SubTest()
      .to.not.throw Error
  describe '.new', ->
    it 'should be created (via `.new` method)', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @Module: Test
        Test::SubTest.new()
      .to.not.throw Error
  describe '.include', ->
    it 'should include mixin and call included method', ->
      expect ->
        class Test
        class Test::Mixin1 extends Mixin
          @Module: Test
          test: ->
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          @include Test::Mixin1
        test = Test::SubTest.new()
        test.test()
      .to.not.throw Error
