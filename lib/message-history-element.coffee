csound = require 'csound-api'
d3 = require 'd3'

class MessageHistoryElement extends HTMLElement
  initialize: (messageManager, @editor) ->
    messageManager.onDidReceiveMessage (message) => @handleMessage(message)
    messageManager.onGraphCreationRequest (request) => @handleGraphCreationRequest(request)

  getTitle: ->
    @editor.getTitle() + ' Csound output'

  handleGraphCreationRequest: ({name, data}) ->
    margin = {top: 20, right: 20, bottom: 30, left: 50}
    width = 650 - margin.left - margin.right
    height = 340 - margin.top - margin.bottom

    x = d3.scale.linear()
        .domain([0, data.fdata.length - 1])
        .range([0, width])

    y = d3.scale.linear()
        .domain([d3.min(data.fdata), d3.max(data.fdata)])
        .range([height, 0])

    xAxis = d3.svg.axis()
        .scale(x)
        .orient('bottom')

    yAxis = d3.svg.axis()
        .scale(y)
        .orient('left')

    line = d3.svg.line()
        .x((d) -> return x(d.index))
        .y((d) -> return y(d.value))

    svgElement = document.createElement 'svg'
    svg = d3.select(svgElement)
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
      .append('g')
        .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    svg.append('g')
        .attr('class', 'x axis')
        .attr('transform', 'translate(0,' + height + ')')
        .call(xAxis)

    svg.append('g')
        .attr('class', 'y axis')
        .call(yAxis)

    svg.append('path')
        .datum(data.fdata.map (value, index) -> {index: index, value: value})
        .attr('class', 'line')
        .attr('d', line)

    @appendChild(document.createElement 'div').innerHTML = svgElement.outerHTML

  handleMessage: ({string, attributes}) ->
    if @lastChild?.localName isnt 'pre'
      @messageContainer = @appendChild document.createElement 'pre'

    needsScroll = (@scrollTop >= @scrollHeight - @clientHeight)

    messageType = attributes & csound.CSOUNDMSG_TYPE_MASK
    if messageType is csound.CSOUNDMSG_DEFAULT
      span = @messageContainer.appendChild document.createElement 'span'
      switch attributes & csound.CSOUNDMSG_FG_COLOR_MASK
        when csound.CSOUNDMSG_FG_BLACK
          span.classList.add 'csound-message-foreground-black'
        when csound.CSOUNDMSG_FG_RED
          span.classList.add 'csound-message-foreground-red'
        when csound.CSOUNDMSG_FG_GREEN
          span.classList.add 'csound-message-foreground-green'
        when csound.CSOUNDMSG_FG_YELLOW
          span.classList.add 'csound-message-foreground-yellow'
        when csound.CSOUNDMSG_FG_BLUE
          span.classList.add 'csound-message-foreground-blue'
        when csound.CSOUNDMSG_FG_MAGENTA
          span.classList.add 'csound-message-foreground-magenta'
        when csound.CSOUNDMSG_FG_CYAN
          span.classList.add 'csound-message-foreground-cyan'
        when csound.CSOUNDMSG_FG_WHITE
          span.classList.add 'csound-message-foreground-white'
      if attributes & csound.CSOUNDMSG_FG_BOLD
        span.classList.add 'highlight'
      if attributes & csound.CSOUNDMSG_FG_UNDERLINE
        span.classList.add 'csound-message-underline'
      switch attributes & csound.CSOUNDMSG_BG_COLOR_MASK
        when csound.CSOUNDMSG_BG_BLACK
          span.classList.add 'csound-message-background-black'
        when csound.CSOUNDMSG_BG_RED
          span.classList.add 'csound-message-background-red'
        when csound.CSOUNDMSG_BG_GREEN
          span.classList.add 'csound-message-background-green'
        when csound.CSOUNDMSG_BG_ORANGE
          span.classList.add 'csound-message-background-yellow'
        when csound.CSOUNDMSG_BG_BLUE
          span.classList.add 'csound-message-background-blue'
        when csound.CSOUNDMSG_BG_MAGENTA
          span.classList.add 'csound-message-background-magenta'
        when csound.CSOUNDMSG_BG_CYAN
          span.classList.add 'csound-message-background-cyan'
        when csound.CSOUNDMSG_BG_GREY
          span.classList.add 'csound-message-background-white'
    else
      className= 'highlight-'
      switch messageType
        when csound.CSOUNDMSG_ERROR
          className += 'error'
        when csound.CSOUNDMSG_ORCH or csound.CSOUNDMSG_REALTIME
          className += 'info'
        when csound.CSOUNDMSG_WARNING
          className += 'warning'
      span = @messageContainer.lastChild
      unless span?.classList.contains className
        span = @messageContainer.appendChild document.createElement 'span'
        span.classList.add className
    span.appendChild document.createTextNode string

    if needsScroll
      @scrollTop = @scrollHeight - @clientHeight

module.exports = MessageHistoryElement = document.registerElement 'csound-message-history', prototype: MessageHistoryElement.prototype
