@flash = (msg, type='error') ->
  # TODO: jadify!
  $('.container-fluid:first').prepend('<div class="alert alert-'+type+' fade in out">
      <button type="button" class="close" data-dismiss="alert">×</button>
      '+msg+'
    </div>')

  # auto-remove non-errors
  if type='info'
    window.setTimeout () ->
      $('.alert-info').alert('close')
    , 4000

# pulled from Cubism demo.  Tweaked to make horrible assumptions about there being a global @context.
@random = (name) ->
  value = 0
  values = []
  i = 0
  last = undefined
  @context.metric ((start, stop, step, callback) ->
    start = +start
    stop = +stop

    last = start if isNaN last
    while last < stop
      last += step
      value = Math.max(-10, Math.min(10, value + .8 * Math.random() - .4 + .2 * Math.cos(i += .2)))
      values.push value
    callback null, values = values.slice((start - stop) / step)
  ), name