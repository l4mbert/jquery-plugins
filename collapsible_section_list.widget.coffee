###
Version: 1.0.0
###
(($) ->

  $.widget 'l4mbert.collapsible_section_list', {

    options:
      js_enabled_class: 'collapsible_enabled'
      element_selector: 'li'
      first_open: false
      accordion: true
      action_elements: ''
      hidden_part_selector: ''
      animate: true
      animation_speed: 300

    currently_open: false

    _init: () ->

      that = this
      options = that.options
      $list = $(that.element)

      collapsible_settings =
        action_elements: options.action_elements
        animate: options.animate
        animation_speed: options.animation_speed
        hidden_part_selector: options.hidden_part_selector

      $list.addClass(options.js_enabled_class)

      # Accordion
      if options.accordion
        collapsible_settings.open_callback = () ->
          $list.children( options.element_selector ).each () ->
            $(this).collapsible_section('close')

      # First remains open
      unless options.first_open

        $list.children( options.element_selector ).collapsible_section collapsible_settings

      else

        # Initialise the first as collapsible but open
        first_collapsible_settings =
          init_collapse: false
        $.extend first_collapsible_settings, collapsible_settings

        $currently_open = $list.children( options.element_selector ).first()
        that.currently_open = $currently_open
        $currently_open.collapsible_section first_collapsible_settings

        # Initialise the others as collapsible but closed
        $list.children( options.element_selector ).slice(1).collapsible_section collapsible_settings

    _destroy: () ->

      that = this
      options = that.options
      $list = $(that.element)

      $list.removeClass(options.js_enabled_class)

      # Inform each collapsible section to destroy the widget attached to it
      $list.children( options.element_selector ).collapsible_section 'destroy'

      # Remove any classes which might have been applied
      classes_remove = ""
      $list.removeClass classes_remove

    _setOptions: (name, value) ->
      # The next line calls the base widget's _setOption method. This will set the value of the option and is useful for supporting a disabled state.
      $.Widget.prototype._setOption.apply(this, arguments);

  }

)(jQuery)
