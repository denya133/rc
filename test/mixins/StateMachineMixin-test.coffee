{ expect, assert } = require 'chai'
_ = require 'lodash'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co } = RC::Utils

describe 'StateMachineMixin', ->
  describe 'include StateMachineMixin', ->
    it 'should create new class with state machine and instantiate', ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()
        class MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
          @module Test
        MyClass.initialize()
        myInstance = MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
  describe 'include and initialize StateMachineMixin', ->
    it 'should create new class with state machine and initialize default state machine', ->
      spySMConfig = sinon.spy ->
      expect ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()
        class MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
          @module Test
          @StateMachine 'default', spySMConfig
        MyClass.initialize()
        myInstance = MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
        assert.isTrue spySMConfig.called, 'Initializer did not called'
      .to.not.throw Error
  describe 'test hooks in StateMachineMixin', ->
    it 'should initialize and call hooks', ->
      co ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()
        class MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
          @module Test
          testValue: 'test'
          testBeforeAllEvents: sinon.spy ->
          testEventBefore: sinon.spy ->
          testTransitionGuard: sinon.spy -> @testValue is 'test'
          testOldStateBeforeExit: sinon.spy ->
          testAfterAllTransitions: sinon.spy ->
          testTransitionAfter: sinon.spy ->
          testNewStateBeforeEnter: sinon.spy ->
          testOldStateAfterExit: sinon.spy ->
          testNewStateAfterEnter: sinon.spy ->
          testEventAfter: sinon.spy ->
          testAfterAllEvents: sinon.spy ->
          testEventError: sinon.spy ->
          testErrorOnAllEvents: sinon.spy ->
          @StateMachine 'default', ->
            @beforeAllEvents 'testBeforeAllEvents'
            @afterAllTransitions 'testAfterAllTransitions'
            @afterAllEvents 'testAfterAllEvents'
            @errorOnAllEvents 'testErrorOnAllEvents'
            @state 'oldState',
              initial: yes
              beforeExit: 'testOldStateBeforeExit'
              afterExit: 'testOldStateAfterExit'
            @state 'newState',
              beforeEnter: 'testNewStateBeforeEnter'
              afterEnter: 'testNewStateAfterEnter'
            @event 'testEvent',
              before: 'testEventBefore'
              after: 'testEventAfter'
              error: 'testEventError'
             , =>
                @transition ['oldState'], 'newState',
                  guard: 'testTransitionGuard'
                  after: 'testTransitionAfter'
        MyClass.initialize()
        myInstance = MyClass.new()
        yield myInstance.resetDefault()
        yield myInstance.testEvent()
        assert.instanceOf myInstance.getStateMachine('default'), RC::StateMachine, 'Cannot create state machine'
        assert.isTrue myInstance.testBeforeAllEvents.called, 'testBeforeAllEvents did not called'
        assert.isTrue myInstance.testEventBefore.called, 'testEventBefore did not called'
        assert.isTrue myInstance.testTransitionGuard.called, 'testTransitionGuard did not called'
        assert.isTrue myInstance.testOldStateBeforeExit.called, 'testOldStateBeforeExit did not called'
        assert.isTrue myInstance.testAfterAllTransitions.called, 'testAfterAllTransitions did not called'
        assert.isTrue myInstance.testTransitionAfter.called, 'testTransitionAfter did not called'
        assert.isTrue myInstance.testNewStateBeforeEnter.called, 'testNewStateBeforeEnter did not called'
        assert.isTrue myInstance.testOldStateAfterExit.called, 'testOldStateAfterExit did not called'
        assert.isTrue myInstance.testNewStateAfterEnter.called, 'testNewStateAfterEnter did not called'
        assert.isTrue myInstance.testEventAfter.called, 'testEventAfter did not called'
        assert.isTrue myInstance.testAfterAllEvents.called, 'testAfterAllEvents did not called'
        assert.isFalse myInstance.testEventError.called, 'testEventError called'
        assert.isFalse myInstance.testErrorOnAllEvents.called, 'testErrorOnAllEvents called'
  describe 'test emitter in StateMachineMixin', ->
    it 'should initialize and call emitter hook', ->
      co ->
        testEmit = sinon.spy ->
        class Test extends RC::Module
          @inheritProtected()
        Test.initialize()
        class MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
          @module Test
          testValue: 'test'
          testEventBefore: sinon.spy ->
          testTransitionGuard: sinon.spy -> @testValue is 'test'
          testTransitionAfter: sinon.spy ->
          testNewStateBeforeEnter: 'TestNotification'
          testOldStateAfterExit: sinon.spy ->
          testErrorOnAllEvents: sinon.spy ->
          @public emit: Function,
            default: testEmit
          @StateMachine 'default', ->
            errorOnAllEvents: 'testErrorOnAllEvents'
            @state 'oldState',
              initial: yes
              afterExit: 'testOldStateAfterExit'
            @state 'newState',
              beforeEnter: 'testNewStateBeforeEnter'
            @event 'testEvent',
              before: 'testEventBefore'
             , =>
                @transition ['oldState'], 'newState',
                  guard: 'testTransitionGuard'
                  after: 'testTransitionAfter'
        MyClass.initialize()
        myInstance = MyClass.new()
        yield myInstance.resetDefault()
        yield myInstance.testEvent 'testArgument1', 'testArgument2'
        assert.instanceOf myInstance.getStateMachine('default'), RC::StateMachine, 'Cannot create state machine'
        assert.isTrue myInstance.testEventBefore.called, 'testEventBefore did not called'
        assert.isTrue myInstance.testTransitionGuard.called, 'testTransitionGuard did not called'
        assert.isTrue myInstance.testTransitionAfter.calledWith('testArgument1', 'testArgument2'), 'testTransitionAfter did not called'
        assert.isTrue testEmit.calledWith('TestNotification'), '"emit" not called with "TestNotification"'
        assert.isTrue myInstance.testOldStateAfterExit.called, 'testOldStateAfterExit did not called'
        assert.isFalse myInstance.testErrorOnAllEvents.called, 'testErrorOnAllEvents called'
