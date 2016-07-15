# start poking at the dom, once we have one

$ ->

    # find elements in the dom

    el.window = $ window
    el.document = $ document
    el.body = $ 'body'
    el.section = $ 'section'

    el.hide = $ '#hide'
    el.cssToJs = $ '#css-to-js'

    el.title = $ 'header h1 a'

    el.emailAnchor = $ 'header div:last-child > a'
    el.emailOverlay = $ '#email'
    el.emailBox = el.emailOverlay.children '[readonly]'
    el.emailButton = el.emailOverlay.children '[type="submit"]'

    el.selector = $ '#selector'
    el.categoryAnchors = el.selector.find 'div a'
    el.selectorContents = el.categoryAnchors.add '#and'

    el.previews = $ 'section > a'

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

    el.title.on 'click', titleClick

    el.emailAnchor.on 'click', emailClick
    el.emailBox.on 'click', emailContentsClick
    el.emailButton.on 'click', emailContentsClick
    el.emailOverlay.on 'click', toggleEmailOverlay

    el.categoryAnchors.on 'click', categoryAnchorClick

    el.templatePreview.on 'click', previewClick
    el.templateThumbnail.on 'click', thumbnailClick
    el.imgNavs.on 'click', imgNavClick

    el.document.on 'keydown', keyboardKeydown

    # initialisation

    conveyorProps.updateWidth()
    toggleGallery true
    getColumns()
    mobile = new Mobile
    slugifyTitles()
    categoriseProjects()
    openFromUrl()
