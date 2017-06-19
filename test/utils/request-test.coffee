{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co, request } = RC::Utils

server = require '../lib/server'

describe 'Utils.request', ->
  before ->
    server.listen 8000
  after ->
    server.close()
  describe 'request("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request 'GET', 'http://localhost:8000'
        assert.equal result.body, '{"message":"OK"}', 'No body received'
        assert.equal result.status, 200, 'Status differs from 302'
        yield return
  describe 'request("http://localhost:8000")', ->
    it 'should send request and receive JSON result', ->
      co ->
        result = yield request 'GET', 'http://localhost:8000', json: yes
        assert.deepEqual result.body, {"message":"OK"}, 'No body received'
        assert.equal result.status, 200, 'Status differs from 200'
        yield return
    return
  describe 'request("http://localhost:8001")', ->
    @timeout 5000
    it 'should send request and handle connection error', ->
      co ->
        result = yield request 'GET', 'http://localhost:8001'
        assert.equal result.status, 500, 'Error response status is not valid'
        yield return
  describe 'request("http://localhost:8000/mmm")', ->
    it 'should send request and handle HTTP error', ->
      co ->
        result = yield request 'GET', 'http://localhost:8000/mmm'
        assert.lengthOf result.body, 0, 'No body received'
        assert.equal result.status, 404, 'Status differs from 404'
        yield return
  describe 'request("http://localhost:8000/redirect")', ->
    it 'should send request and handle HTTP redirect', ->
      co ->
        result = yield request 'GET', 'http://localhost:8000/redirect'
        assert.lengthOf result.body, 0, 'No body received'
        assert.equal result.status, 302, 'Status differs from 302'
        yield return
  describe 'request.head("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request.head 'http://localhost:8000'
        assert.lengthOf result.body, 0, 'Unexpected body received'
        assert.equal result.status, 200, 'Status differs from 200'
        yield return
  describe 'request.options("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request.options 'http://localhost:8000'
        assert.lengthOf result.body, 0, 'Unexpected body received'
        assert.equal result.status, 200, 'Status differs from 200'
        yield return
  describe 'request.get("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request.get 'http://localhost:8000'
        assert.equal result.body, '{"message":"OK"}', 'No body received'
        assert.equal result.status, 200, 'Status differs from 200'
        yield return
  describe 'request.post("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request.post 'http://localhost:8000'
        assert.equal result.body, '{"message":"OK"}', 'No body received'
        assert.equal result.status, 200, 'Status differs from 200'
        yield return
  describe 'request.put("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request.put 'http://localhost:8000'
        assert.equal result.body, '{"message":"OK"}', 'No body received'
        assert.equal result.status, 200, 'Status differs from 200'
        yield return
  describe 'request.patch("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request.patch 'http://localhost:8000'
        assert.equal result.body, '{"message":"OK"}', 'No body received'
        assert.equal result.status, 200, 'Status differs from 200'
        yield return
  describe 'request.delete("http://localhost:8000")', ->
    it 'should send request and receive result', ->
      co ->
        result = yield request.delete 'http://localhost:8000'
        assert.lengthOf result.body, 0, 'Unexpected body received'
        assert.equal result.status, 202, 'Status differs from 202'
        yield return
