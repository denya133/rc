Core  = require './Core'
CoreObjectInterface = require './interfaces/coreObject'
ChainsMixin = require './mixins/chainsMixin'
DelayMixin = require './mixins/delayMixin'
PubSubMixin = require './mixins/pubSubMixin'

class CoreObject extends Core
  cpmFunctor = Symbol 'functor'

  @implements CoreObjectInterface
  @include ChainsMixin
  @include DelayMixin
  @include PubSubMixin

  @super: (methodName)->
    if arguments.length is 0
      return @__super__?.constructor
    (Class, args...)=>
      if arguments.length is 1
        [args] = arguments
        Class = args.callee?.class ? @
      else
        unless _.isFunction Class
          throw new Error 'First argument must be <Class> or arguments'
      method = Class.__super__?.constructor[methodName]
      method?.apply @, args

  super: (methodName)->
    if arguments.length is 0
      return @constructor.__super__
    (Class, args...)=>
      if arguments.length is 1
        [args] = arguments
        Class = args.callee?.class ? @constructor
      else
        unless _.isFunction Class
          throw new Error 'First argument must be <Class> or arguments'
      method = Class.__super__?[methodName]
      method?.apply @, args

  @new: (args...)->
    new @ args...

  @defineProperty: (name, definition)->
  @defineClassProperty: (name, definition)->

  # @defineGetter: (aName, aDefault, aGetter)->
  # @defineSetter: (Class, aName, aSetter)->
  @defineAccessor: (Class, aName, aDefault, aGetter, aSetter)->
  # @defineClassGetter: (aName, aDefault, aGetter)->
  # @defineClassSetter: (Class, aName, aSetter)->
  @defineClassAccessor: (Class, aName, aDefault, aGetter, aSetter)->

  @[cpmFunctor] = (lambda)->
    if arguments.length is 0
      throw new Error 'lambda argument is required'
    lambda.class = @
    (context, methodName)->
      context[methodName] = lambda

  @method: (lambda)->
    if arguments.length is 0
      throw new Error 'lambda argument is required'
    lambda.class = @
    lambda

  @instanceMethod: (methodName, lambda)->
    @[cpmFunctor](lambda) @::, methodName

  @classMethod: (methodName, lambda)->
    @[cpmFunctor](lambda) @, methodName


module.exports = CoreObject.initialize()

###
class Test extends CoreObject
  cpmNew = @public @static new:
    (String, Object)-> Object # !!!!!!!!!!! Так не будет работать
  , (methodName)-> #some code
  cpmCreate = @public @static @virtual create: ->
  ipnTestIt = @private testIt: Number,
    default: 9
    get: (v)-> v
    set: (v)->
      @send 'testItChanged', v
      v + 98
  ipmTesting = @public testing:
    (String, Object, UsersController, Boolean, String, Function)-> User
  , (methodName, config, users, isInternal, path, lambda)-> #some code
  ipmModel = @private Model:
    (ANY)-> CLASS
  , Basis::Users
###
