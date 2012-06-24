# Cubist

Cubist is a Cubism graphing sandbox.

Enter Cube or Graphite expressions, get charts.

Charts are chucked in local storage for later use.

## Features

- server preferences and past expressions saved to local storage
- comparison charts can be created by dragging one chart onto another ([screenshot](http://faulkner.io/t/screen2012-06-24at2.17.18AM.png))

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
- UI for removing old expressions
- change typeahead into an autocomplete based on functions and metrics available
