conveyorProps =

    rightVal: 0
    rightValRound: 0
    width: 0
    projectNavWidth: 0
    dragThreshold: 0

    setCssRightVal: (rightVal) ->

        this.rightVal = rightVal

        # clip right value to within limits
        limitMinimum = -this.projectNavWidth
        limitMaximum = projectData.galleryCount + this.projectNavWidth - 1
        this.rightVal = Math.max this.rightVal, limitMinimum
        this.rightVal = Math.min this.rightVal, limitMaximum

        rightValStr = "#{this.rightVal * 100}%"
        el.conveyor.css 'right', rightValStr

    roundRightVal: ->

        console.log this.rightVal, this.rightValRound
        goingRight = this.rightVal > this.rightValRound

        offset = if goingRight then 0.25 else -0.25
        this.rightVal += offset
        this.rightValRound = Math.round this.rightVal

        deltaIndex = if goingRight then 1 else -1
        slideToImageRelative deltaIndex

    update: ->

        this.width = do el.conveyor.width
        this.dragThreshold = do el.conveyor.height * 0.02

        projectNavWidthPx = 0
        if this.rightValRound == 0
            projectNavWidthPx = do el.imgPrevArrow.width
        else if this.rightValRound == projectData.galleryCount - 1
            projectNavWidthPx = do el.imgNextArrow.width
        this.projectNavWidth = projectNavWidthPx / this.width
