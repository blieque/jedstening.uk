---
---

# elements
elCssToJs = null
elGallery = null
elPreviews = null

# kinda global variables
columns = 4

getColumns = ->
    columnsString = elCssToJs.css 'z-index'
    columnsInt = parseInt columnsString
    if !isNaN(columnsInt) and # if there's a change, and it's valid
       columnsInt > 0 and
       columnsInt < 5 and
       columns != columnsInt
        columns = columnsInt

$ ->
    $(window).resize(getColumns)
    elCssToJs = $('#css-to-js')
