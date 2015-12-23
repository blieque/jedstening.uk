# event handlers

previewClick = (event) ->

    do event.preventDefault

    elPreview = $ this
    projectIsOpen = elPreview.hasClass 'open'

    # remove the 'open' class from the last clicked preview
    $ '.open'
        .removeClass 'open'
        .addClass 'delay-transition'

    # because jquery's .delay() is bork
    setTimeout ->
        $ '.delay-transition'
            .removeClass 'delay-transition'
    , 600

    # user has clicked the preview for a project that is not already open
    if !projectIsOpen

        # change appearance of and locate clicked preview
        elPreview.addClass 'open'
        projectIndex = el.previews.index elPreview
        positionGalleryElement projectIndex

        # change images and text of the project
        changeGalleryProject projectIndex

    do toggleGallery

    if !projectIsOpen
        do scrollToGallery

thumbnailClick = (event) ->

    do event.preventDefault

    elThumbnail = $ this
    imageIsCurrent = elThumbnail.hasClass 'current'
    imageIndex = el.nav.children().index elThumbnail

    slideToImage imageIndex

imgNavClick = ->

    elPreview = $ this
    difference = null
    if elPreview.is '.l'
        difference = -1
    else
        difference = 1

    slideToImageRelative difference

# procedures

getColumns = ->

    columnsString = el.cssToJs.css 'z-index'
    columnsInt = parseInt columnsString
    if !isNaN(columnsInt) and # if there's a change, and it's valid
       columnsInt > 0 and
       columnsInt < 5 and
       columnsInt != columns
        columns = columnsInt
        do positionGalleryElement
        if galleryIsOpen
            do scrollToGallery

updateGalleryHeight = ->

    galleryHeight = do el.gallery.height

scrollToGallery = ->

    # scroll to the gallery
    gapAboveGallery = (el.window.height() - galleryHeight) / 2
    gapAboveGallery = Math.max 0, gapAboveGallery
    $ 'body,html'
        .animate
            scrollTop: el.gallery.offset().top - gapAboveGallery
        , 400

positionGalleryElement = (projectIndex) ->

    if projectIndex == undefined or projectIndex == null
        projectIndex = el.previews.index $ '.open'

    # move the gallery into place in the dom
    if projectIndex >= 0
        lastOnRow = projectIndex + columns
        lastOnRow -= lastOnRow % columns
        lastOnRow = Math.min lastOnRow, el.previews.length
        el.gallery.insertAfter el.previews[lastOnRow - 1]

changeGalleryProject = (projectIndex) ->

    currentProjectIndex = projectIndex
    projectId = projectIndex + 1

    # find the selected project's data object
    if siteData.projects[projectIndex].id == projectId
        projectData = siteData.projects[projectIndex]
    else
        siteData.projects.forEach (project) ->
            if project.id == projectId
                projectData = project

    # remove/add image and thumbnail elements as needed
    requiredChange = projectData.galleryCount - el.conveyor.children().length
    removeOrAdd = null

    if requiredChange > 0
        removeOrAdd = ->
            el.templateImage.clone().appendTo el.conveyor
            el.templateThumbnail.clone(true).appendTo el.nav
    else if requiredChange < 0
        removeOrAdd = ->
            el.conveyor.children().last().remove()
            el.nav.children().last().remove()

    for i in [0...Math.abs requiredChange]
        do removeOrAdd

    # change element attributes (href, src) for the new project
    for i in [0...projectData.galleryCount]

        # function to return interpolated urls with scheme, domain, etc.
        imageUrl = (parts) ->
            # zero-pad numbers
            parts[1] = "00#{parts[1]}".slice -2
            parts[2] = "00#{parts[2]}".slice -2

            if parts[0] == ''
                # return anchor href if no image category is given
                "#{siteData.hrefPrefix}/#{parts[1]}.#{parts[2]}"
            else
                # return normal interpolated string
                "#{siteData.hrefPrefix}/images/#{parts[0]}/" +
                "#{parts[1]}.#{parts[2]}.png"

        # actually change the src and href attributes
        el.conveyor.children().eq(i)
            .attr 'src', imageUrl ['full', projectData.id, i + 1]
        el.nav.children().eq(i)
            .attr 'href', imageUrl ['', projectData.id, i + 1]
            .children().attr 'src', imageUrl ['thumb', projectData.id, i + 1]

    # change element content for the new project
    el.gallery.find 'h2'
        .text projectData.title

    # remove/add paragraph elements as needed
    requiredChange = projectData.descriptionFull.length -
                     el.article.children('p').length
    removeOrAdd = null

    if requiredChange > 0
        removeOrAdd = ->
            el.article.append document.createElement 'p'
    else if requiredChange < 0
        removeOrAdd = ->
            el.article.children('p').last().remove()

    for i in [0...Math.abs requiredChange]
        do removeOrAdd

    for i in [0...projectData.descriptionFull.length]
        el.article.children('p').eq(i).text projectData.descriptionFull[i]

    # scroll back to the first image unless we're reopening the same project
    if projectId != lastOpenedProject
        slideToImage 0

    lastOpenedProject = projectId

toggleGallery = (time) ->

    elPreviewOpen = $ '.open'
    galleryIsOpening = elPreviewOpen.length > 0

    if time == undefined or time == null
        time = 400

    if galleryIsOpening
        # open the gallery
        el.gallery.slideDown time, ->
            el.gallery.removeClass 'transition'
    else
        # update gallery height variable
        do updateGalleryHeight

        # close the gallery
        el.gallery.addClass 'transition'
        setTimeout ->
            el.gallery.slideUp time
        , 200

    galleryIsOpen = !galleryIsOpen

slideToImage = (imageIndex) ->

    galleryMaxIndex = projectData.galleryCount - 1

    # if we need to instead move to another project
    if imageIndex < 0 or
       imageIndex > galleryMaxIndex

        direction = if imageIndex < 0 then -1 else 1
        targetProject = currentProjectIndex + direction
        if targetProject >= 0 and
           targetProject < siteData.projects.length
            el.previews.eq targetProject
                .trigger 'click'

        return # great flow, bro

    # sanitise things a little
    imageIndex = Math.max imageIndex, 0
    imageIndex = Math.min imageIndex, galleryMaxIndex

    # place the 'current' class on the right thumbnail
    $ '.current'
        .removeClass 'current'
    el.nav
        .children()
        .eq imageIndex
        .addClass 'current'
        .focus()

    # remove old alternate styles
    el.imgNavs
        .removeClass 'proj-nav'
        .removeClass 'unavailable'

    # sliding to first image
    if imageIndex == 0
        el.imgPrev.addClass 'proj-nav'
        # if also the first project
        if currentProjectIndex == 0
            el.imgPrev.addClass 'unavailable'

    # sliding to last image
    if imageIndex == galleryMaxIndex
        el.imgNext.addClass 'proj-nav'
        # if also the last project
        if currentProjectIndex == siteData.projects.length - 1
            el.imgNext.addClass 'unavailable'

    # update gallery properties object
    conveyorProps.rightValRound = conveyorProps.rightVal = imageIndex
    do conveyorProps.update

    # slide the image conveyor into place
    conveyorProps.setCssRightVal imageIndex

slideToImageRelative = (changeInIndex) ->

    elThumbnail = $ '.current'
    currentIndex = el.nav.children().index elThumbnail
    newIndex = currentIndex + changeInIndex

    slideToImage newIndex
