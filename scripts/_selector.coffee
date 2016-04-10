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

switchToCategory = do ->

    byCategory = {}

    (category, categoryName) ->

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
