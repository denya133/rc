{ expect } = require 'chai'
RC = require '../lib'
CoreObject = RC::CoreObject

describe 'CoreObject', ->
  describe 'constructor', ->
    it 'should be created', ->
      class Test
      class Test::SubTest extends CoreObject
        @Module: Test
      expect -> new Test::SubTest()
      .to.not.throw Error
