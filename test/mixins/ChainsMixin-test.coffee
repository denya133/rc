{ expect, assert } = require 'chai'
RC = require.main.require 'lib'

describe 'ChainsMixin', ->
  describe 'include ChainsMixin', ->
    it 'Create new class with chains and instantiate', ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @chains ['test']
          @public test: Function,
            default: ->
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
