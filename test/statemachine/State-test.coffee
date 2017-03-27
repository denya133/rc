{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'State', ->
  describe '.new()', ->
    it 'should create new State instance', ->
      expect ->
        state = RC::State.new 'newState'
        assert.instanceOf state, RC::State, 'Cannot instantiate class State'
        assert.equal state.name, 'newState'
      .to.not.throw Error
  describe '#addTransition, #removeTransition', ->
    it 'should create new State instance', ->
      expect ->
        state1 = RC::State.new 'newState1'
        state2 = RC::State.new 'newState2'
        transition = {}
        state1.addTransition 'test', state2, transition
        assert.isDefined state1.getTransition('test'), 'No added transition'
        state1.removeTransition 'test'
        assert.isUndefined state1.getTransition('test'), 'Not removed transition'
      .to.not.throw Error
