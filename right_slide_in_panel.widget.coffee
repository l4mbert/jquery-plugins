(($) ->

  $.widget 'primate.right_slide_in_panel', {

    options:
      js_enabled_class: ''
      action_link_id: 'siste_nytt_link'
      action_link_markup: ''
      action_link_after: ''
      content_to_clear_way: ''
      width: '300'
      duration: 500

    # PROPERTIES
    open: false
    $content: ''
    $slide_in_content: ''
    $slide_out_the_way_content: ''
    $location_placeholder: $('<span id="content_location_placeholder" style="display: none;"></span>')


    _init: () ->

      that = this
      options = that.options
      this.$content = $content = $(that.element)

      # JS enabled
      $content.addClass options.js_enabled_class
      $content.css 'width', options.width

      # Add the action link - which triggers content show/hide
      this._addActionLink()

      # Prime all elements which will move left to accomodate content sliding in.
      # This works by asigning a 'left' value to a positioned element.
      # If an element is already setup to be positioned, don't change that as it may affect styles.
      this.$slide_out_the_way_content = $slide_out_the_way_content = $(options.content_to_clear_way)
      $slide_out_the_way_content.each ->
        $this = $(this)
        position = $this.css('position')
        if (position != 'fixed') and (position != 'absolute')
          $this.css
            position: 'relative'

      # The content must be positioned absolute to the body, so we make the content the last child of body
      # unless it isn't already so.
      # This is in order to position it offscren using absolute positioning rather than fixed.
      $content.after this.$location_placeholder
      $('body').append $content
      $content.css
        display: 'none'
        position: 'absolute'
        top: 0
        right: "-#{options.width}"
        bottom: 0



    _destroy: () ->

      console.log 'destroy'

      that = this
      options = that.options
      $content = $(that.element)

      $content.removeClass options.js_enabled_class

      this._removeActionLink()

      console.log this.$slide_out_the_way_content
      this.$slide_out_the_way_content.each ->
        the_element = $(this)[0]
        position = $(this).css('position')
        if (position != 'fixed') and (position != 'absolute')
          if the_element.style.removeProperty
            the_element.style.removeProperty('position');
          else
            the_element.style.removeAttribute('position');

      # Return content to original position and reset CSS
      this.$location_placeholder.before $content
      $content.css
        display: 'block'
        position: 'static'
        top: 'auto'
        right: 'auto'
        bottom: 'auto'
        width: 'auto'
      this.$location_placeholder.remove()


    _setOptions: (name, value) ->
      # The next line calls the base widget's _setOption method. This will set the value of the option and is useful for supporting a disabled state.
      $.Widget.prototype._setOption.apply(this, arguments);

    _addActionLink: () ->

      that = this
      options = this.options

      $link = $(options.action_link_markup)
      $link.attr 'id', options.action_link_id

      $link.click (event) ->
        event.preventDefault()
        that._toggle()

      $(options.action_link_after).after $link

    _removeActionLink: () ->

      $("##{this.options.action_link_id}").remove()

    _toggle: () ->

      this._toggleContent()
      this._toggleOtherContent()
      this.open = !this.open

    _toggleContent: () ->

      that = this

      css =
        right: 0
        height: $(document).height() #

      if this.open
        css.right = "-#{this.options.width}"
        this.$content.animate css, this.options.speed, ->
          that.$content.css 'display', 'none'
      else
        this.$content.css 'display', 'block'
        this.$content.animate css, this.options.speed

    _toggleOtherContent: () ->

      that = this

      this.$slide_out_the_way_content.each ->

        $this = $(this)
        current_left_value = that._getCssLeftValueAsInt $this

        css =
          left: "#{(current_left_value - that.options.width)}px"

        css.left = "#{(parseInt(current_left_value) + parseInt(that.options.width))}px" if that.open


        $this.animate css, that.options.speed

    _getCssLeftValueAsInt: ($element) ->

      left_value = $element.css 'left'
      last_two_characters = left_value.substring (left_value.length - 2), (left_value.length)

      if left_value == 'auto'
        return 0
      else if last_two_characters == 'px'
        return parseInt(left_value.replace('px', ''))


  }

)(jQuery)
