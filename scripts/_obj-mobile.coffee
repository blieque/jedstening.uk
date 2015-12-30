class Mobile

    # private

    dragOrigin = { x:0, y:0 }
    dragging = false

    changeDom = ->

        # People on mobile should be able to handle a mailto link as their email
        # app is quite likely configured and will open. The email copying
        # overlay business is only really important for desktop/laptop browsing,
        # where most people just have a broken Outlook installation handling
        # mailto links.

        # remove email overlay
        el.emailAnchor.off 'click'
        # move gallery arrow controls behind the gallery
        el.body.addClass 'mobile'

    manageListeners = (detatch) ->

        # The listeners that handle the movement of touch points on the screen
        # when the gallery is open needn't be attached when not needed. They are
        # attached when a touchpoint is created over the gallery conveyor, and
        # their are removed when the touch point is removed from the screen.

        action = if detatch then 'off' else 'on'
        el.document[action] 'touchmove', conveyorTouchmove
        el.window[action] 'touchcancel', conveyorTouchend
        el.window[action] 'touchend', conveyorTouchend
        el.window[action] 'resize', conveyorProps.updateWidth

    conveyorTouchmove = (event) ->

        do event.preventDefault
        touchEvent = event.originalEvent.touches[0]

        delta =
            x: dragOrigin.x - touchEvent.clientX
            y: dragOrigin.y - touchEvent.clientY

        if dragging
            deltaXDecimal = delta.x / conveyorProps.width
            conveyorProps.setRightVal deltaXDecimal, false, true
        else
            deltaSquared =
                x: Math.pow delta.x, 2
                y: Math.pow delta.y, 2
            distance = Math.sqrt deltaSquared.x + deltaSquared.y
            if distance > conveyorProps.dragThreshold

                # I use the squared deltas to avoid having to find the
                # absolute values of the deltas.

                if deltaSquared.x > deltaSquared.y
                    dragging = true
                    el.conveyor.addClass 'nt'
                else
                    do conveyorTouchend

    conveyorTouchstart = (event) ->

        touchEvent = event.originalEvent.touches[0]

        # These events are only attached here as they shouldn't be fired
        # frequently when the gallery isn't open and the user isn't
        # scrolling over gallery images.

        manageListeners false

        dragOrigin.x = touchEvent.clientX
        dragOrigin.y = touchEvent.clientY

    conveyorTouchend = ->

        manageListeners true

        if dragging

            dragging = false
            el.conveyor.removeClass 'nt'

            do conveyorProps.roundRightVal

    # public

    constructor: ->

        if navigator.userAgent.match /Android/i or
           navigator.userAgent.match /webOS/i or
           navigator.userAgent.match /iPhone/i or
           navigator.userAgent.match /iPad/i or
           navigator.userAgent.match /iPod/i or
           navigator.userAgent.match /BlackBerry/i or
           navigator.userAgent.match /Windows Phone/i

            do changeDom

            # attach initial mobile navigation event
            el.frame.on 'touchstart', conveyorTouchstart