{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  StringT, NumberT, FunctionT
  FuncG
  Utils: { _ }
} = RC::

describe 'FuncG', ->
  ArgsTypes = [StringT, NumberT]
  ReturnType = StringT
  TomatoFunc = FuncG ArgsTypes, ReturnType
  CucumberFunc = FuncG [], String
  AnyFunc = FuncG()
  name = "(StringT, NumberT) => StringT"
  f = (a, b)-> a + String b
  fn = TomatoFunc f
  incorrectFn = TomatoFunc (a, b)-> [a]
  anyArgsFn = CucumberFunc -> 'result'
  incorrectAnyArgsFn = CucumberFunc -> 4
  describe 'create new Functor type', ->
    it 'check `of` of functor', ->
      assert _.isFunction(TomatoFunc.of), '`of` must be a function'
    it 'check name of functor', ->
      expect TomatoFunc.name
      .to.equal name
    it 'check displayName of functor', ->
      expect TomatoFunc.displayName
      .to.equal name
    it 'check instrumentation of fn', ->
      expect fn.instrumentation
      .to.deep.equal {domain: ArgsTypes, codomain: ReturnType, f}
    it 'check meta of functor', ->
      expect TomatoFunc.meta
      .to.deep.equal {
        kind: 'func'
        domain: [StringT, NumberT]
        codomain: StringT
        name: name
        identity: yes
      }
  describe 'main exeptions', ->
    it 'throw when call new', ->
      expect ->
        new TomatoFunc
      .to.throw TypeError
    it 'throw when argument String', ->
      expect ->
        TomatoFunc 'String'
      .to.throw TypeError
    it 'throw when argument Number', ->
      expect ->
        TomatoFunc 1
      .to.throw TypeError
    it 'throw when argument Boolean', ->
      expect ->
        TomatoFunc yes
      .to.throw TypeError
    it 'throw when argument Date', ->
      expect ->
        TomatoFunc new Date
      .to.throw TypeError
    it 'throw when argument Symbol', ->
      expect ->
        TomatoFunc Symbol 's'
      .to.throw TypeError
    it 'throw when argument Array', ->
      expect ->
        TomatoFunc []
      .to.throw TypeError
    it 'throw when argument Object', ->
      expect ->
        TomatoFunc {}
      .to.throw TypeError
  describe 'check some function', ->
    it 'check correct function call', ->
      expect fn 'str', 1
      .to.equal 'str1'
      expect fn 'str', 3.5
      .to.equal 'str3.5'
      expect fn 'str', 0
      .to.equal 'str0'
      expect fn 'str', 1999999999
      .to.equal 'str1999999999'
      expect fn 'str', -0.000009856
      .to.equal 'str-0.000009856'
  describe 'check any arguments function', ->
    it 'check correct function call', ->
      expect anyArgsFn()
      .to.equal 'result'
      expect anyArgsFn(1)
      .to.equal 'result'
      expect anyArgsFn('1', Infinity, yes, new Date)
      .to.equal 'result'
  describe 'check any function', ->
    it 'check functor eq FunctionT', ->
      expect AnyFunc
      .to.equal FunctionT
  describe 'throw checking', ->
    it 'throw when one argument', ->
      expect ->
        fn 'str'
      .to.throw TypeError
    it 'throw when first argument number', ->
      expect ->
        fn 1, 1
      .to.throw TypeError
    it 'throw when second argument NaN', ->
      expect ->
        fn 'str', NaN
      .to.throw TypeError
    it 'throw when second argument Infinity', ->
      expect ->
        fn 'str', Infinity
      .to.throw TypeError
    it 'throw when incorrect return type', ->
      expect ->
        incorrectFn 'str', 1
      .to.throw TypeError
    it 'throw when any args fn incorrect return type', ->
      expect ->
        incorrectAnyArgsFn()
      .to.throw TypeError
