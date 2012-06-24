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

# chart data sources
@chart_data = []

@context = cubism.context()
  .serverDelay(0)
  .clientDelay(0)
  .step(config.chart.step)
  .size(config.chart.size)

chart_container = (charts, template, name='#charts') ->
  data_id = (chart_data.push charts) - 1
  container_id = _.uniqueId 'el'
  container = $($(template).html())
    .attr('id', container_id)
    .data('chart', config.charts.length-1)
    .data('data', data_id)
  $(name).append(container)
  container

@add_chart = (chart, name='#charts') ->
  if chart.type == 'random'
    data = random 'random source #'+Math.floor(Math.random()*10000)
  else
    data = context[chart.type](chart.dsn).metric chart.expression

  container = chart_container data, '#chart'

  d3.select('#' + container.attr('id')).call (div) ->
    div.select('.axis').call(context.axis().orient("top"))
    div.select('.horizon')
      .datum(data)
      .call(context.horizon()
        .height(config.chart.height)
        .extent(config.chart.extent)
        .colors(config.chart.colors))

  container.draggable revert: true
  container.droppable
    drop: (event, ui) ->
      flash '<strong>Boom!</strong>  A comparison chart is born.', 'info'
      primary = chart_data[$(@).data('data')]
      secondary = chart_data[$(ui.draggable).data('data')]
      add_comparison_chart primary, secondary

@add_comparison_chart = (primary, secondary, name='#charts') ->
  container = chart_container [primary, secondary], '#comp_chart'

  d3.select('#' + container.attr('id')).call (div) ->
    div.select('.axis').call(context.axis().orient("top"))
    div.select('.comparison')
      .datum([primary, secondary])
      .call(context.comparison()
        .height(config.chart.height))

$('.create-chart').on 'click', (e) ->
  form = $(e.target).parents('form')
  [type, exp] = [form.data('context'), $('.expression', form).val()]
  if !exp
    flash 'you need to enter a valid expression first'

  # store the expression for typeahead
  if config.expressions[type].indexOf(exp) == -1
    config.expressions[type].push(exp)

  dsn = config[type].dsn = $('.dsn', form).val()
  chart =
    expression: exp
    type: type
    dsn: dsn

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

init_form = (name) ->
  $("##{name}_expression").typeahead source: config.expressions[name]
  $("##{name}_dsn").val config[name].dsn

init_form form for form in ['cube', 'graphite']

add_chart c for c in config.charts
