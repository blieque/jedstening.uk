titleClick = (event) ->

    event.preventDefault()

    el.body.animate
        scrollTop: 0
    , 1000
    el.body.addClass 'no-scroll'
    $('.selected').removeClass 'selected'

    currentCategoryName = ''
    currentCategory = undefined
    changeWindowAddress()

    setTimeout ->
        $('.open').trigger 'click', true
        el.previews.remove()
        el.body.removeClass 'no-scroll'
    , 1000