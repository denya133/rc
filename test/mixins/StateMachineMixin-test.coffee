{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'StateMachineMixin', ->
  describe 'include StateMachineMixin', ->
    it 'should create new class with state machine and instantiate', ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
  describe 'include and initialize StateMachineMixin', ->
    it 'should create new class with state machine and initialize default state machine', ->
      spySMConfig = sinon.spy ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
          @StateMachine 'default', spySMConfig
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
        assert.isTrue spySMConfig.called, 'Initializer did not called'
      .to.not.throw Error
  describe 'test hooks in StateMachineMixin', ->
    it 'should initialize and call hooks', ->
      expect ->
        class Test
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::StateMachineMixin
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
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        # yield myInstance.testEvent() #TODO Add asserts for test hooks
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
