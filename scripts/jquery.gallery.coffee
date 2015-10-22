---
---

# elements
elCssToJs = null
elGallery = null
elPreviews = null
this.jsondata = null

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
    elCssToJs = $('#css-to-js')
    getColumns
    $(window).resize(getColumns)

    $.ajax
        url: 'data.json'
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
            console.log 'i gaat un errr: ' + textStatus

        success: (data, textStatus, jqXHR) ->
            console.log 'parsing'
            window.jsondata = data
