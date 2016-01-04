# event handlers

previewClick = (event, toggleTime) ->

    if event.ctrlKey
        return

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

        # change appearance of preview
        elPreview.addClass 'open'

        # locate preview and move gallery into place in the dom
        projectIndex = el.previews.index elPreview
        positionGalleryElement projectIndex

        # change images and text of the project
        changeGalleryProject projectIndex

    # animate the gallery open or closed
    toggleGallery toggleTime

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

    # if there's a change, and it's valid
    if !isNaN(columnsInt) and
       columnsInt > 0 and
       columnsInt < 5 and
       columnsInt != columns
        columns = columnsInt
        do positionGalleryElement
        if galleryIsOpen
            scrollToGallery 0

scrollToGallery = (time) ->

    if time == undefined
        time = 400

    # scroll to the gallery
    gapAboveGallery = (el.window.height() - el.gallery.height()) / 2
    gapAboveGallery = Math.max 0, gapAboveGallery
    el.body.animate
        scrollTop: el.gallery.offset().top - gapAboveGallery
    , time

positionGalleryElement = (projectIndex) ->

    if projectIndex == undefined or projectIndex == null
        projectIndex = el.previews.index $ '.open'

    # move the gallery into place in the dom
    if projectIndex >= 0
        lastOnRow = projectIndex + columns
        lastOnRow -= lastOnRow % columns
        lastOnRow = Math.min lastOnRow, el.previews.length
        el.gallery.insertAfter el.previews[lastOnRow - 1]

getProjectData = (projectIndex, projectId) ->

    # find the selected project's data object
    if siteData.projects[projectIndex].id == projectId
        siteData.projects[projectIndex]
    else
        siteData.projects.forEach (project) ->
            if project.id == projectId
                project

changeGalleryImages = (projectIndex) ->

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

changeGalleryText = (projectIndex) ->

    # change element content for the new project
    el.gallery.find 'h2'
        .text projectData.title

    # remove/add paragraph elements as needed
    requiredChange = projectData.description.length -
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

    for i in [0...projectData.description.length]
        el.article.children('p').eq(i).text projectData.description[i]

changeGalleryProject = (projectIndex) ->

    currentProjectIndex = projectIndex
    projectId = projectIndex + 1
    projectData = getProjectData projectIndex, projectId

    do changeGalleryImages
    do changeGalleryText
    do changeWindowAddress

    # slide back to the first image unless we're reopening the same project
    if projectId != lastOpenedProject
        slideToImage 0

    lastOpenedProject = projectId

toggleGallery = (time) ->

    elPreviewOpen = $ '.open'
    galleryIsOpening = elPreviewOpen.length > 0

    if time == undefined
        time = 400

    if galleryIsOpening
        # open the gallery
        el.gallery.slideDown time, ->
            el.gallery.removeClass 'transition'
            scrollToGallery time
    else
        # close the gallery
        el.gallery.addClass 'transition'
        # setTimeout is daft
        timeoutFunction = if time > 0 then setTimeout else (f) -> do f
        timeoutFunction ->
            el.gallery.slideUp time
        , 200

    galleryIsOpen = !galleryIsOpen

slideToImage = (imageIndex) ->

    # sanitise things a little
    galleryMaxIndex = projectData.galleryCount - 1
    imageIndex = Math.max imageIndex, 0
    imageIndex = Math.min imageIndex, galleryMaxIndex

    # get sliding a.s.a.p.
    conveyorProps.setRightVal imageIndex, true

    # place the 'current' class on the right thumbnail
    $ '.current'
        .removeClass 'current'
    el.nav
        .children()
        .eq imageIndex
        .addClass 'current'

    # remove old alternate styles
    el.imgNavs
        .removeClass 'proj-nav'
        .removeClass 'unavailable'

    # if we're sliding to the first image
    if imageIndex == 0
        el.imgPrev.addClass 'proj-nav'
        # if also the first project
        if currentProjectIndex == 0
            el.imgPrev.addClass 'unavailable'

    # if we're sliding to the last image
    if imageIndex == galleryMaxIndex
        el.imgNext.addClass 'proj-nav'
        # if also the last project
        if currentProjectIndex == siteData.projects.length - 1
            el.imgNext.addClass 'unavailable'

    # if we're sliding to either the first or last image
    if imageIndex == 0 or
       imageIndex == galleryMaxIndex
        # update navigation button width value
        # (wait for button to stretch before measuring)
        setTimeout conveyorProps.updateProjectNavWidth, 300

slideToImageRelative = (changeInIndex) ->

    # determine which gallery image is currently displayed
    elThumbnail = $ '.current'
    currentIndex = el.nav.children().index elThumbnail
    newIndex = currentIndex + changeInIndex

    # if we need to instead move to another project
    if currentIndex == 0 and changeInIndex == -1 or
       currentIndex == projectData.galleryCount - 1 and changeInIndex == 1
        targetProject = currentProjectIndex + changeInIndex
        if targetProject >= 0 and
           targetProject < siteData.projects.length
            el.previews.eq targetProject
                .trigger 'click'
    # slide to another image in the gallery
    else
        slideToImage newIndex
