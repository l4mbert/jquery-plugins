###
Version: 1.0.0
###
(($) ->

  $.widget 'l4mbert.checkbox_list_to_select', {

    options:
      js_enabled_class: 'js-enabled'
      checkbox_container_selector: 'checkbox'
      select_checkbox_wrapper_selector: 'checkbox_select'

    checkboxes: new Array()
    active_selects: 0
    $template_select: ''
    $checkbox_select_holder: ''
    $add_button: ''

    _init: () ->

      that = this
      options = that.options
      $container = $(that.element)
      $checkboxes = $(".#{options.checkbox_container_selector}", $container)

      $container.addClass options.js_enabled_class

      # Consolidate checkbox data
      this.checkboxes = new Array()
      $checkboxes.each ->
        $this = $(this)
        that.checkboxes.push
          container: $this
          checkbox: $('input[type=checkbox]', $this)
          label: $('label', $this)

      # Build select statement
      this._buildTemplateSelect()

      # Build and add 'Add company' button to markup
      this._initAddButton()

      # The checkbox select holder will contain any generated select statements
      this.$checkbox_select_holder = $('<div class="checkbox_select_holder"></div>')
      $container.after this.$checkbox_select_holder

      # If there are any previously checked checkboxes, we must init selects for them
      for checkbox_record, index in this.checkboxes
        if checkbox_record.checkbox.is(':checked')
          that._addNewSelect (index)


    #
    # PRIVATE METHODS
    #
    _setOptions: (name, value) ->
      # The next line calls the base widget's _setOption method. This will set the value of the option and is useful for supporting a disabled state.
      $.Widget.prototype._setOption.apply(this, arguments);

    _checkCheckbox: (index) ->
      $checkbox = this.checkboxes[index].checkbox
      $checkbox.prop('checked', true)

    _uncheckCheckbox: (index) ->
      $checkbox = this.checkboxes[index].checkbox
      $checkbox.prop('checked', false)

    _addNewSelect: (active_index) ->

      return if this.active_selects >= this.checkboxes.length

      that = this
      options = this.options
      $clone = this.$template_select.clone()

      if typeof active_index == "undefined" or active_index == null
        active_index = -1

      # Event for option select
      $clone.on 'change', (e) ->
        $selected_option = $clone.find('option:selected')
        index = $selected_option.attr 'value'

        # If the select is changing, the previous index must be re-enabled
        previous_index = $clone.attr('selected_index')
        if previous_index and (previous_index != index)
          that._uncheckCheckbox(previous_index)
          that._addIndexFromSelects(previous_index)

        if index
          $clone.attr('selected_index', index)
          that._checkCheckbox(index)
          that._removeIndexFromSelects(index)

      # If we are creating a select based on an active index, we must select the
      # apropriate option within the clone before passing through faux_select()
      if active_index >= 0
        $("option[value=#{active_index}]", $clone).attr('selected', 'selected')
        this._removeIndexFromSelects active_index

      # Package select (incl faux select)
      $wrap = $("<div class=\"#{options.select_checkbox_wrapper_selector}\"></div>")
      $wrap.append $clone
      $clone.faux_select()

      # Add 'remove select' link
      $remove_select = $('<a class="remove" href="#"><span>Remove option</span></a>')
      $remove_select.click (event) ->
        event.preventDefault()
        that._removeSelect($clone)
      $wrap.append $remove_select

      # Add markup and active selects
      this.$checkbox_select_holder.append $wrap

      # Increment active selects, and disable add button if necessary
      this.active_selects++
      this._disableAddButton() if this.active_selects >= this.checkboxes.length


    _removeSelect: ($select) ->

      options = this.options

      $wrap = $select.closest(".#{options.select_checkbox_wrapper_selector}")
      $selected_option = $select.find('option:selected')
      index = $selected_option.attr 'value'

      if index
        this._uncheckCheckbox(index)
        this._addIndexFromSelects(index)

      $wrap.remove()

      # Reduce number of active selects, and re-activate add button if necessary
      this.active_selects--
      this._enableAddButton() if this.active_selects < this.checkboxes.length


    _removeIndexFromSelects: (index) ->
      $("option[value=#{index}]", this.$template_select).attr('disabled', 'disabled')
      $("option[value=#{index}]", this.$checkbox_select_holder).not("option[value=#{index}]:checked").attr('disabled', 'disabled')

    _addIndexFromSelects: (index) ->
      $("option[value=#{index}]", this.$template_select).removeAttr 'disabled'
      $("option[value=#{index}]", this.checkbox_select_holder).not("option[value=#{index}]:checked").removeAttr 'disabled'

    _buildTemplateSelect: ->

      $select = $('<select class=\"test\"><option>Select</option></select>')
      for checkbox, index in this.checkboxes
        $option = $("<option value=\"#{index}\">#{checkbox.label.text()}</option>")
        $select.append $option

      this.$template_select = $select

    _initAddButton: ->

      that = this
      $container = $(this.element)

      $add_button = $('<a class=\"add_checkbox_select\" href="#"><span>Add a new company</span></a>')
      $add_button.click (event) ->
        event.preventDefault()
        that._addNewSelect()

      $container.after $add_button
      this.$add_button = $add_button

    _disableAddButton: ->
      this.$add_button.addClass 'disabled'

    _enableAddButton: ->
      this.$add_button.removeClass 'disabled'


  }

)(jQuery)
