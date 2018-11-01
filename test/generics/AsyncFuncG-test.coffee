{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  StringT, NumberT, FunctionT
  AsyncFuncG
  Utils: { _, co }
} = RC::

describe 'AsyncFuncG', ->
  ArgsTypes = [StringT, NumberT]
  ReturnType = StringT
  TomatoFunc = AsyncFuncG ArgsTypes, ReturnType
  CucumberFunc = AsyncFuncG [], String
  name = "async (StringT, NumberT) => StringT"
  f = co.wrap (a, b)-> yield return a + String b
  fn = TomatoFunc f
  incorrectFn = TomatoFunc co.wrap (a, b)-> yield return [a]
  anyArgsFn = CucumberFunc co.wrap -> yield return 'result'
  incorrectAnyArgsFn = CucumberFunc co.wrap -> yield return 4
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
        kind: 'async'
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
      co ->
        assert.equal (yield fn 'str', 1), 'str1'
        assert.equal (yield fn 'str', 3.5), 'str3.5'
        assert.equal (yield fn 'str', 0), 'str0'
        assert.equal (yield fn 'str', 1999999999), 'str1999999999'
        assert.equal (yield fn 'str', -0.000009856), 'str-0.000009856'
  describe 'check any arguments function', ->
    it 'check correct function call', ->
      co ->
        assert.equal (yield anyArgsFn()), 'result'
        assert.equal (yield anyArgsFn 1), 'result'
        assert.equal (yield anyArgsFn '1', Infinity, yes, new Date), 'result'
  describe 'throw checking', ->
    it 'throw when one argument', ->
      co ->
        try
          yield fn 'str'
          throw new Error
        catch err
          if err instanceof TypeError
            return
          else
            throw err
    it 'throw when first argument number', ->
      co ->
        try
          yield fn 1, 1
          throw new Error
        catch err
          if err instanceof TypeError
            return
          else
            throw err
    it 'throw when second argument NaN', ->
      co ->
        try
          yield fn 'str', NaN
          throw new Error
        catch err
          if err instanceof TypeError
            return
          else
            throw err
    it 'throw when second argument Infinity', ->
      co ->
        try
          yield fn 'str', Infinity
          throw new Error
        catch err
          if err instanceof TypeError
            return
          else
            throw err
    it 'throw when incorrect return type', ->
      co ->
        try
          yield incorrectFn 'str', 1
          throw new Error
        catch err
          if err instanceof TypeError
            return
          else
            throw err
    it 'throw when any args fn incorrect return type', ->
      co ->
        try
          yield incorrectAnyArgsFn()
          throw new Error
        catch err
          if err instanceof TypeError
            return
          else
            throw err
