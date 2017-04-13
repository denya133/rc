{ expect, assert } = require 'chai'
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
          ipmPrivateTest = @private _privateTest: Function,
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
          ipmPrivateTest = @private _privateTest: Function,
            default: ->
        test = Test::SubTest.new()
        test._privateTest()
      .to.throw Error
  describe '.protected', ->
    it 'should define and call protected method from public one in derived class', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          @protected protectedTest: Function,
            default: -> 4
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @Module: Test
          ipmProtectedTest = @protected protectedTest: Function,
            default: -> @super(arguments...) + 1
          @public test: Function,
            default: ->
              @[ipmProtectedTest]()
        test = Test::SubSubTest.new()
        if test.test() isnt 5
          throw 'Wrong calculation!'
      .to.not.throw Error
    it 'should define and cannot call protected method directly', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          ipmProtectedTest = @protected protectedTest: Function,
            default: ->
        test = Test::SubTest.new()
        test.protectedTest()
      .to.throw Error
    it 'should define and call protected method from derived class via `Symbol.for`', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
          @protected protectedTest: Function,
            default: -> 4
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @Module: Test
          ipmProtectedTest = Symbol.for '~protectedTest'
          @public test: Function,
            default: ->
              @[ipmProtectedTest]()
        test = Test::SubSubTest.new()
        if test.test() isnt 4
          throw 'Wrong calculation!'
      .to.not.throw Error
  describe '.superclass', ->
    it 'should have superclass', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @Module: Test
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @Module: Test
        assert Test::SubSubTest.superclass() is Test::SubTest, 'SubSubTest inheritance broken'
        assert Test::SubTest.superclass() is CoreObject, 'SubTest inheritance broken'
      .to.not.throw Error
  describe '.class', ->
    it 'should have class (static)', ->
      class Test
      class Test::SubTest extends CoreObject
        @inheritProtected()
        @Module: Test
      Test::SubTest.initialize()
      expect Test::SubTest.class()
      .to.equal RC::Class
  describe '#class', ->
    it 'should have class (instance)', ->
      class Test
      class Test::SubTest extends CoreObject
        @inheritProtected()
        @Module: Test
      Test::SubTest.initialize()
      expect Test::SubTest.new().class()
      .to.equal Test::SubTest
