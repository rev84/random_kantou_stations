window.stations = []
window.timer = false

$().ready ->
  init()



init = ->
  # ツイートボタン
  $('#tweet').on 'click', ->
    tweetButton()
  new Audio('./sound/button55.wav')
  new Audio('./sound/decision24.wav')
  refresh()
  $('#start').on 'click', start
  $('#width, #height').on 'change', refresh
  $('#show_num').on 'click', showNum
  # サイドバー出し入れボタン
  $('#side_bar_button').on 'click', switchSideBar

refresh = ->
  x = Number $('#width').val()
  y = Number $('#height').val()

  window.stations = []
  for xIndex in [0...x]
    window.stations[xIndex] = []
    for yIndex in [0...y]
      window.stations[xIndex][yIndex] = []

  for s in STATIONS
    xIndex = if Math.floor((s.x)*x) is x then x-1 else Math.floor((s.x)*x)
    yIndex = if Math.floor((s.y)*y) is y then y-1 else Math.floor((s.y)*y)
    window.stations[xIndex][yIndex].push s.name


  $('#field').html('')
  table = $('<table>').addClass('board')
  for yIndex in [0...y]
    tr = $('<tr>')
    for xIndex in [0...x]
      tr.append(
        $('<td>').addClass('normal').css({
          width  : ''+(100/x)+'%'
          height : ''+(100/y)+'%'
        }).attr('id', 'x'+xIndex+'y'+yIndex)
      )
    table.append tr
  $('#field').append table

showNum = ->
  $('#field td').html('').removeClass('picked')
  for x in [0...stations.length]
    for y in [0...stations[x].length]
      $('#x'+x+'y'+y).html(stations[x][y].length)

start = ->
  ms = Number $('#ms').val()
  window.timer = setInterval(randomPick, ms)
  $('#start').html('ストップ')
  $('#start').off 'click'
  $('#start').on 'click', stop

stop = ->
  unless window.timer is false
    if $('#se').prop('checked')
      audio = new Audio('./sound/decision24.wav')
      audio.volume = 0.5
      audio.play()
    clearInterval window.timer
    window.timer = false
    $('#start').html('スタート')
    $('#start').off 'click'
    $('#start').on 'click', start

randomPick = ->
  $('#field td').html('').removeClass('picked')
  index = Utl.rand(0, STATIONS.length-1)

  one = getOne index
  $('#x'+one.x+'y'+one.y).addClass('picked').append(
    $('<a>').attr({
      href: 'https://www.google.co.jp/search?q='+one.name+'駅'
      target:'_blank'
    }).html(one.name)
  )
  if $('#se').prop('checked')
    audio = new Audio('./sound/button55.wav')
    audio.volume = 0.5
    audio.play()

getOne = (index)->
  total = 0
  for x in [0...window.stations.length]
    for y in [0...window.stations[x].length]
      if index < total+window.stations[x][y].length
        return {
          name:window.stations[x][y][index-total]
          x:x
          y:y
        }
      total += window.stations[x][y].length

switchSideBar = ->
  if $('#side_bar').css('display') is 'none'
    $('#side_bar').css('display', 'inline')
    $('#side_bar_button span').removeClass('glyphicon-fullscreen').addClass('glyphicon-remove-circle')
  else
    $('#side_bar').css('display', 'none')
    $('#side_bar_button span').removeClass('glyphicon-remove-circle').addClass('glyphicon-fullscreen')

tweetButton = ()->
  url   = location.href
  title = document.title
  target = 'https://twitter.com/share?text='+encodeURIComponent(title)+'&url='+encodeURIComponent(url)
  window.open(target, 'tweetwindow', 'width=650, height=470, personalbar=0, toolbar=0, scrollbars=1, sizable=1')
  false
