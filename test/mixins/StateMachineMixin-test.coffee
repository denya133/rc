{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'StateMachineMixin', ->
  describe 'include StateMachineMixin', ->
    it 'should create new class with chains and instantiate', ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
