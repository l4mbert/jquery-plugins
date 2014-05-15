$ ->

  $.widget 'l4mbert.google_map', {

    options:
      js_enabled_class: 'js-enabled'
      latitude: 0
      longitude: 0
      zoom_level: 16
      scrollwheel: true
      disable_default_ui: false
      disableDoubleClickZoom: false
      draggable: true
      clickable: true
      marker: false
      marker_img_src: false
      marker_latitude: 0
      marker_longitude: 0

    #
    # PROPERTIES
    #
    map_styles: [
                  {
                    "stylers": [
                      { "saturation": -100 },
                      { "lightness": 50 },
                      { "gamma": 0.7 }
                    ]
                  },{
                    "elementType": "labels.icon",
                    "stylers": [
                      { "visibility": "off" }
                    ]
                  },{
                  }
                ]

    marker_image:
      url: ''
      size: new google.maps.Size(104, 70)
      origin: new google.maps.Point(0, 0)
      anchor: new google.maps.Point(32, 70)

    _init: () ->

      that = this
      options = that.options
      $container = $(that.element)

      mapLatlng = new google.maps.LatLng options.latitude, options.longitude
      mapOptions = {
        mapTypeControlOptions: {
          mapTypeIds: ['Styled']
        },
        mapTypeControl: false,
        center: mapLatlng,
        zoom: options.zoom_level,
        scrollwheel: options.scrollwheel,
        disableDefaultUI: options.disable_default_ui,
        disableDoubleClickZoom: options.disableDoubleClickZoom,
        draggable: options.draggable,
        clickable: options.clickable,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeId: 'Styled'
      };
      map = new google.maps.Map $container.get(0), mapOptions

      styledMapType = new google.maps.StyledMapType(this.map_styles, { name: 'Styled' });
      map.mapTypes.set('Styled', styledMapType);

      google.maps.event.trigger(map, 'resize');

      if options.marker and options.marker_img_src isnt false
        this.marker_image.url = options.marker_img_src
        this._setMarker(map)

    _setOptions: (name, value) ->
      # The next line calls the base widget's _setOption method. This will set the value of the option and is useful for supporting a disabled state.
      $.Widget.prototype._setOption.apply(this, arguments);

    #
    # PRIVATE METHODS
    #
    _setMarker: (map) ->

      options = this.options

      markerLatlng = new google.maps.LatLng options.marker_latitude, options.marker_longitude

      marker = new google.maps.Marker({
        position: markerLatlng,
        map: map,
        icon: this.marker_image
      });

  }

(jQuery)
