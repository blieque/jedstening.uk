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


previewClick = (event) ->

    event.preventDefault()

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

        # move the gallery into place in the dom
        lastOnRow = projectIndex + columns
        lastOnRow -= lastOnRow % columns
        lastOnRow = Math.min lastOnRow, elPreviews.length
        elGallery.insertAfter elPreviews[lastOnRow - 1]

        changeGalleryProject projectIndex

    toggleGallery()

    if !projectIsOpen

        # scroll to the gallery
        gapAboveGallery = (elWindow.height() - galleryHeight) / 2
        gapAboveGallery = Math.max 0, gapAboveGallery
        $ document.body
            .animate
                scrollTop: elGallery.offset().top - gapAboveGallery
            , 400

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
    requiredChange = Math.abs requiredChange
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

    for i in [0...requiredChange]
        removeOrAdd()

    # change element attributes and contents for the new project
    for i in [0...projectData.galleryCount]

        # update image element classes
        classArray = ['current', 'right', 'rightx2']
        classIndex = Math.min(2, i)
        elConveyor.children().eq(i).addClass classArray[classIndex]

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
        elConveyor.children().eq(i).attr 'src',
            imageUrl ['full', projectData.id, i + 1]
        elNav.children().eq(i).attr 'href', imageUrl ['', projectData.id, i + 1]
            .children().attr 'src', imageUrl ['thumb', projectData.id, i + 1]

toggleGallery = (time) ->

    if time == null
        time = 400

    elPreviewOpen = $ '.open'
    galleryIsOpening = elPreviewOpen.length > 0

    if galleryIsOpening
        # open the gallery
        elGallery.slideDown time, ->
            elGallery.removeClass 'transition'
    else
        # update gallery height variable
        setTimeout ->
            galleryHeight = elGallery.height()
        , 20
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
    getColumns()
    toggleGallery 0
