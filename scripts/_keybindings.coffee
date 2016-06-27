keyboardKeydown = ->
    if not (event.altKey or event.ctrlKey or event.shiftKey or \
            event.metaKey)

        prevent = true
        switch event.which
            when 37 then el.imgPrev.click()
            when 39 then el.imgNext.click()
            else prevent = false

        if prevent
            event.preventDefault()
