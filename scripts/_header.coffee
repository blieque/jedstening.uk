titleClick = (event, ref) ->

    if ref == undefined then ref = {}
    # {preventHistoryPush} = ref # there's not much point destructuring

    event.preventDefault()

    el.body.animate
        scrollTop: 0
    , 1000
    el.body.addClass 'no-scroll'
    $('.selected').removeClass 'selected'

    currentCategoryName = ''
    currentCategory = undefined
    # changeWindowAddress {preventHistoryPush}
    changeWindowAddress ref

    setTimeout ->
        $('.open').trigger 'click',
            instant: true
            preventUrlUpdate: true
        el.previews.remove()
        el.body.removeClass 'no-scroll'
    , 1000