###
Version: 1.0.0
###
(($) ->

  $.widget 'l4mbert.radio_displayed_content', {

    options:
      true_checkbox: ''
      false_checkbox: ''
      open_when_true: true

    _init: () ->

      that = this
      options = that.options
      $content_container = $(this.element)

      return if (options.true_checkbox is '') or (options.false_checkbox is '')

      $true_checkbox = $(options.true_checkbox)
      $false_checkbox = $(options.false_checkbox)

      # The content should be hidden unless the appropriate checkbox is elected
      hide_content = false
      hide_content = true if $false_checkbox.is(':checked') and options.open_when_true
      hide_content = true if $true_checkbox.is(':checked') and options.open_when_true isnt true
      $content_container.hide() if hide_content

      if options.open_when_true
        $true_checkbox.click ->
          $content_container.slideDown()
        $false_checkbox.click ->
          $content_container.slideUp()
      else
        $true_checkbox.click ->
          $content_container.slideUp()
        $false_checkbox.click ->
          $content_container.slideDown()


    _destroy: () ->

      that = this
      options = that.options
      $content_container = $(options.content_container)

      $content_container.show()


    _setOptions: (name, value) ->
      # The next line calls the base widget's _setOption method. This will set the value of the option and is useful for supporting a disabled state.
      $.Widget.prototype._setOption.apply(this, arguments);

  }

)(jQuery)
