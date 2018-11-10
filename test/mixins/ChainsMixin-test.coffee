{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co } = RC::Utils

describe 'ChainsMixin', ->
  describe 'include ChainsMixin', ->
    it 'should create new class with chains and instantiate', ->
      expect ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @module Test
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
    it 'should add chain `test` and call it', ->
      co ->
        spyTest = sinon.spy -> yield return
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @module Test
          @chains ['test']
          @public @async test: Function,
            configurable: yes
            default: spyTest
        Test::MyClass.initialize()
        assert.property Test::MyClass.metaObject.getGroup('chains'), 'test'
        myInstance = Test::MyClass.new()
        spyTestChain = sinon.spy myInstance, 'callAsChain'
        yield myInstance.test()
        assert spyTest.called, "Test didn't called"
        assert spyTestChain.called, "callAsChain didn't called"
    it 'should add chain and initial, before, after and finally hooks, and call it', ->
      co ->
        spyTest = sinon.spy -> yield return
        spyInitial = sinon.spy (args...)-> yield return args
        spyBefore = sinon.spy (args...)-> yield return args
        spyAfter = sinon.spy (data)-> yield return data
        spyFinally = sinon.spy (data)-> yield return data
        spyError = sinon.spy -> yield return
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @module Test
          @chains [ 'test' ]
          @initialHook 'initialTest', only: [ 'test' ]
          @beforeHook 'beforeTest1', only: [ 'test' ]
          @beforeHook 'beforeTest2', only: [ 'test' ]
          @afterHook 'afterTest', only: [ 'test' ]
          @finallyHook 'finallyTest', only: [ 'test' ]
          @errorHook 'errorTest', only: [ 'test' ]
          @public @async test: Function,
            configurable: yes
            default: spyTest
          @public @async initialTest: Function,
            default: spyInitial
          @public @async beforeTest1: Function,
            default: spyBefore
          @public @async beforeTest2: Function,
            default: spyBefore
          @public @async afterTest: Function,
            default: spyAfter
          @public @async finallyTest: Function,
            default: spyFinally
          @public @async errorTest: Function,
            default: spyError
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        yield myInstance.test()
        assert spyInitial.calledBefore(spyBefore), "Test initial hook didn't called"
        assert spyBefore.calledBefore(spyTest), "Test before hook didn't called"
        assert spyBefore.calledTwice, "Test before hook didn't called twice"
        assert spyTest.called, "Test didn't called"
        assert spyAfter.calledAfter(spyTest), "Test after hook didn't called"
        assert spyFinally.calledAfter(spyAfter), "Test finally hook didn't called"
        assert not spyError.called, "Test error hook called"
    it 'should add chain and hooks, and throw an error inside it', ->
      co ->
        spyTest = sinon.spy -> throw new Error 'Fail!'
        spyInitial = sinon.spy (args...)-> yield return args
        spyBefore = sinon.spy (args...)-> yield return args
        spyAfter = sinon.spy (data)-> yield return data
        spyFinally = sinon.spy (data)-> yield return data
        spyError = sinon.spy -> yield return
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @module Test
          @chains [ 'test' ]
          @initialHook 'initialTest', only: [ 'test' ]
          @beforeHook 'beforeTest', only: [ 'test' ]
          @afterHook 'afterTest', only: [ 'test' ]
          @finallyHook 'finallyTest', only: [ 'test' ]
          @errorHook 'errorTest', only: [ 'test' ]
          @public @async test: Function,
            configurable: yes
            default: spyTest
          @public @async initialTest: Function,
            default: spyInitial
          @public @async beforeTest: Function,
            default: spyBefore
          @public @async afterTest: Function,
            default: spyAfter
          @public @async finallyTest: Function,
            default: spyFinally
          @public @async errorTest: Function,
            default: spyError
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        try yield myInstance.test()
        assert.isTrue spyInitial.calledBefore(spyBefore), "Test initial hook didn't called"
        assert.isTrue spyBefore.calledBefore(spyTest), "Test before hook didn't called"
        assert.isTrue spyTest.called, "Test didn't called"
        assert.isFalse spyAfter.called, "Test after hook called"
        assert.isFalse spyFinally.called, "Test finally hook called"
        assert.isTrue spyError.called, "Test error not hook called"
    it 'should call hooks in proper order', ->
      co ->
        spyTest = sinon.spy -> yield return
        spyFirst = sinon.spy (args...)-> yield return args
        spySecond = sinon.spy (args...)-> yield return args
        spyThird = sinon.spy (args...)-> yield return args
        spyFourth = sinon.spy (data)-> yield return data
        spyFifth = sinon.spy (data)-> yield return data
        spyError = sinon.spy -> yield return
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @module Test
          @chains [ 'test' ]
          @finallyHook 'fifthTest', only: [ 'test' ]
          @afterHook 'fourthTest', only: [ 'test' ]
          @beforeHook 'thirdTest', only: [ 'test' ]
          @initialHook 'firstTest', only: [ 'test' ]
          @initialHook 'secondTest', only: [ 'test' ]
          @errorHook 'errorTest', only: [ 'test' ]
          @public @async test: Function,
            configurable: yes
            default: spyTest
          @public @async firstTest: Function,
            default: spyFirst
          @public @async secondTest: Function,
            default: spySecond
          @public @async thirdTest: Function,
            default: spyThird
          @public @async fourthTest: Function,
            default: spyFourth
          @public @async fifthTest: Function,
            default: spyFifth
          @public @async errorTest: Function,
            default: spyError
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        try yield myInstance.test()
        assert spyFirst.calledBefore(spySecond), "Test first hook not called properly"
        assert spySecond.calledBefore(spyThird), "Test second hook not called properly"
        assert spyThird.calledBefore(spyTest), "Test third hook not called properly"
        assert spyTest.calledBefore(spyFourth), "Test not called properly"
        assert spyFourth.calledBefore(spyFifth), "Test fourth hook not called properly"
        assert spyFifth.called, "Test fifth hook not called properly"
        assert not spyError.called, "Test error hook called"
  describe 'correct mixing in', ->
    it 'should call correctly support mixins', ->
      co ->
        spyTest = sinon.spy -> yield return
        spyBeforeTest = sinon.spy (args...)-> yield return args
        spyMixinInitialize = sinon.spy -> yield return
        spyMyInitialize = sinon.spy -> yield return
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        Test.defineMixin RC::Mixin 'MyMixin', (BaseClass) ->
          class extends BaseClass
            @inheritProtected()
            @public @static initialize: Function,
              configurable: yes
              default: (args...) ->
                spyMixinInitialize()
                @super args...
            @initializeMixin()
        Test.defineMixin RC::Mixin 'AnotherMixin', (BaseClass) ->
          class extends BaseClass
            @inheritProtected()
            @initializeMixin()
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include Test::MyMixin
          @include RC::ChainsMixin
          @include Test::AnotherMixin
          @module Test
          @chains [ 'test' ]
          @beforeHook 'beforeTest', only: [ 'test' ]
          @public @async test: Function,
            configurable: yes
            default: spyTest
          @public @async beforeTest: Function,
            default: spyBeforeTest
          @public @static initialize: Function,
            configurable: yes
            default: (args...) ->
              spyMyInitialize()
              @super args...
        Test::MyClass.initialize()
        class Test::AnotherClass extends Test::MyClass
          @inheritProtected()
          @module Test
        Test::AnotherClass.initialize()
        myInstance = Test::AnotherClass.new()
        yield myInstance.test()
        assert spyMyInitialize.called, "MyClass initialize not called properly"
        assert spyMixinInitialize.called, "Mixin initialize not called properly"
        assert spyTest.called, "Test not called properly"
        assert spyBeforeTest.called, "Test before hook not called properly"
