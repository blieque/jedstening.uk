class ConveyorProps

    # private

    rightValRound = 0
    projectNavWidth = 0.3 # as long as this isn't zero, all will be well

    updateCss = ->

        rightValStr = "#{conveyorProps.rightVal * 100}%"
        el.conveyor.css 'right', rightValStr

    clipRightValToLimits = (rightVal, includeNavigation) ->

        # establish limits
        limitMinimum = 0
        limitMaximum = projectData.galleryCount - 1
        if includeNavigation
            limitMinimum -= projectNavWidth
            limitMaximum += projectNavWidth

        # clip right value to within limits
        rightVal = Math.max rightVal, limitMinimum
        rightVal = Math.min rightVal, limitMaximum

    # public

    rightVal: 0
    width: 0
    dragThreshold: 0

    roundRightVal: ->

        # makes it easier to swipe through gallery
        goingRight = this.rightVal > rightValRound
        leeway = 0.25
        if !goingRight
            leeway *= -1
        this.rightVal += leeway

        # round to integer (which is also the index of the current image)
        tempRound = Math.round this.rightVal

        # *appear* to ignore the leeway when navigating between projects
        tempRoundClipped = clipRightValToLimits tempRound
        # although the value is rounded we don't tell `setRightVal' that it is
        this.setRightVal tempRoundClipped

        # properly move
        if tempRound > rightValRound
            slideToImageRelative 1, true
        else if tempRound < rightValRound
            slideToImageRelative -1, true

    setRightVal: (rightVal, rounded, relative) ->

        if relative
            rightVal += rightValRound

        rightVal = clipRightValToLimits rightVal, true

        this.rightVal = rightVal
        if rounded and rightVal % 1 == 0
            rightValRound = rightVal

        updateCss()

    updateWidth: ->

        this.width = el.frame.width()
        this.dragThreshold = this.width * 0.012

    updateProjectNavWidth: ->

        projectNavWidthPx = 0

        if rightValRound == 0
            projectNavWidthPx = el.imgPrevArrow.width()
        else if rightValRound == projectData.galleryCount - 1
            projectNavWidthPx = el.imgNextArrow.width()

        # if `this.width' is used all hell breaks loose
        projectNavWidth = projectNavWidthPx / conveyorProps.width
