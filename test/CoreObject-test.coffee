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
        class Test::Mixin extends Mixin
          @Module: Test
          test: ->
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          @include Test::Mixin
        test = Test::SubTest.new()
        test.test()
      .to.not.throw Error
  describe '.public', ->
    it 'should define and call public method', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          @public test: Function,
            default: ->
        test = Test::SubTest.new()
        test.test()
      .to.not.throw Error
  describe '.private', ->
    it 'should define and call private method from public one', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          ipmPrivateTest = @private privateTest: Function,
            default: ->
          @public test: Function,
            default: ->
              @[ipmPrivateTest]()
        test = Test::SubTest.new()
        test.test()
      .to.not.throw Error
    it 'should define and cannot call private method directly', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          ipmPrivateTest = @private privateTest: Function,
            default: ->
        test = Test::SubTest.new()
        test.privateTest()
      .to.throw Error
