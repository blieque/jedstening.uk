emailClick = (event) ->

    do event.preventDefault
    do toggleEmailOverlay

emailContentsClick = (event) ->

    do event.preventDefault
    do event.stopPropagation

    do el.emailBox.select
    elClickedInput = $ this
    if elClickedInput.is el.emailButton
        copySuccessful = document.execCommand 'copy'
        if copySuccessful
            el.emailOverlay.addClass 'success'

toggleEmailOverlay = ->

    if !commandSupportChecked and
       !document.queryCommandSupported 'copy'
        commandSupportChecked = true
        do el.emailButton.remove
        el.emailOverlay.addClass 'legacy'

    if emailOverlayIsOpen
        el.emailOverlay.css 'opacity', 0
        setTimeout ->
            el.emailOverlay.css 'display', 'none'
            el.emailOverlay.removeClass 'success'
        , 400
    else
        el.emailOverlay.css 'display', 'block'
        # don't ask
        setTimeout ->
            el.emailOverlay.css 'opacity', 1
        , 0
        do el.emailBox.select

    emailOverlayIsOpen = !emailOverlayIsOpen
