
# stylesheets
require './css/App.styl'

# dependencies
require 'lemonjs-lui/Footer'
require 'lemonjs-lui/Grid'
require 'lemonjs-lui/Header'
require 'lemonjs-lui/Input'

# load icon names
icons = require 'lemonjs-i8u/map.json'

# ccomponent
module.exports = lemon.Component {
  package: 'site'
  name: 'App'
  id: 'app'

  data: {
    icons: icons
    query: ''
  }

  lifecycle: {
    mounted: ->
      @loadImages()
  }

  methods: {
    loadImages: ->
      icons = @el.querySelectorAll 'img.icon'
      observer = lozad(icons)
      observer.observe()

    onSearch: (e) ->
      clearInterval @timeout_id if @timeout_id
      @timeout_id = setTimeout ( =>
        @query = @$search.value
        @loadImages()
      ), 400
  }

  template: (data) ->

    lui.Header {
      logo: 'lemon + icons8 (ultraviolet)'
      nav: [
        {href: 'https://github.com/lemon/i8u.lemonjs.org', text: 'website'}
        {href: 'https://github.com/lemon/lemonjs-i8u', text: 'library'}
      ]
    }

    div '.search', ->
      lui.Input {
        ref: '$search'
        label: 'search for an icon'
        onKeyUp: 'onSearch'
      }

    div '.icons', ->
      div _on: 'query', _template: (query, data) ->
        items = ({
          icon: ->
            img '.icon', 'data-src': "/img/#{this.code}.png"
          code: code
          name: name
        } for code, name of data.icons when name.toLowerCase().indexOf(query) > -1)
        if items.length is 0
          div '.no-match', ->
            'No icons matching your search'
        else
          lui.Grid {
            items: items
          }

    lui.Footer {}, ->
      div ->
        'Released under the MIT License'
      div ->
        '© Copyright 2018 Shenzhen239'

    script type: 'text/javascript', src: '/lazy-load-images.js'
}
