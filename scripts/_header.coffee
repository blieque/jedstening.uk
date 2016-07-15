titleClick = (event) ->

    event.preventDefault()

    el.body.addClass 'no-scroll'
    $('.selected').removeClass 'selected'
    toggleGallery true

    currentCategoryName = ''
    currentCategory = undefined
    changeWindowAddress()

    setTimeout ->
        el.previews.remove()
        el.body.removeClass 'no-scroll'
    , 1000