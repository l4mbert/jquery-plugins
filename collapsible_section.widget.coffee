###
Version: 1.0.0
###
(($) ->

  $.widget 'l4mbert.collapsible_section', {

    options:
      js_enabled_class: 'collapsible_enabled'
      init_collapse: true
      action_elements: ''
      open_class: 'open'
      opening_class: 'opening'
      closed_class: 'closed'
      closing_class: 'closing'
      animate: false
      animation_speed: 500
      hidden_part_selector: null
      add_action_link_after: null
      actions_link_class: 'action_link'
      actions_link_selector: 'action_link'
      options_data_store_identifier: 'collapsibleoptions'
      scroll_to_top: true
      open_callback: $.noop

    _init: () ->

      that = this
      options = that.options
      $section = $(that.element)

      # Add settings to objects jQuery data store, in case it's need for future reference
      $section.data(options.settings_data_store_identifier, options)

      # add enabled class, and others if required
      $section.addClass(options.js_enabled_class)
      if options.init_collapse
        $section.addClass(options.closed_class)
        $(options.hidden_part_selector, $section).hide() if options.hidden_part_selector?

      # Add action links and events - to open or close
      $(options.action_elements, $section).click -> that._toggle(); return false
      if options.add_action_link_after?
        if options.init_collapse
          $action_link = $("<a href='#' class='#{options.actions_link_class}'><span>Open</span></a>")
          $action_link.click -> that._toggle(); return false
        else
          $action_link = $("<a href='#' class='#{options.actions_link_class}'><span>Close</span></a>")
          $action_link.click -> that._toggle(); return false
        $(options.add_action_link_after, $section).after $action_link

    _destroy: () ->

      that = this
      options = that.options
      $section = $(that.element)

      # Display any content areaa which might have been hidden
      $(options.hidden_part_selector, $section).show()

      # Remove action links, or disable click events
      $(options.action_elements, $section).off('click')
      $(options.actions_link_selector, $section).remove if options.add_action_link_after?

      # Remove any calsses that might have been added
      classes_remove = "#{options.js_enabled_class} #{options.closed_class} #{options.open_class}"
      $section.removeClass classes_remove


    _setOptions: (name, value) ->
      # The next line calls the base widget's _setOption method. This will set the value of the option and is useful for supporting a disabled state.
      $.Widget.prototype._setOption.apply(this, arguments);

    #
    # PUBLIC ACCESIBLE FUNCTIONS
    #
    close: ->
      this._close_section()

    #
    # PRIVATE METHODS
    #
    _toggle: () ->

      options = this.options
      $section = $(this.element)

      if $section.hasClass(options.closed_class) then this._open_section() else this._close_section()

    _open_section: () ->

      that = this
      options = this.options
      $section = $(this.element)

      options.open_callback($section)

      if options.animate and options.hidden_part_selector?

        # Add 'opening' class
        $section.addClass options.opening_class
        $(options.hidden_part_selector, $section).slideDown options.animation_speed, ->
          $section.removeClass options.opening_class
          $section.removeClass(options.closed_class).addClass(options.open_class)
          that._scroll_to_top()
      else
        $section.removeClass(options.closed_class).addClass(options.open_class)
        that._scroll_to_top()

    _close_section: () ->
      options = this.options
      $section = $(this.element)

      if options.animate and options.hidden_part_selector?
        $section.addClass options.closing_class
        $(options.hidden_part_selector, $section).slideUp options.animation_speed, ->
          $section.removeClass options.closing_class
          $section.removeClass(options.open_class).addClass(options.closed_class)
      else
        $section.removeClass(options.open_class).addClass(options.closed_class)

    _scroll_to_top: () ->
      options = this.options
      $section = $(this.element)

      # Scroll to top of section
      if options.scroll_to_top
        $('html, body').animate
          scrollTop: ( $section.offset().top - 20 )

  }

)(jQuery)
