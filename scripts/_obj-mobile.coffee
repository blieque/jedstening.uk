# new mobile object
mobile =

    dragOrigin: { x:0, y:0 }
    dragging: false

    detect: ->

        if navigator.userAgent.match /Android/i or
           navigator.userAgent.match /webOS/i or
           navigator.userAgent.match /iPhone/i or
           navigator.userAgent.match /iPad/i or
           navigator.userAgent.match /iPod/i or
           navigator.userAgent.match /BlackBerry/i or
           navigator.userAgent.match /Windows Phone/i

            do this.changeDom
            do this.setListeners

            # attach initial mobile navigation event
            el.frame.on 'touchstart', this.conveyorTouchstart

    changeDom: ->

        # People on mobile should be able to handle a mailto link as their email
        # app is quite likely configured and will open. The email copying
        # overlay business is only really important for desktop/laptop browsing,
        # where most people just have a broken Outlook installation handling
        # mailto links.

        # remove email overlay
        el.emailAnchor.off 'click'
        # move gallery arrow controls behind the gallery
        el.body.addClass 'mobile'

    attachListeners: (removing) ->

        action = if removing then 'off' else 'on'
        el.document[action] 'touchmove', mobile.conveyorTouchmove
        el.window[action] 'resize', conveyorProps.update
        el.window[action] 'touchend', mobile.conveyorTouchend
        el.window[action] 'touchcancel', mobile.conveyorTouchend

    setListeners: ->

        this.conveyorTouchmove = (event) ->

            do event.preventDefault
            touchEvent = event.originalEvent.touches[0]

            delta =
                x: mobile.dragOrigin.x - touchEvent.clientX
                y: mobile.dragOrigin.y - touchEvent.clientY

            if mobile.dragging
                deltaXDecimal = delta.x / conveyorProps.width
                conveyorProps.setCssRightVal currentProjectIndex + deltaXDecimal
            else
                deltaSquared =
                    x: Math.pow delta.x, 2
                    y: Math.pow delta.y, 2
                distance = Math.sqrt deltaSquared.x + deltaSquared.y
                if distance > conveyorProps.dragThreshold

                    # I use the squared deltas to avoid having to find the
                    # absolute values of the deltas.

                    if deltaSquared.x > deltaSquared.y
                        mobile.dragging = true
                    else
                        do mobile.conveyorTouchend

        this.conveyorTouchstart = (event) ->

            touchEvent = event.originalEvent.touches[0]

            # These events are only attached here as they shouldn't be fired
            # frequently when the gallery isn't open and the user isn't
            # scrolling over gallery images.

            mobile.attachListeners false

            el.conveyor.addClass 'nt'

            mobile.dragOrigin.x = touchEvent.clientX
            mobile.dragOrigin.y = touchEvent.clientY
            currentProjectIndex = conveyorProps.rightVal

        this.conveyorTouchend = ->

            mobile.attachListeners true

            mobile.dragging = false
            el.conveyor.removeClass 'nt'

            do conveyorProps.roundRightVal
