---
---

$ ->
  class Ui

  class Ui.Watcher
    constructor: ->
      @init()

    init: =>

      @_watchInputs $('[data-watch="input"]') if $('[data-watch="input"]').length > 0
      @_watchInputs $('[data-watch="textarea"]'), 'textarea' if $('[data-watch="textarea"]').length > 0
      @_calculateFooterHeight()
      @_setTitleImage()
      @_linkfyAnchors()
      @_handleMobileMenu()
      @setScrollToEvents()

    _calculateFooterHeight: ->
      targetHeight = $(window).height() - $('.pageContent').offset().top - $('header').height() - $('footer').height() + 10
      $('.pageContent').css('min-height',targetHeight + "px")

    _setTitleImage: ->
      $div = $('.titleImg')
      src = $div.data('bg-src')
      $div.css 'background-image', "url(#{src})"

    _watchInputs: ($elems, targetType = 'input') ->
      # Initiate: add class to every input that's not empty
      $elems.each ->
        $(this).addClass 'has-content' if $(this).find(targetType).val() != '' || $(this).find(targetType).is(":focus")

      # Handle FOCUS event
      $(targetType,'[data-watch="' + targetType + '"]').on 'focus', ->
        $(this).parent().addClass 'has-focus'

      # Handle BLUR event
      $(targetType,'[data-watch="' + targetType + '"]').on 'blur', ->
        # dynamicly set class 'has-content'
        if $(this).val().trim() != ''
          $(this).parent().addClass 'has-content'
        else
          $(this).parent().removeClass 'has-content'

        # always remove class 'has-focus' when leaving
        $(this).parent().removeClass 'has-focus'

    _handleMobileMenu: ->
      $('.js-mobileMenu').on "click", (e) ->
        e.preventDefault()
        $menu = $('.nav--mobileMenu')
        if $menu.hasClass('is-visible')
          $menu.removeClass('is-visible').velocity "slideUp", {duration: 200}
        else
          $menu.addClass('is-visible').velocity "slideDown", {duration: 200}

    _linkfyAnchors: ->

      anchorForId = (id)->
        anchor = document.createElement('a')
        anchor.className = "headerLink"
        anchor.href = "##{id}"
        anchor.innerHTML = "<i class=\"fa fa-link\"></i>";
        return anchor;

      $headers = $('.pageContent').find('h2,h3')
      $headers.each ->
        if $(this).attr('id') != ''
          $(this).append anchorForId($(this).attr('id'))

    setScrollToEvents: ->

      $('a','#markdown-toc, h2').on 'click', (e) ->
        target = $(this).attr 'href'
        $(target).velocity 'scroll', {duration: 500, offset: -90, easing: "easeInSine"}


  new Ui.Watcher
