# Cubist

Cubist is a Cubism graphing sandbox.

Enter Cube or Graphite expressions, get charts.

Chart settings are chucked in local storage for later use.

## To install

```bash
$ npm install -g cubist
```

## Usage

```bash
$ cubist
```

Using port 3000 already?  Fine.

```bash
$ export PORT=1234; cubist
```

The defaults assume you're running Cube and/or Graphite locally.
At the moment there aren't forms to edit this, but if you pop open
your console it's just a matter of punching in:

```javascript
config.cube.dsn='http://some.other.server.com:1081'
```


## TODO
- correct any node/JS stupidity (I rarely touch node or frontend code; much to improve)
- use Backbone or other framework to clean up JS
- add support for multiple servers
- live editing for existing charts
- accept chart settings from query params
- kill data polling when charts are removed
- support for comparison charts
- UI bits to set the server defaults
- UI for removing old expressions
- change typeahead into an autocomplete based on functions and metrics available
