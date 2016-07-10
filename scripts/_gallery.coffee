# event handlers

previewClick = (event, toggleTime) ->

    if event.ctrlKey
        return

    event.preventDefault()

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
        elementIndex = el.previews.index elPreview
        projectElementIndex = elementIndex
        positionGalleryElement elementIndex

        # change images and text of the project
        projectId = parseInt elPreview.attr('id').match(/[0-9]+/)[0]
        changeGalleryProject projectId

    # animate the gallery open or closed
    toggleGallery toggleTime

thumbnailClick = (event) ->

    event.preventDefault()

    elThumbnail = $ this
    imageIsCurrent = elThumbnail.hasClass 'current'
    imageIndex = el.nav.children().index elThumbnail

    slideToImage imageIndex

imgNavClick = ->

    elPreview = $ this
    difference = undefined
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
        positionGalleryElement()
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

positionGalleryElement = (elementIndex) ->

    if elementIndex == undefined
        elementIndex = el.previews.index $ '.open'

    # move the gallery into place in the dom
    if elementIndex >= 0
        lastOnRow = elementIndex + columns
        lastOnRow -= lastOnRow % columns
        lastOnRow = Math.min lastOnRow, el.previews.length
        el.gallery.insertAfter el.previews[lastOnRow - 1]

getProjectData = (projectId) ->

    # find the selected project's data object
    if typeof siteData.projects[projectId - 1] != 'undefined' and \
       siteData.projects[projectId - 1].id == projectId
        siteData.projects[projectId - 1]
    else
        project = undefined
        siteData.projects.some (projectLoop) ->
            if projectLoop.id == projectId
                project = projectLoop
                true
        project

changeGalleryImages = do ->

    # function to return interpolated urls with scheme, domain, etc.
    imageUrl = (parts) ->
        # zero-pad numbers
        parts[1] = "00#{parts[1]}".slice -2
        parts[2] = "00#{parts[2]}".slice -2

        if parts[0] == ''
            # return anchor href if no image classification/size is given
            "#{siteData.hrefPrefix}/#{projectData.id}"
        else
            # return normal interpolated string
            "#{siteData.hrefPrefix}/images/#{parts[0]}/" +
            "#{parts[1]}.#{parts[2]}.jpg"

    ->

        # remove/add image and thumbnail elements as needed
        deltaImages = projectData.galleryCount - el.conveyor.children().length
        removeOrAdd = undefined

        if deltaImages > 0
            removeOrAdd = ->
                el.templateImage.clone().appendTo el.conveyor
                el.templateThumbnail.clone(true).appendTo el.nav
        else if deltaImages < 0
            removeOrAdd = ->
                el.conveyor.children().last().remove()
                el.nav.children().last().remove()

        for i in [0...Math.abs deltaImages]
            removeOrAdd()

        # change element attributes (href, src) for the new project
        for i in [0...projectData.galleryCount]

            # actually change the src and href attributes
            el.conveyor.children().eq(i)
                .attr 'src', '' # change to blank first to prevent confusion
                .attr 'src', imageUrl ['full', projectData.id, i + 1]
            el.nav.children().eq(i)
                .attr 'href', imageUrl ['', projectData.id, i + 1]
                .children().attr 'src', ''
                .attr 'src', imageUrl ['thumb', projectData.id, i + 1]

changeGalleryText = () ->

    # change element content for the new project
    el.gallery.find 'h2'
        .text projectData.title

    # remove/add paragraph elements as needed
    deltaParagraphs = projectData.description.length -
                     el.article.children('p').length
    removeOrAdd = undefined

    if deltaParagraphs > 0
        removeOrAdd = ->
            el.article.append document.createElement 'p'
    else if deltaParagraphs < 0
        removeOrAdd = ->
            el.article.children('p').last().remove()

    for i in [0...Math.abs deltaParagraphs]
        removeOrAdd()

    for i in [0...projectData.description.length]
        el.article.children('p').eq(i).text projectData.description[i]

changeGalleryProject = (projectId) ->

    projectData = getProjectData projectId

    changeGalleryImages()
    changeGalleryText()
    changeWindowAddress()

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
            scrollToGallery time
    else
        # close the gallery
        # setTimeout is daft
        timeoutFunction = if time > 0 then setTimeout else (f) -> f()
        timeoutFunction ->
            el.gallery.slideUp time, changeWindowAddress
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
        if projectElementIndex == 0
            el.imgPrev.addClass 'unavailable'

    # if we're sliding to the last image
    if imageIndex == galleryMaxIndex
        el.imgNext.addClass 'proj-nav'
        # if also the last project
        if projectElementIndex == el.previews.length - 1
            el.imgNext.addClass 'unavailable'

    # if we're sliding to either the first or last image
    if imageIndex == 0 or
       imageIndex == galleryMaxIndex
        # update navigation button width value
        # (wait for button to stretch before measuring)
        setTimeout conveyorProps.updateProjectNavWidth, 300

slideToImageRelative = (deltaIndex) ->

    # determine which gallery image is currently displayed
    elThumbnail = $ '.current'
    currentIndex = el.nav.children().index elThumbnail
    newIndex = currentIndex + deltaIndex

    # if we need to instead move to another project
    if currentIndex == 0 and deltaIndex == -1 or
       currentIndex == projectData.galleryCount - 1 and deltaIndex == 1
        targetProject = deltaIndex + el.previews.index $ '.open'
        if targetProject >= 0 and
           targetProject < el.previews.length
            el.previews.eq(targetProject).click()
    # slide to another image in the gallery
    else
        slideToImage newIndex
