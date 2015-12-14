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

    el.window = $ window
    el.document = $ document
    el.body = $ 'body'

    el.hide = $ '#hide'
    el.cssToJs = $ '#css-to-js'

    el.emailAnchor = $ 'header div:last-child > a'
    el.emailOverlay = $ '#email'
    el.emailBox = $ '#email [readonly]'
    el.emailButton = $ '#email [type="submit"]'

    el.gallery = $ '#gallery'
    el.imgNavs = $ '.img-nav'
    el.imgPrev = el.imgNavs.filter '.l'
    el.imgNext = el.imgNavs.filter '.r'
    el.imgPrevArrow = el.imgPrev.children 'div'
    el.imgNextArrow = el.imgPrev.children 'div'

    el.frame = $ '#frame'
    el.conveyor = $ '#conveyor'
    el.nav = $ '#content > nav'
    el.previews = $ 'section > a'
    el.templateImage = el.hide.children 'img'
    el.templateThumbnail = el.hide.children 'a'

    # events and bindings

    el.window.on 'resize', getColumns

    el.emailAnchor.on 'click', emailClick
    el.emailBox.on 'click', emailContentsClick
    el.emailButton.on 'click', emailContentsClick
    el.emailOverlay.on 'click', toggleEmailOverlay

    el.previews.on 'click', previewClick
    el.templateThumbnail.on 'click', thumbnailClick
    el.imgNavs.on 'click', imgNavClick

    # initialisation

    do updateGalleryHeight
    do conveyorProps.update
    toggleGallery 0
    do getColumns
    do mobile.detect
