{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  Generic
} = RC::

describe 'Generic', ->
  describe 'create new generic', ->
    TomatoG = Generic 'TomatoG', (Type)-> Type
    it 'check generated type', ->
      expect TomatoG(RC::StringT)
      .to.equal RC::StringT
    it 'check name of new generic', ->
      expect TomatoG.name
      .to.equal 'TomatoG'
    it 'check displayName of new generic', ->
      expect TomatoG.displayName
      .to.equal 'TomatoG'
    it 'check meta of new generic', ->
      expect TomatoG.meta
      .to.deep.equal {
        kind: 'generic'
        name: 'TomatoG'
        identity: yes
      }
    it 'check meta of Generic', ->
      expect Generic.meta
      .to.deep.equal {
        kind: 'generic'
        name: 'Generic'
        identity: yes
      }
