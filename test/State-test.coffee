{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'State', ->
  describe '.new()', ->
    it 'should create new State instance', ->
      expect ->
        stateMachine = RC::State.new 'newState'
        assert.instanceOf stateMachine, RC::State, 'Cannot instantiate class State'
        assert.equal stateMachine.name, 'newState'
      .to.not.throw Error
