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
