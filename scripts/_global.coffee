# pseudo-globals

# objects
el = {} # element object
mobile = null
window.conveyorProps = new ConveyorProps

# site
siteData = null

# gallery
byCategory = {}
projectData = {}
columns = 4
projectElementIndex = null
lastOpenedProject = null
galleryIsOpen = true # kinda not true

# email address overlay
emailOverlayIsOpen = false
commandSupportChecked = false

# category selection
currentCategoryName = ''
currentCategory = null
categoryNames = ['art', 'graphics']

# url stuff
pathPrefix = do ->
    pathParts = location.pathname.split '/'
    prefix = ''
    if pathParts[pathParts.length - 1] != '' and
       pathParts[pathParts.length - 2] in categoryNames
        prefix = '/..'
    prefix
