categoriseProjects = ->

    siteData.projects.forEach (project) ->

        if typeof byCategory[project.category] == 'undefined'
            byCategory[project.category] = []

        byCategory[project.category].push project

categoryAnchorClick = (event, fadeTime) ->

    event.preventDefault()

    clickedAnchor = $ this
    categoryName = clickedAnchor.attr 'href'
    category = el.categoryAnchors.index clickedAnchor
    currentCategory

    if currentCategoryName == ''
        el.selector.addClass 'selected'
        el.body.addClass 'no-scroll' # prevents ugly scroll-bars appearing
        setTimeout ->
            el.body.removeClass 'no-scroll'
        , 1000
    else
        el.categoryAnchors.eq(currentCategory).removeClass 'selected'
    clickedAnchor.addClass 'selected'

    if categoryName != currentCategoryName
        switchToCategory category, categoryName, fadeTime

    currentCategoryName = categoryName
    currentCategory = category

addNewPreviews = (category, categoryName) ->

    byCategory[category].forEach (project) ->

        newPreview = el.templatePreview.clone true

        paddedId = if project.id < 10 then '0' else ''
        paddedId += project.id
        imgSrc = siteData.hrefPrefix + '/images/preview/' + paddedId + '.jpg'
        $.ajax
            url: imgSrc

            success: ->
                newPreview.children('img').attr 'src', imgSrc
                newPreview.children('.loader').remove()

        newPreview.attr
            id: 'project-' + project.id
            href: siteData.hrefPrefix + '/' + categoryName + '/' + project.slug

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

    defaultfadeTime = 600

    (fn, count, fadeTime, data) ->

        transitionTotalTime = defaultfadeTime
        if typeof fadeTime == 'number'
            transitionTotalTime = fadeTime
        fadeTime = transitionTotalTime / 2

        if count > 0

            # call the function for the first time before any delay
            i = 0
            fn i, fadeTime, data

            # iterate through the remaining previews and get rid of them
            if count > 1
                intervalfadeTime = fadeTime / (count - 1)
                intervalId = setInterval ->
                    i++
                    fn i, fadeTime, data
                    if i > count - 2 then clearInterval intervalId
                , intervalfadeTime
                return transitionTotalTime
            else
                return fadeTime

switchToCategory = (category, categoryName, fadeTime) ->

    # close the gallery before anything
    $('.open').click()

    # fade the current previews out and remove them from the dom, one by one
    delay = intervalPreviewAction removePreview, el.previews.length, fadeTime,
        previewCount: el.previews.length
    # add the new previews, keeping them invisible
    addNewPreviews(category, categoryName)
    # fade-in the new previews, one by one
    setTimeout ->
        # replace previews jquery object to hold the new previews
        el.previews = $ el.previews.selector
        delay = intervalPreviewAction showPreview, el.previews.length, fadeTime
        changeWindowAddress()
    , delay
