titleClick = (event) ->

    event.preventDefault()

    el.body.animate
        scrollTop: 0
    , 400
    el.body.addClass 'no-scroll'
    $('.selected').removeClass 'selected'

    currentCategoryName = ''
    currentCategory = undefined
    changeWindowAddress()

    setTimeout ->
        $('.open').trigger 'click', true
        # $('.open').removeClass 'open'
        # if galleryIsOpen
        #     toggleGallery true
        el.previews.remove()
        el.body.removeClass 'no-scroll'
    , 1000