{ expect, assert } = require 'chai'
RC = require '../lib'
Class = RC::Class

describe 'Class', ->
  describe '.new', ->
    it 'should create new class', ->
      expect ->
        class Test
        Test::MyClass = Class.new 'MyClass', {}
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        if myInstance.class().name isnt 'MyClass'
          throw new Error 'Cannot instantiate class MyClass'
      .to.not.throw Error
    it 'should create new class with instance methods', ->
      expect ->
        class Test
        Test::MyClass = Class.new 'MyClass',
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
          ClassMethods:
            test: ->
        Test::MyClass.initialize()
        Test::MyClass.test()
      .to.not.throw Error
