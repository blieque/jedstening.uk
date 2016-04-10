$ ->

    # kick off async stuff right away

    $.ajax
        url: 'data.json'
        dataType: 'json'

        success: (data, textStatus, jqXHR) ->
            siteData = data
            do slugifyTitles
            do openFromUrlWhenReady

        error: (jqXHR, textStatus, errorThrown) ->
            alert 'Error occurred while fetching site-data. The website will ' +
                  'most likely not work fully.\n\nError: ' + textStatus

    # find elements in the dom

    el.window = $ window
    el.document = $ document
    el.body = $ 'body'
    el.section = $ 'section'

    el.hide = $ '#hide'
    el.cssToJs = $ '#css-to-js'

    el.emailAnchor = $ 'header div:last-child > a'
    el.emailOverlay = $ '#email'
    el.emailBox = el.emailOverlay.children '[readonly]'
    el.emailButton = el.emailOverlay.children '[type="submit"]'

    el.selector = $ '#selector'
    el.categoryAnchors = el.selector.find 'div a'

    el.gallery = $ '#gallery'
    el.imgNavs = $ '.img-nav'
    el.imgPrev = el.imgNavs.filter '.l'
    el.imgNext = el.imgNavs.filter '.r'
    el.imgPrevArrow = el.imgPrev.children 'div'
    el.imgNextArrow = el.imgNext.children 'div'
    el.article = el.gallery.find 'article'
    el.frame = $ '#frame'
    el.conveyor = $ '#conveyor'
    el.nav = $ '#content > nav'
    el.galleryLoader = $ '.loader.gallery'

    el.templateImage = el.hide.children 'img'
    el.templateThumbnail = el.hide.children('a').eq 0
    el.templatePreview = el.hide.children('a').eq 1

    # events and bindings

    el.window.on 'resize', getColumns

    el.emailAnchor.on 'click', emailClick
    el.emailBox.on 'click', emailContentsClick
    el.emailButton.on 'click', emailContentsClick
    el.emailOverlay.on 'click', toggleEmailOverlay

    el.categoryAnchors.on 'click', selectCategory

    el.templatePreview.on 'click', previewClick
    el.templateThumbnail.on 'click', thumbnailClick
    el.imgNavs.on 'click', imgNavClick

    # initialisation

    do conveyorProps.updateWidth
    toggleGallery 0
    do getColumns
    do openFromUrlWhenReady
    mobile = new Mobile
