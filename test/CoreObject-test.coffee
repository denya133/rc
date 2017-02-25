{ expect } = require 'chai'
RC = require '../lib'
CoreObject = RC::CoreObject

describe 'CoreObject', ->
  describe 'constructor', ->
    it 'should be created (via `new` operator)', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @Module: Test
        new Test::SubTest()
      .to.not.throw Error
  describe '#new', ->
    it 'should be created (via `.new` method)', ->
      expect ->
        class Test
        class Test::SubTest extends CoreObject
          @Module: Test
        Test::SubTest.new()
      .to.not.throw Error
