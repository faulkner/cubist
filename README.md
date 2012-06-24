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

## TODO
- correct any node/JS stupidity (I rarely touch node or frontend code; much to improve)
- use Backbone or other framework to clean up JS
- add support for managing lists of servers
- live editing for existing charts
- accept chart settings from query params
- kill data polling when charts are removed
- support for comparison charts
- UI for removing old expressions
- change typeahead into an autocomplete based on functions and metrics available
