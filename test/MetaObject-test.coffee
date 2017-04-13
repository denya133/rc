{ expect, assert } = require 'chai'
RC = require '../lib'
MetaObject = RC::MetaObject

describe 'MetaObject', ->
  describe '.new', ->
    it 'should create new class', ->
      expect ->
        class Test
        class Test::MyClass extends MetaObject
          Module: Test
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
