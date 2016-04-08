selectCategory = do ->

    currentCategory = ''
    currentCategoryIndex = null

    (event) ->

        event.preventDefault()

        clickedAnchor = $ this
        categoryIndex = el.categoryAnchors.index clickedAnchor

        if currentCategory == ''
            el.selector.addClass 'selected'
        else
            console.log el.categoryAnchors
            el.categoryAnchors.eq(currentCategoryIndex).removeClass 'selected'

        clickedAnchor.addClass 'selected'
        currentCategory = clickedAnchor.attr 'href'
        currentCategoryIndex = categoryIndex

        switchToCategory currentCategory

switchToCategory = (category) ->

    el.mainLoader.delay(800).fadeIn()
    console.log category
