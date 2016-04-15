keyboardKeydown = do ->

    keys = [37, 39]

    (event) ->
        if event.which in keys
            imgNavIndex = keys.indexOf event.which
            el.imgNavs.eq(imgNavIndex).click()
