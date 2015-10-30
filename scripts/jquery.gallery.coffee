---
---

# elements
elCssToJs = null
elGallery = null
elPreviews = null

# pseudo-globals
columns = 4
siteData = []

getColumns = ->

    columnsString = elCssToJs.css 'z-index'
    columnsInt = parseInt columnsString
    if !isNaN(columnsInt) and # if there's a change, and it's valid
       columnsInt > 0 and
       columnsInt < 5 and
       columns != columnsInt
        columns = columnsInt

toggleGallery = (time) ->

    if time == null
        time = 400

    elPreviewOpen = $ '.open'
    galleryIsOpening = elPreviewOpen.length > 0

    if galleryIsOpening
        elGallery.slideDown time, ->
            elGallery.removeClass 'transition'
    else
        elGallery.addClass 'transition'
        setTimeout ->
            elGallery.slideUp time
        , 200

previewClick = (event) ->

    event.preventDefault()

    elPreview = $ this
    projectIsOpen = elPreview.hasClass 'open'

    $ '.open'
      .removeClass 'open'

    if !projectIsOpen
        elPreview.addClass 'open'
        lastOnRow = elPreviews.index elPreview
        lastOnRow += 4
        lastOnRow -= lastOnRow % 4
        lastOnRow = Math.min lastOnRow, elPreviews.length
        elGallery.insertAfter elPreviews[lastOnRow - 1]

    toggleGallery()

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
    elPreviews = $ 'section>a'

    # events and bindings
    $ window
      .resize getColumns
    elPreviews
      .click previewClick

    # initialisation things
    getColumns
    toggleGallery 0
