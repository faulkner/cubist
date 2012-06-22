# yes, this is a horrible, horrible hack because I was feeling lazy
class @Store
  constructor: (@_name, defaults={}) ->
    $.extend true, @, defaults, store.get(@_name)
  save: () ->
    data = _.clone @
    delete data.save
    delete data._name
    store.set @_name, data

# sane defaults
@config = new Store 'config',
  chart:
    size: 600
    step: 1e4
    height: 100
    colors: ["#08519c","#3182bd","#6baed6","#bdd7e7","#bae4b3","#74c476","#31a354","#006d2c"]
    extent: null
  cube:
    dsn: 'http://localhost:1081'
  graphite:
    dsn: 'http://localhost:8083'
  expressions:
    cube: ['max(collectd(load.shortterm))']
    graphite: ['carbon.agents.*.avgUpdateTime']
  charts: []

@context = cubism.context()
  .serverDelay(0)
  .clientDelay(0)
  .step(config.chart.step)
  .size(config.chart.size)

@add_chart = (chart, name='#charts') ->
  if chart.type == 'random'
    data = random 'random source #'+Math.floor(Math.random()*10000)
  else
    data = context[chart.type](chart.dsn).metric chart.expression
  container_id = _.uniqueId 'el'
  container = $($('#chart').html())
    .attr('id', container_id)
    .data('chart', config.charts.length-1)
  $(name).append(container)

  d3.select('#' + container_id).call (div) ->
    div.select('.axis').call(context.axis().orient("top"))
    div.datum(data)
    div.select('.horizon')
      .call(context.horizon()
        .height(config.chart.height)
        .extent(config.chart.extent)
        .colors(config.chart.colors))
    div.select('.rule').call(context.rule())

  # BREAK YOSELF
  $('.title', container).prepend('<div>')

$('.create-chart').on 'click', (e) ->
  form = $(e.target).parents('form')
  [type, exp] = [form.data('context'), $('.expression', form).val()]
  if !exp
    flash 'you need to enter a valid expression first'

  # store the expression for typeahead
  if config.expressions[type].indexOf(exp) == -1
    config.expressions[type].push(exp)

  chart =
    expression: exp
    type: type
    dsn: config[type].dsn # TODO: allow this to be set by user

  config.charts.push chart
  config.save()
  add_chart chart

$('.close-btn').live 'click', (e) ->
  # TODO: if no other charts are using this data source then it should stop polling for data
  chart = $(e.target).parents('.chart')
  config.charts.splice chart.data('idx'), 1
  config.save()
  chart.remove()

d3.select('#create-random').on 'click', () ->
  chart = type: 'random'
  config.charts.push chart
  config.save()
  add_chart chart

$('#cube_expression').typeahead source: config.expressions.cube
$('#graphite_expression').typeahead source: config.expressions.graphite

add_chart c for c in config.charts

context.on "focus", (i, e) ->
  d3.selectAll(".value").style "right", (if not i? then null else context.size() - i + "px")
