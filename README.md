# jQuery plugins

As used by L4mbert at [Primate](http://primate.co.uk).

### Version numbers

Quite often as you move from one website build to the next, the plugin may change.  Please update the version number (within the plugin file), and make a note of the change made on this README.

Version numbers are based on the formula 'X.Y.Z':

X: Major change<br/>
Y: Added new functionality<br/>
Z: Bug fix

Increment each number by 1 for each update.

## faux_select.widget.coffee

Converts `<select>` elements to faux select markup, and then updates the original `<select>` based on a click event added to the faux slect.

### Versions

1.0.0 - Original version taken from changemyname.to project.

## collapsible_section.widget.coffee

## collapsible_section_list.widget.coffee

## checkbox_list_to_select.widget.coffee

Converts a list of checkboxes into a `<select>` element, and then hides the checkboxes.  Whenever an option is selected from the `<select>`, the corresponding checkbox is checked, and a new `<select>` element is added after the previous one to allow for new selections.  After selection, a 'remove' link is added next to the `<select>`.  Clicking the 'remove' link will uncheck the corresponding checkbox.

### Versions

1.0.0 - Original version taken from changemyname.to project.

## google_map.widget.coffee

## radio_displayed_content.widget.coffee

## right_slide_in_panel.widget.coffee

Sidebar which slides in from the right of the page, content hidden offscreen.  Currently in development.