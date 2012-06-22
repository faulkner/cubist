express = require 'express'
assets = require 'connect-assets'

app = express()
app.use assets src: __dirname
app.use express.static __dirname + '/'
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'

# FIXME: pretty sure this is not the best way to import node modules
app.get '/n/*', (req, resp) -> resp.sendfile __dirname + '/node_modules/' + req.params[0]
app.get '/', (req, resp) -> resp.render 'index'

port = process.env.PORT or 3000
app.listen port, -> console.log 'Running at http://0.0.0.0:' + port