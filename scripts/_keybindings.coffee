keyboardKeydown = (event) ->
    if not (event.altKey or event.ctrlKey or event.shiftKey or \
            event.metaKey)

        prevent = true
        switch event.which
            # left arrow key
            when 37
                el.imgPrev.click()
            # right arrow key
            when 39
                el.imgNext.click()
            # escape
            when 27
                if galleryIsOpen
                    $('.open').trigger 'click'
                else if currentCategoryName != ''
                    el.title.trigger 'click'
            else
                prevent = false

        if prevent
            event.preventDefault()
