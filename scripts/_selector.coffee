selectCategory = do ->

    currentCategoryName = ''
    currentCategory = null

    (event) ->

        event.preventDefault()

        clickedAnchor = $ this
        categoryName = clickedAnchor.attr 'href'
        category = el.categoryAnchors.index clickedAnchor

        if currentCategoryName == ''
            el.selector.addClass 'selected'
        else
            el.categoryAnchors.eq(currentCategory).removeClass 'selected'
        clickedAnchor.addClass 'selected'

        if categoryName != currentCategoryName
            switchToCategory category, categoryName

        currentCategoryName = categoryName
        currentCategory = category

categoriseProjects = (byCategory, category) ->

    if typeof byCategory[category] == 'undefined'
        byCategory[category] = []

        siteData.projects.forEach (project) ->
            if project.category == category
                byCategory[category].push project

addNewPreviews = (category, categoryName) ->

    # categorise the project data before adding them
    byCategory = {}
    categoriseProjects byCategory, category

    byCategory[category].forEach (project) ->

        newPreview = el.templatePreview.clone true

        paddedId = if project.id < 10 then '0' else ''
        paddedId += project.id
        imgSrc = baseUrl + 'images/preview/' + paddedId + '.jpg'
        $.ajax
            url: imgSrc

            success: ->
                newPreview.children('img').attr 'src', imgSrc
                newPreview.children('.loader').remove()

        newPreview.attr
            id: 'project-' + project.id
            href: baseUrl + categoryName + '/' + project.slug

        newPreview.children('img').attr 'alt', project.title
        newPreview.find('h2').text project.title
        newPreview.find('p').text project.basicInfo

        newPreview.appendTo el.section
        newPreview.fadeOut 0

removePreview = (index, fadeTime, {previewCount}) ->
    elementIndex = previewCount - index - 1
    el.previews.eq(elementIndex).fadeOut fadeTime, ->
        $(this).remove()

showPreview = (index, fadeTime) ->
    el.previews.eq(index).fadeIn fadeTime

intervalPreviewAction = do ->

    transitionTotalTime = 600
    fadeTime = 200

    (fn, count, data) ->

        if count > 0

            # call the function the first time before any delay
            i = 0
            fn i, fadeTime, data

            # iterate through the remaining previews and get rid of them
            if count > 1
                intervalTime = (transitionTotalTime - fadeTime) / (count - 1)
                intervalId = setInterval ->
                    i++
                    fn i, fadeTime, data
                    if i > count - 2 then clearInterval intervalId
                , intervalTime
                return transitionTotalTime
            else
                return fadeTime

switchToCategory = (category, categoryName) ->

    # close the gallery before anything
    $('.open').click()

    # fade the current previews out and remove them from the dom, one by one
    delay = intervalPreviewAction removePreview, el.previews.length,
        previewCount: el.previews.length
    # add the new previews, keeping them invisible
    addNewPreviews(category, categoryName)
    # fade-in the new previews, one by one
    setTimeout ->
        # replace previews jquery object to hold the new previews
        el.previews = $ el.previews.selector
        delay = intervalPreviewAction showPreview, el.previews.length
    , delay
