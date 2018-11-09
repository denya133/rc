{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co } = RC::Utils

describe 'State', ->
  describe '.new()', ->
    it 'should create new State instance', ->
      expect ->
        stateMachine = RC::StateMachine.new 'default', {}
        state = RC::State.new 'newState', {}, stateMachine, {}
        assert.instanceOf state, RC::State, 'Cannot instantiate class State'
        assert.equal state.name, 'newState'
      .to.not.throw Error
  describe '#defineTransition, #removeTransition', ->
    it 'should successfully define transition and remove it', ->
      expect ->
        stateMachine = RC::StateMachine.new 'default', {}
        state1 = RC::State.new 'newState1', {}, stateMachine, {}
        state2 = RC::State.new 'newState2', {}, stateMachine, {}
        # transition = {}
        transition = RC::Transition.new 'newTransition', {}, {}
        state1.defineTransition 'test', state2, transition
        assert.isDefined state1.getEvent('test'), 'No added transition'
        state1.removeTransition 'test'
        assert.isUndefined state1.getEvent('test'), 'Not removed transition'
      .to.not.throw Error
  describe '#doBeforeEnter,
            #doEnter,
            #doAfterEnter,
            #doBeforeExit,
            #doExit,
            #doAfterExit', ->
    it 'should run hooks by order if present', ->
      co ->
        anchor =
          testBeforeEnter: ->
          testEnter: ->
          testAfterEnter: ->
          testBeforeExit: ->
          testExit: ->
          testAfterExit: ->
        spyTestBeforeEnter = sinon.spy anchor, 'testBeforeEnter'
        spyTestEnter = sinon.spy anchor, 'testEnter'
        spyTestAfterEnter = sinon.spy anchor, 'testAfterEnter'
        spyTestBeforeExit = sinon.spy anchor, 'testBeforeExit'
        spyTestExit = sinon.spy anchor, 'testExit'
        spyTestAfterExit = sinon.spy anchor, 'testAfterExit'
        stateMachine = RC::StateMachine.new 'default', {}
        state = RC::State.new 'newTransition', anchor, stateMachine,
          beforeEnter: 'testBeforeEnter'
          afterEnter: 'testAfterEnter'
          exit: 'testExit'
        yield state.doBeforeEnter()
        yield state.doEnter()
        yield state.doAfterEnter()
        yield state.doBeforeExit()
        yield state.doExit()
        yield state.doAfterExit()
        assert spyTestBeforeEnter.called, '"beforeEnter" method not called'
        assert.isFalse spyTestEnter.called, '"enter" method called'
        assert spyTestAfterEnter.called, '"afterEnter" method not called'
        assert.isFalse spyTestBeforeExit.called, '"beforeExit" method called'
        assert spyTestExit.called, '"exit" method not called'
        assert.isFalse spyTestAfterExit.called, '"afterExit" method called'
        yield return
