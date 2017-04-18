{ expect, assert } = require 'chai'
RC = require '../lib'
Class = RC::Class

describe 'Class', ->
  describe '.new', ->
    it 'should create new class', ->
      expect ->
        class Test
        Test::MyClass = Class.new 'MyClass',
          Module: Test
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
    it 'should create new class with instance methods', ->
      expect ->
        class Test
        Test::MyClass = Class.new 'MyClass',
          Module: Test
          InstanceMethods:
            test: ->
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        myInstance.test()
      .to.not.throw Error
    it 'should create new class with class methods', ->
      expect ->
        class Test
        Test::MyClass = Class.new 'MyClass',
          Module: Test
          ClassMethods:
            test: ->
        Test::MyClass.initialize()
        Test::MyClass.test()
      .to.not.throw Error
  describe '.clone', ->
    it 'should clone specified class', ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
        Test::MyClass.initialize()
        Test::MyClassClone = RC::Class.clone Test::MyClass
        assert.notEqual Test::MyClass, Test::MyClassClone, 'Classes are same'
        assert.equal Test::MyClass.name, Test::MyClassClone.name, 'Class name is different'
        assert.equal Test::MyClass.__super__, Test::MyClassClone.__super__, 'Classes super proto not similar'
      .to.not.throw Error
