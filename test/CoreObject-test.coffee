{ expect } = require 'chai'
RC = require '../lib'
CoreObject = RC::CoreObject

describe 'CoreObject', ->
  describe 'constructor', ->
    it 'should be created', ->
      expect new CoreObject()
      .to.not.throw Error
