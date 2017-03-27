{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'StateMachineMixin', ->
  describe '.new()', ->
    it 'should create new class with chains and instantiate', ->
      expect ->
        stateMachine = RC::StateMachine.new()
        assert.instanceOf stateMachine, RC::StateMachine, 'Cannot instantiate class StateMachine'
      .to.not.throw Error
