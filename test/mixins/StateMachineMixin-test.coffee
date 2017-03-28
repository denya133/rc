{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'StateMachineMixin', ->
  describe 'include StateMachineMixin', ->
    it 'should create new class with state machine and instantiate', ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
  describe 'include and initialize StateMachineMixin', ->
    it 'should create new class with state machine and initialize default state machine', ->
      spySMConfig = sinon.spy ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
          @StateMachine 'default', spySMConfig
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
        assert.isTrue spySMConfig.called, 'Initializer did not called'
      .to.not.throw Error
