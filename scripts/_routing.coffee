slugify = (name) ->

    # This function is intended to almost implement the behaviour of the Jekyll
    # method `Utils#slugify'. It differs from the Jekyll-flavoured Liquid filter
    # in that it removes apostrophes and dots before really slugifying:
    #
    #   Liquid filter: "Didn't Work" -> "didn-t-work"
    #   This function: "Didn't Work" -> "didnt-work"

    # convert to lowercase
    name = name.toLowerCase()
    # remove characters that shouldn't create a hyphen at the next step
    name = name.replace /[.']/g, ''
    # replace sequences of non-alphanumeric characters with a hyphen
    name = name.replace /[\W_]+/g, '-'
    # remove leading and trailing hyphens left over
    name = name.replace /^-|-$/g, ''

slugifyTitles = ->

    previousSlugs = []

    siteData.projects.forEach (project) ->

        newSlug = slugify project.title
        previousSlugs.push newSlug

        # account for duplicate slugs
        slugCount = previousSlugs.reduce (count, slug) ->
            # add `true' (1) for each occurence in the array
            count + (slug == newSlug)
        , 0
        if slugCount > 1
            newSlug += '-' + slugCount

        project.slug = newSlug

findProject = (categoryName, slug) ->
    # accepts (string categoryName, string slug) or (number projectId)

    category = undefined
    indexInCategory = undefined

    idLookup = typeof categoryName == 'number'

    if idLookup
        siteData.projects.some (project, projectIndex) ->
            if project.id == categoryName # categoryName is actually the id
                category = project.category
                indexInCategory = byCategory[project.category].indexOf project
                true # stop the loop
    else
        if slug in categoryNames
            category = categoryNames.indexOf slug
        else
            el.categoryAnchors.each (anchorIndex, anchor) ->
                if $(anchor).attr('href') == categoryName
                    category = anchorIndex
            byCategory[category].some (project, projectIndex) ->
                if project.slug == slug
                    indexInCategory = projectIndex
                    true # stop the loop

    {category, indexInCategory}

openFromUrl = ->

    # url will not end in a slash, unless no project is specified in it
    path = location.pathname.split '/'
    categoryName = path[path.length - 2]
    slug = path[path.length - 1]

    project = undefined
    # the url contains two parts (i.e., category and project slug)
    if categoryName in categoryNames
        project = findProject categoryName, slug
    # no slug was given, but an id was
    else if !isNaN(slugInt = parseInt slug)
        project = findProject slugInt
    # only category provided
    else if slug in categoryNames
        el.categoryAnchors.eq(categoryNames.indexOf slug)
            .trigger 'click', instant: true

    if project != undefined
        onceCategoryIsSet = ->
            if project.indexInCategory != undefined
                el.previews.eq(project.indexInCategory)
                    .trigger 'click', instant: true

        if currentCategory != project.category
            el.categoryAnchors.eq(project.category)
                .trigger 'click', instant: true
            setTimeout onceCategoryIsSet, 0
        else
            onceCategoryIsSet()

changeWindowAddress = do ->

    firstCall = true

    (ref) ->

        # coffeescript canne destruct undefined variables
        if ref == undefined then ref = {}
        {preventHistoryPush} = ref

        projectId = parseInt $('.open').attr 'data-project-id'
        newHref = siteData.hrefPrefix + '/'
        title = ''
        if currentCategoryName != ''
            newHref += currentCategoryName
            if galleryIsOpen
                newHref += '/' + projectData.slug
                projectData = getProjectData projectId
                title += projectData.title + ' \u2013 '
            title += currentCategoryName[0].toUpperCase() +
                currentCategoryName.slice(1) + ' \u2013 '
        title += siteData.title

        if firstCall
            firstCall = false
            history.replaceState {currentCategory, projectId}, title, newHref
        else if newHref != location.pathname and not preventHistoryPush
            history.pushState
                category: currentCategory
                id: projectId
            , title, newHref

handleHistory = (event) ->

    # the event is inside another event or some shit, becuase javascript
    {category, id} = event.originalEvent.state

    # if we were in a category in this history state
    argObject = preventHistoryPush: true
    if category != undefined
        if isNaN id
            $('.open').trigger 'click', argObject
            el.categoryAnchors.eq(category).trigger 'click', argObject
        else
            # overwrite category just to be sure
            {category, indexInCategory} = findProject id
            el.categoryAnchors.eq(category).trigger 'click', argObject
            el.previews.eq(indexInCategory).trigger 'click', argObject
    else
        el.title.trigger 'click', argObject