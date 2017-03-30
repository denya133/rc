{ expect, assert } = require 'chai'
sinon = require 'sinon'
_ = require 'lodash'
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
            #doErrorOnAllEvents', ->
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
        errorOnAllEvents: 'testAfterAllErrors'
      co ->
        try
          yield stateMachine.doBeforeAllEvents()
          yield stateMachine.doAfterAllEvents()
          yield stateMachine.doAfterAllTransitions()
          throw new Error 'test'
        catch error
          yield stateMachine.doErrorOnAllEvents()
      .then ->
        assert.isTrue spyTestBeforeAllEvents.called, '"beforeAllEvents" method not called'
        assert.isTrue spyTestAfterAllEvents.called, '"afterAllEvents" method not called'
        assert.isTrue spyTestAfterAllTransitions.called, '"afterAllTransitions" method not called'
        assert.isTrue spyAfterAllErrors.called, '"errorOnAllEvents" method not called'
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
  describe '#send, #doXXX', ->
    it 'should intialize SM and hooks and make one transition', ->
      co ->
        anchor =
          testValue: 'test'
          testBeforeAllEvents: sinon.spy ->
          testEventBefore: sinon.spy ->
          testEventGuard: sinon.spy -> @testValue is 'test'
          testTransitionGuard: sinon.spy -> @testValue is 'test'
          testOldStateBeforeExit: sinon.spy ->
          testOldStateExit: sinon.spy ->
          testAfterAllTransitions: sinon.spy ->
          testTransitionAfter: sinon.spy ->
          testNewStateBeforeEnter: sinon.spy ->
          testNewStateEnter: sinon.spy ->
          testTransitionSuccess: sinon.spy ->
          testOldStateAfterExit: sinon.spy ->
          testNewStateAfterEnter: sinon.spy ->
          testEventSuccess: sinon.spy ->
          testEventAfter: sinon.spy ->
          testAfterAllEvents: sinon.spy ->
          testEventError: sinon.spy ->
          testErrorOnAllEvents: sinon.spy ->
          testBeforeReset: sinon.spy ->
          testAfterReset: sinon.spy ->
          testwithAnchorUpdateState: sinon.spy ->
          testwithAnchorSave: sinon.spy ->
        oldStateConfig =
          initial: yes
          beforeExit: 'testOldStateBeforeExit'
          exit: 'testOldStateExit'
          afterExit: 'testOldStateAfterExit'
        newStateConfig =
          initial: no
          beforeEnter: 'testNewStateBeforeEnter'
          enter: 'testNewStateEnter'
          afterEnter: 'testNewStateAfterEnter'
        transitionConfig =
          guard: 'testTransitionGuard'
          after: 'testTransitionAfter'
          success: 'testTransitionSuccess'
        eventConfig =
          guard: 'testEventGuard'
          before: 'testEventBefore'
          success: 'testEventSuccess'
          after: 'testEventAfter'
          error: 'testEventError'
        smConfig =
          beforeReset: 'testBeforeReset'
          afterReset: 'testAfterReset'
          beforeAllEvents: 'testBeforeAllEvents'
          afterAllEvents: 'testAfterAllEvents'
          afterAllTransitions: 'testAfterAllTransitions'
          errorOnAllEvents: 'testErrorOnAllEvents'
          withAnchorUpdateState: 'testwithAnchorUpdateState'
          withAnchorSave: 'testwithAnchorSave'
        sm = RC::StateMachine.new 'testStateMachine', anchor, smConfig
        sm.registerState 'oldState', oldStateConfig
        sm.registerState 'newState', newStateConfig
        sm.registerEvent 'testEvent', 'oldState', 'newState', eventConfig, transitionConfig
        yield sm.reset()
        assert.equal sm.currentState.name, 'oldState', 'SM did not initialized'
        yield sm.send 'testEvent', 'testArgument1', 'testArgument2'
        assert.equal sm.currentState.name, 'newState', 'State did not changed'
        for own key, property of anchor when _.isFunction property
          if /error/i.test key
            assert.isFalse property.called, "anchor.#{key} called"
          else
            if /reset|with/i.test key
              assert.isTrue property.called, "anchor.#{key} did not called"
            else
              assert.isTrue property.calledWith('testArgument1', 'testArgument2'), "anchor.#{key} did not called"
