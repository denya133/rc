http = require 'http'
URL = require 'url'

AWAILIABLE_PATHS = [
  '/'
  '/test'
  '/redirect'
]

exports.server = http.createServer (req, res) ->
  res.setHeader 'Content-Type', req.headers['accept'] ? 'text/plain'
  url = URL.parse req.url
  if url.pathname in AWAILIABLE_PATHS
    if url.pathname is '/redirect'
      res.statusCode = 302
      res.statusMessage = 'Found'
      res.setHeader 'Location', '/'
    else
      res.statusCode = if req.method is 'DELETE' then 202 else 200
      res.statusMessage = if req.method is 'DELETE' then 'No Content' else 'OK'
  else
    res.statusCode = 404
    res.statusMessage = 'Not Found'
  switch req.method
    when 'GET', 'POST', 'PUT', 'PATCH'
      if 200 <= res.statusCode < 300
        response = JSON.stringify message: 'OK'
    when 'OPTIONS'
      res.setHeader 'Allow', 'HEAD, OPTIONS, GET, POST, PUT, PATCH, DELETE'
  res.end response
  return

exports.listen = (args...) ->
  @server.listen args...
  return

exports.close = (callback) ->
  @server.close callback
