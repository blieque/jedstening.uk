keyboardKeydown = ->
    if not (event.altKey or event.ctrlKey or event.shiftKey or \
            event.metaKey)

        prevent = true
        switch event.which
            # left arrow key
            when 37 then el.imgPrev.click()
            # right arrow key
            when 39 then el.imgNext.click()
            # escape
            when 27 then $('.open').click()
            else prevent = false

        if prevent
            event.preventDefault()
