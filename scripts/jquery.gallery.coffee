---
---

# pseudo-globals
columns = 4
siteData = []
lastOpenedProject = null
galleryHeight = 0

# elements
elCssToJs = null
elGallery = null
elConveyor = null
elNav = null
elPreviews = null
elHide = null
elWindow = null

getColumns = ->

    columnsString = elCssToJs.css 'z-index'
    columnsInt = parseInt columnsString
    if !isNaN(columnsInt) and # if there's a change, and it's valid
       columnsInt > 0 and
       columnsInt < 5 and
       columnsInt != columns
        columns = columnsInt
        do positionGalleryElement

updateGalleryHeight = ->

    galleryHeight = do elGallery.height
    console.log galleryHeight

previewClick = (event) ->

    do event.preventDefault

    elPreview = $ this
    projectIsOpen = elPreview.hasClass 'open'

    # remove the open class from the last clicked preview
    $ '.open'
        .removeClass 'open'

    # user has clicked the preview for a project that is not already open
    if !projectIsOpen

        # change appearance of and locate clicked preview
        elPreview.addClass 'open'
        projectIndex = elPreviews.index elPreview
        positionGalleryElement projectIndex

        # change images and text of the project
        changeGalleryProject projectIndex

    do toggleGallery

    if !projectIsOpen

        # scroll to the gallery
        gapAboveGallery = (elWindow.height() - galleryHeight) / 2
        gapAboveGallery = Math.max 0, gapAboveGallery
        $ document.body
            .animate
                scrollTop: elGallery.offset().top - gapAboveGallery
            , 400

positionGalleryElement = (projectIndex) ->

    if projectIndex == undefined or projectIndex == null
        projectIndex = elPreviews.index $ '.open'

    # move the gallery into place in the dom
    if projectIndex >= 0
        lastOnRow = projectIndex + columns
        lastOnRow -= lastOnRow % columns
        lastOnRow = Math.min lastOnRow, elPreviews.length
        elGallery.insertAfter elPreviews[lastOnRow - 1]

changeGalleryProject = (projectIndex) ->

    projectId = projectIndex + 1

    # find the selected project's data object
    projectData = null
    if siteData.projects[projectIndex].id == projectId
        projectData = siteData.projects[projectIndex]
    else
        siteData.projects.forEach (project) ->
            if project.id == projectId
                projectData = project

    # remove/add image and thumbnail elements as needed
    requiredChange = projectData.galleryCount - elConveyor.children().length
    removeOrAdd = null

    if requiredChange > 0
        removeOrAdd = do ->
            elImgTemplate = elHide.children 'img'
            elThumbnailTemplate = elHide.children 'a'
            ->
                elImgTemplate.clone().appendTo elConveyor
                elThumbnailTemplate.clone().appendTo elNav
    else if requiredChange < 0
        removeOrAdd = ->
            elConveyor.children().last().remove()
            elNav.children().last().remove()

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
        elConveyor.children().eq(i)
            .attr 'src', imageUrl ['full', projectData.id, i + 1]
        elNav.children().eq(i)
            .attr 'href', imageUrl ['', projectData.id, i + 1]
            .children().attr 'src', imageUrl ['thumb', projectData.id, i + 1]

    # change element content for the new project
    elGallery.find 'h2'
        .text projectData.title

    # remove/add image and thumbnail elements as needed
    requiredChange = projectData.galleryCount - elConveyor.children().length
    removeOrAdd = null

    if requiredChange > 0
        removeOrAdd = ->
            elArticle.append document.createElement 'p'
    else if requiredChange < 0
        removeOrAdd = ->
            elArticle.children('p').last().remove()

    for i in [0...Math.abs requiredChange]
        do removeOrAdd

    elArticle = elGallery.find 'article'
    for i in [0...projectData.galleryCount]
        elArticle.children('p').eq(i).text projectData.descriptionFull[i]

toggleGallery = (time) ->

    elPreviewOpen = $ '.open'
    galleryIsOpening = elPreviewOpen.length > 0

    if time == undefined or time == null
        time = 400

    if galleryIsOpening
        # open the gallery
        elGallery.slideDown time, ->
            elGallery.removeClass 'transition'
    else
        # update gallery height variable
        do updateGalleryHeight

        # close the gallery
        elGallery.addClass 'transition'
        setTimeout ->
            elGallery.slideUp time
        , 200

$ ->

    # kick off async stuff right away
    $.ajax
        url: 'data.json'
        dataType: 'json'

        success: (data, textStatus, jqXHR) ->
            siteData = data

        error: (jqXHR, textStatus, errorThrown) ->
            alert 'Error occurred while fetching site-data. The website will ' +
                  'most likely not work fully.\n\nError: ' + textStatus

    # find elements in the dom
    elCssToJs = $ '#css-to-js'
    elGallery = $ '#gallery'
    elConveyor = $ '#conveyor'
    elNav = $ '#content > nav'
    elPreviews = $ 'section > a'
    elHide = $ '#hide'
    elWindow = $ window

    # events and bindings
    elWindow.resize getColumns
    elPreviews.click previewClick

    # initialisation things
    do updateGalleryHeight
    do getColumns
    toggleGallery 0
    do $('canvas').remove
