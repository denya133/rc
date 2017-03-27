{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'StateMachine', ->
  describe '.new()', ->
    it 'should create new StateMachine instance', ->
      expect ->
        stateMachine = RC::StateMachine.new()
        assert.instanceOf stateMachine, RC::StateMachine, 'Cannot instantiate class StateMachine'
      .to.not.throw Error
