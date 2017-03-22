{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'ChainsMixin', ->
  describe 'include ChainsMixin', ->
    it 'should create new class with chains and instantiate', ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
    it 'should add chain `test` and call it', ->
      expect ->
        spyTest = sinon.spy ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @chains ['test']
          @public test: Function,
            configurable: yes
            default: spyTest
        Test::MyClass.initializeChains()
        Test::MyClass.initialize()
        assert.include Test::MyClass[Symbol.for 'internalChains'], 'test'
        myInstance = Test::MyClass.new()
        spyTestChain = sinon.spy myInstance, 'callAsChain'
        myInstance.test()
        assert spyTest.called, "Test didn't called"
        assert spyTestChain.called, "callAsChain didn't called"
      .to.not.throw Error
    it 'should add chain and initial, before, after and finally hooks, and call it', ->
      expect ->
        spyTest = sinon.spy ->
        spyInitial = sinon.spy ->
        spyBefore = sinon.spy ->
        spyAfter = sinon.spy ->
        spyFinally = sinon.spy ->
        spyError = sinon.spy ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @chains [ 'test' ]
          @initialHook 'initialTest', only: [ 'test' ]
          @beforeHook 'beforeTest1', only: [ 'test' ]
          @beforeHook 'beforeTest2', only: [ 'test' ]
          @afterHook 'afterTest', only: [ 'test' ]
          @finallyHook 'finallyTest', only: [ 'test' ]
          @errorHook 'errorTest', only: [ 'test' ]
          @public test: Function,
            configurable: yes
            default: spyTest
          @public initialTest: Function,
            default: spyInitial
          @public beforeTest1: Function,
            default: spyBefore
          @public beforeTest2: Function,
            default: spyBefore
          @public afterTest: Function,
            default: spyAfter
          @public finallyTest: Function,
            default: spyFinally
          @public errorTest: Function,
            default: spyFinally
        Test::MyClass.initializeChains()
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        myInstance.test()
        assert spyInitial.calledBefore(spyBefore), "Test initial hook didn't called"
        assert spyBefore.calledBefore(spyTest), "Test before hook didn't called"
        assert spyBefore.calledTwice, "Test before hook didn't called twice"
        assert spyTest.called, "Test didn't called"
        assert spyAfter.calledAfter(spyTest), "Test after hook didn't called"
        assert spyFinally.calledAfter(spyAfter), "Test finally hook didn't called"
        assert not spyError.called, "Test error hook called"
      .to.not.throw Error
