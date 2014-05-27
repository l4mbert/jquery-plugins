###
Faux select - Wrap <select> elements in markup, which allows you to create styled select lists.
Version: 1.0.0
###
(($) ->

  $.widget 'l4mbert.faux_select', {

    options:
      faux_element_class: 'faux_select'
      fixed_width: false

    _init: () ->

      that = this
      options = that.options
      $select = $(that.element)

      element_orig_width = $select.css('width')
      element_orig_value = $select.find('option:selected').text()

      # Elements
      $wrapper = $('<div class="faux_select"></div>')
      $wrapper.css('width', element_orig_width) if options.fixed_width
      button_markup = '<span class="button">&nbsp;</span>'
      text_markup = '<span class="text">'+element_orig_value+'</span>'

      #  Build faux select
      $select.wrap($wrapper)
      $select.before(text_markup)
      $select.before(button_markup)

      if($select.hasClass('inline'))
        $select.parent('.faux_select').addClass('inline')

      # EVENT
      $select.on 'change', (e) ->
        $option = $select.find('option:selected')
        $select.siblings('.text').html($option.html())

    _setOptions: (name, value) ->
      # The next line calls the base widget's _setOption method. This will set the value of the option and is useful for supporting a disabled state.
      $.Widget.prototype._setOption.apply(this, arguments);

  }

)(jQuery)
