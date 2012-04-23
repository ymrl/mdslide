jQuery ->
  CURRENT = 0
  PREFIX  = (jQuery.browser.webkit && '-webkit-') || (jQuery.browser.mozilla && '-moz-') || (jQuery.browser.msie && '-ms-') || (jQuery.browser.opera && '-o-') || ''
  TRANSFORM = PREFIX + 'transform'
  KEYTARGET = if jQuery.browser.msie then document.body else window
  HASH = null

  keyAction = (e)->
    if([74,76,40,39,32,13].indexOf(e.keyCode) >= 0)
      showSlide ++CURRENT
      location.hash = CURRENT
      e.preventDefault()
    else if([72,75,38,37].indexOf(e.keyCode) >= 0)
      showSlide --CURRENT
      location.hash = CURRENT
      e.preventDefault()


  createOutline = ()->
    div = jQuery('#outline')
    if div.length == 0
      div = jQuery('<div>').attr('id','outline')
      div.appendTo(jQuery(document.body))
    else
      div.empty()
    i = 0
    jQuery('.slide').each ->
      s = jQuery('<div>')
      jQuery(this).children().each ->
        s.append(jQuery(this).clone())
      s.attr('id',"outline/#{i}").appendTo(div)
      i++
    return div

  showOutline = ()->
    jQuery(KEYTARGET).unbind('keyup',keyAction)
    jQuery('#outline').show()
    jQuery('#slides').hide()
    jQuery('#toolbox .forOutline').show()
    jQuery('#toolbox .forSlides').hide()

  hideOutline = ()->
    jQuery(KEYTARGET).unbind('keyup',keyAction)
    jQuery(KEYTARGET).keyup keyAction
    jQuery('#outline').hide()
    jQuery('#slides').show()
    jQuery('#toolbox .forOutline').hide()
    jQuery('#toolbox .forSlides').show()

  showSlide = (num)->
    slides = jQuery('.slide')
    if num >= slides.length
      num = slides.length-1
    else if num < 0
      num = 0
    CURRENT = num
    slides.removeClass('current').eq(num).addClass('current')
    if CURRENT > 0
      jQuery('#toolbox a.prev').attr('href',"##{CURRENT-1}").unbind('click')
    else
      jQuery('#toolbox a.prev').attr('href',"#").click (e)->e.preventDefault()
    if CURRENT <= slides.length - 2
      jQuery('#toolbox a.next').attr('href',"##{CURRENT+1}").unbind('click')
    else
      jQuery('#toolbox a.next').attr('href',"#").click (e)->e.preventDefault()
    jQuery('#toolbox a.toSlide').attr('href',"##{CURRENT}")

  checkURL = (show)->
    slideNum = 0
    if HASH is location.hash
      return null
    else
      HASH = location.hash
    
    outline = false
    if location.hash.match(/#?outline/)
      outline = true
    else if (matched = location.hash.match(/#?(\d+)/))
      num = parseInt(matched[1])
      if CURRENT != num
        slideNum = num
        show = true
    if show
      showSlide(slideNum)

    if outline
      showOutline()
    else
      hideOutline()

  jQuery(window).bind('resize',(e)->
    wdw = jQuery(window)
    h = wdw.outerHeight()
    w = wdw.outerWidth()
    jQuery('.slide').each ()->
      t = jQuery(this)
      t.css
        width : ''
        height: ''
      t.css TRANSFORM,''
      sw = t.width()
      sh = t.height()
      if sh > h
        zoom = h/sh
        t.css 'width', sw / zoom
        t.css TRANSFORM, "scale(#{zoom})"

  ).trigger('resize')

  createOutline()
  checkURL(true)
  setInterval(checkURL,50)
  setTimeout(
    -> jQuery('#toolbox').addClass('shown')
  ,3000)
