  # move this to somewhere else
  $.fn.animateSortable = (options) ->
    list = @
    if options.items?
      items = @find(options.items)
    else
      items = @children()
    options = options || {}
    start = options.start
    stop = options.stop
    change = options.change
    options.items = '.sortable-item-helper'

    options.start = (e, ui) =>
      item = ui.helper
      item.addClass 'exclude-item'
      list.addClass 'show-clones'
      item.data('clone').hide()
      start(e, ui) if typeof start is "function"

    options.stop = (e, ui) =>
      items.filter('.exclude-item').each ->
        item = $(@)
        clone = item.data 'clone'
        position = item.position()
        clone.css
          'left': position.left,
          'top': position.top
        clone.show()
        item.removeClass 'exclude-item'
      list.removeClass 'show-clones'
      stop(e, ui) if typeof stop is "function"

    options.change = (e, ui) =>
      asdf = []
      items.each ->
        item = $(@)
        asdf.push item.children('div').children('span').text()
      items.each ->
        item = $(@)
        clone = item.data 'clone'
        position = item.position()
        clone.css
          'top': position.top,
          'left': position.left
        change(e, ui) if typeof change is "function"

    @css
      position: 'relative'

    items.each (i) ->
      item = $(@)
      clone = item.clone()
      item.addClass 'sortable-item-helper'
      item.data 'clone', clone
      position = item.position()
      clone.addClass('sortable-item-clone').css
        'left': position.left,
        'top': position.top,
        'position': 'absolute',
        'width': item.outerWidth(),
        'height': item.outerHeight()
      .attr "data-pos", i+1
      item.after clone

    clones = @children('.sortable-item-clone')

    @sortable options