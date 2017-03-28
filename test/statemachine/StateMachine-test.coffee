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
      expect ->
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
      .to.not.throw Error
