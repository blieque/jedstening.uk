baseUrl = location.origin + location.pathname.replace /[a-z0-9-]*$/, ''

slugify = (name) ->

    # This function is intended to almost implement the behaviour of the Jekyll
    # method `Utils#slugify'. It differs from the Jekyll-flavoured Liquid filter
    # in that it removes apostrophes and dots before really slugifying:
    #
    #   Liquid filter: "Didn't Work" -> "didn-t-work"
    #   This function: "Didn't Work" -> "didnt-work"

    # convert to lowercase
    name = do name.toLowerCase
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

findProject = (slug) ->

    property = 'slug'
    if typeof slug == 'number'
        property = 'id'

    index = undefined

    siteData.projects.some (project, loopIndex) ->
        if project[property] == slug
            index = loopIndex
            return true

    index

openFromUrlWhenReady = do ->

    # This function will only perform its task the second time it is called. The
    # function requires two different async tasks to be complete in order to
    # work.

    calledBefore = false
    ->
        if calledBefore
            do openFromUrl
        calledBefore = true

openFromUrl = ->

    # url will not end in a slash, unless no project is specified in it
    path = location.pathname.split '/'
    slug = path[path.length - 1]

    if slug != ''

        index = findProject slug

        if index == undefined and !isNaN slugInt = parseInt slug
            index = findProject slugInt

        if index != undefined
            el.previews.eq index
                .trigger 'click', [0]

changeWindowAddress = ->

    newHref = baseUrl + projectData.slug
    if newHref != location.href
        history.replaceState {}, '', baseUrl + projectData.slug
