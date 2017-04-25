{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require '../lib'
CoreObject = RC::CoreObject
Mixin = RC::Mixin

describe 'CoreObject', ->
  describe 'constructor', ->
    it 'should be created (via `new` operator)', ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
        Test::SubTest.initialize()
        new Test::SubTest()
      .to.not.throw Error
  describe '.new', ->
    it 'should be created (via `.new` method)', ->
      expect ->
        spyInit = sinon.spy -> @super arguments...
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @public init: Function,
            default: spyInit
        Test::SubTest.initialize()
        Test::SubTest.new()
        assert.isTrue spyInit.called, 'Init not called'
      .to.not.throw Error
  describe '.include', ->
    it 'should include mixin and call included method', ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        Test.defineMixin 'Mixin', (BaseClass) ->
          class Mixin extends BaseClass
            @inheritProtected()
            test: ->
          Mixin.initializeMixin()
        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @include Test::Mixin
        Test::SubTest.initialize()
        test = Test::SubTest.new()
        test.test()
      .to.not.throw Error
  describe '.public', ->
    it 'should define and call public method', ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @public test: Function,
            default: ->
        test = Test::SubTest.new()
        test.test()
      .to.not.throw Error
  describe '.private', ->
    it 'should define and call private method from public one', ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
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
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          ipmPrivateTest = @private _privateTest: Function,
            default: ->
        test = Test::SubTest.new()
        test._privateTest()
      .to.throw Error
  describe '.protected', ->
    it 'should define and call protected method from public one in derived class', ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @protected protectedTest: Function,
            default: -> 4
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @module Test
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
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          ipmProtectedTest = @protected protectedTest: Function,
            default: ->
        test = Test::SubTest.new()
        test.protectedTest()
      .to.throw Error
    it 'should define and call protected method from derived class via `Symbol.for`', ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @protected protectedTest: Function,
            default: -> 4
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @module Test
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
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @module Test
        assert Test::SubSubTest.superclass() is Test::SubTest, 'SubSubTest inheritance broken'
        assert Test::SubTest.superclass() is CoreObject, 'SubTest inheritance broken'
      .to.not.throw Error
  describe '.class', ->
    it 'should have class (static)', ->
      class Test extends RC::Module
        @inheritProtected()
      Test.initialize()

      class Test::SubTest extends CoreObject
        @inheritProtected()
        @module Test
      Test::SubTest.initialize()
      expect Test::SubTest.class()
      .to.equal RC::Class
  describe '#class', ->
    it 'should have class (instance)', ->
      class Test extends RC::Module
        @inheritProtected()
      Test.initialize()

      class Test::SubTest extends CoreObject
        @inheritProtected()
        @module Test
      Test::SubTest.initialize()
      expect Test::SubTest.new().class()
      .to.equal Test::SubTest
  describe 'long inheritance chain', ->
    it 'should keep all inherited functions', ->
      class Test extends RC::Module
        @inheritProtected()
      Test.initialize()
      spyFirstTest = sinon.spy ->
      spyFourthTest = sinon.spy ->
      spyClassTest = sinon.spy ->
      Test.defineMixin 'FirstMixin', (BaseClass) ->
        class FirstMixin extends BaseClass
          @inheritProtected()
          @public test: Function,
            default: (args...) ->
              @super args...
              spyFirstTest()
        FirstMixin.initializeMixin()
      Test.defineMixin 'SecondMixin', (BaseClass) ->
        class SecondMixin extends BaseClass
          @inheritProtected()
        SecondMixin.initializeMixin()
      Test.defineMixin 'ThirdMixin', (BaseClass) ->
        class ThirdMixin extends BaseClass
          @inheritProtected()
        ThirdMixin.initializeMixin()
      Test.defineMixin 'FourthMixin', (BaseClass) ->
        class FourthMixin extends BaseClass
          @inheritProtected()
          @public test: Function,
            default: (args...) ->
              @super args...
              spyFourthTest()
        FourthMixin.initializeMixin()
      class Test::MyClass extends RC::CoreObject
        @inheritProtected()
        @include Test::FirstMixin
        @include Test::SecondMixin
        @include Test::ThirdMixin
        @include Test::FourthMixin
        @public test: Function,
          default: (args...) ->
            @super args...
            spyClassTest()
      Test::MyClass.initialize()
      test = Test::MyClass.new()
      test.test()
      assert.isTrue spyFirstTest.called
      assert.isTrue spyFourthTest.calledAfter spyFirstTest
      assert.isTrue spyClassTest.calledAfter spyFourthTest
      assert.isTrue spyFirstTest.calledOnce
      assert.isTrue spyFourthTest.calledOnce
      assert.isTrue spyClassTest.calledOnce
