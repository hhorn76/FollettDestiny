#########################################################################################
#                        Written by Heiko Horn 2020-04-16                               #
#########################################################################################
### This script will use the Follett Destiny API to receive an athentication token and request information from the API Endpoints

### Please modify the following variables: 
$strApi = 'https://xxx.xxx.xxx/api/v1/rest/'
$strID = ''
$strSecret = ''

# Function to get authenticaton token
function getAuthToken () {
    $hashBody = @{
        'client_id' = "$strID"
        'client_secret' = "$strSecret"
        'grant_type' = 'client_credentials'
    }
    $strApiUrl = $strApi + 'auth/accessToken'
    $jsonData = Invoke-RestMethod -Uri $strApiUrl -Body $hashBody -Method POST
    $strAuthToken = $jsonData.access_token
    return $strAuthToken
}

# Function to acccess an endpound
function accessEndpoint ($strApiUrl, $strAuthToken, $strParameter, $strValue) {
    if ($strParameter) {
        $hashBody = @{
            $strParameter = $strValue
        }
    }
    $hashHeaders = @{
		'Authorization' = "Bearer $strAuthToken"
	}
    $jsonData = Invoke-RestMethod -Uri $strApiUrl -Headers $hashHeaders -Body $hashBody
    return $jsonData
}

### Exectute the functions below
# get authenticaton token
$strAuthToken = getAuthToken

### Uncomment to use the Endpoints
# get patron information
# $strID = '9419'
# $strEndpoint = "patrons/$strID"
# $strApiUrl = $strApi + $strEndpoint
# $objParton = accessEndpoint $strApiUrl $strAuthToken

# Write-Host "ID: $($objParton.internalId)"
# Write-Host "Barcode: $($objParton.districtId)"
# Write-Host "LASTNAME: $($objParton.lastName)"
# Write-Host "FIRSTNAME: $($objParton.firstName)"

# get site information
# 100..102 | ForEach-Object {
#     Write-Host $_
#     $strEndpoint = "sites/$_"
#     $strApiUrl = $strApi + $strEndpoint
#     accessEndpoint $strApiUrl $strAuthToken
# }

# Lookup a patron at a specific site
# $intSiteId=102
# $intPatronId=9419
# $strEndpoint = "sites/$intSiteId/patrons/$intPatronId"
# $strApiUrl = $strApi + $strEndpoint
# accessEndpoint $strApiUrl $strAuthToken

# Get resource type hierarchy
# $strEndpoint = 'materials/resourcetypes'
# $strApiUrl = $strApi + $strEndpoint
# $objRecourceTypes = accessEndpoint $strApiUrl $strAuthToken
# $objRecourceTypes.children

# Get specific resource type
# $intType=514
# $strEndpoint = "materials/resourcetypes/$intType"
# $strApiUrl = $strApi + $strEndpoint
# $objRecourceType = accessEndpoint $strApiUrl $strAuthToken
# $objRecourceType.children

# $intType=2730
# $strEndpoint = "materials/resourcetypes/$intType"
# $strApiUrl = $strApi + $strEndpoint
# $objRecourceType = accessEndpoint $strApiUrl $strAuthToken
# $objRecourceType

# Get specific resource
# $intId = 85755
# $strEndpoint = "materials/resources/$intId"
# $strApiUrl = $strApi + $strEndpoint
# accessEndpoint $strApiUrl $strAuthToken

# Get all items
# $strEndpoint = 'materials/resources/items'
# $strApiUrl = $strApi + $strEndpoint
# $objRecource = accessEndpoint $strApiUrl $strAuthToken
# $objRecource.value

# Get specific item
# $intId = 42016
# $strEndpoint = "materials/resources/items"
# $strApiUrl = $strApi + $strEndpoint
# $objRecource = accessEndpoint $strApiUrl $strAuthToken 'id' 42019
# $objRecource.value

# Gets list of digital content available for this resource item
# $intId = ???
# $strEndpoint = "materials/resources/items/$intId/digitalcontent"
# $strApiUrl = $strApi + $strEndpoint
# $objRecource = accessEndpoint $strApiUrl $strAuthToken
# $objRecource.value

# Download digital content file available for this resource item
# $intId = ???
# $intContent=???
# $strEndpoint = "materials/resources/items/$intId/digitalcontent/$intContent"
# $strApiUrl = $strApi + $strEndpoint
# $objRecource = accessEndpoint $strApiUrl $strAuthToken
# $objRecource.value

# # Get resources by resource type
# $intType=2730
# $strEndpoint = "materials/resourcetypes/$intType/resources"
# $strApiUrl = $strApi + $strEndpoint
# $objRecourceTypes = accessEndpoint $strApiUrl $strAuthToken
# $objRecourceTypes.value

# # Get items by resource
# $intId = ???
# $strEndpoint = "materials/resources/$intId/items"
# $strApiUrl = $strApi + $strEndpoint
# $objRecource = accessEndpoint $strApiUrl $strAuthToken
# $objRecource.value

# Get items by resource type
# $intType=2730
# $strEndpoint = "materials/resourcetypes/$intType/items"
# $strApiUrl = $strApi + $strEndpoint
# $objRecourceTypes = accessEndpoint $strApiUrl $strAuthToken
# $objRecourceTypes.value

# Get fines across the district
# $strEndpoint = "fines"
# $strApiUrl = $strApi + $strEndpoint
# accessEndpoint $strApiUrl $strAuthToken

# Get all items checked out to a specific patron
$strEndpoint = 'materials/resources/items'
$strApiUrl = $strApi + $strEndpoint
$intBarcode = 100249
$objRecource = accessEndpoint $strApiUrl $strAuthToken 'checkoutPatronBarcode' $intBarcode
$arrItems=@()
foreach ($item in $objRecource.value) {
    #Write-Host "Type: $($item.resourceType.name)"
    $objItem = New-Object -TypeName PSObject -Property @{
        'ID'=$item.id
        'Barcode'=$item.barcode
        'Type'=$item.resourceType.name
    }
    #Write-Host "ID: $($item.id)"
    #Write-Host "Barcode: $($item.barcode)"
    foreach ($field in $item.itemFields) {
        if ($field.name -eq "Serial Number") {
            $objItem | Add-Member -MemberType NoteProperty -Name 'SerialNumber' -Value $field.value -Force
            #Write-Host "Serial Number: $($field.value)`n"
        }
    }
    $arrItems+=$objItem
}
$arrItems