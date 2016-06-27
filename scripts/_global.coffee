# pseudo-globals

# objects
el = {} # element object
mobile = undefined
window.conveyorProps = new ConveyorProps

# site
siteData = undefined

# gallery
byCategory = {}
projectData = {}
columns = 4
projectElementIndex = undefined
lastOpenedProject = undefined
galleryIsOpen = true # kinda not true

# email address overlay
emailOverlayIsOpen = false
commandSupportChecked = false

# category selection
currentCategoryName = ''
currentCategory = undefined
categoryNames = ['art', 'graphics']

# url stuff
pathPrefix = do ->
    pathParts = location.pathname.split '/'
    prefix = ''
    if pathParts[pathParts.length - 1] != '' and
       pathParts[pathParts.length - 2] in categoryNames
        prefix = '/..'
    prefix
