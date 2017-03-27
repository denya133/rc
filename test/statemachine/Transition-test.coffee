{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'Transition', ->
  describe '.new()', ->
    it 'should create new Transition instance', ->
      expect ->
        stateMachine = RC::Transition.new 'newTransition'
        assert.instanceOf stateMachine, RC::Transition, 'Cannot instantiate class Transition'
        assert.equal stateMachine.name, 'newTransition'
      .to.not.throw Error
