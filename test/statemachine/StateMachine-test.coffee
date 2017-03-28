{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co } = RC::Utils

describe 'StateMachine', ->
  describe '.new()', ->
    it 'should create new StateMachine instance', ->
      expect ->
        stateMachine = RC::StateMachine.new()
        assert.instanceOf stateMachine, RC::StateMachine, 'Cannot instantiate class StateMachine'
      .to.not.throw Error
  describe '#doBeforeAllEvents,
            #doAfterAllEvents,
            #doAfterAllTransitions,
            #doAfterAllErrors', ->
    it 'should run all regitstered hooks', ->
      anchor =
        testBeforeAllEvents: ->
        testAfterAllEvents: ->
        testAfterAllTransitions: ->
        testAfterAllErrors: ->
      spyTestBeforeAllEvents = sinon.spy anchor, 'testBeforeAllEvents'
      spyTestAfterAllEvents = sinon.spy anchor, 'testAfterAllEvents'
      spyTestAfterAllTransitions = sinon.spy anchor, 'testAfterAllTransitions'
      spyAfterAllErrors = sinon.spy anchor, 'testAfterAllErrors'
      stateMachine = RC::StateMachine.new 'testSM', anchor,
        beforeAllEvents: 'testBeforeAllEvents'
        afterAllEvents: 'testAfterAllEvents'
        afterAllTransitions: 'testAfterAllTransitions'
        afterAllErrors: 'testAfterAllErrors'
      co ->
        try
          yield stateMachine.doBeforeAllEvents()
          yield stateMachine.doAfterAllEvents()
          yield stateMachine.doAfterAllTransitions()
          throw new Error 'test'
        catch error
          yield stateMachine.doAfterAllErrors()
      .then ->
        assert.isTrue spyTestBeforeAllEvents.called, '"beforeAllEvents" method not called'
        assert.isTrue spyTestAfterAllEvents.called, '"afterAllEvents" method not called'
        assert.isTrue spyTestAfterAllTransitions.called, '"afterAllTransitions" method not called'
        assert.isTrue spyAfterAllErrors.called, '"afterAllErrors" method not called'
  describe '#registerState, #removeState', ->
    it 'should register and remove state from SM', ->
      expect ->
        anchor = {}
        stateMachine = RC::StateMachine.new 'testSM', anchor
        stateMachine.registerState 'test'
        assert.instanceOf stateMachine.states['test'], RC::State, 'State did not registered'
        stateMachine.removeState 'test'
        assert.notInstanceOf stateMachine.states['test'], RC::State, 'State did not removed'
      .to.not.throw Error
  describe '#transitionTo, #send', ->
    it 'should intialize SM and make one transition', ->
      co ->
        anchor = {}
        stateMachine = RC::StateMachine.new 'testSM', anchor
        stateMachine.registerState 'test1', { initial: yes }
        stateMachine.registerState 'test2'
        stateMachine.registerEvent 'testEvent', 'test1', 'test2'
        yield stateMachine.reset()
        assert.equal stateMachine.currentState.name, 'test1', 'SM did not initialized'
        yield stateMachine.send 'testEvent'
        assert.equal stateMachine.currentState.name, 'test2', 'State did not changed'
