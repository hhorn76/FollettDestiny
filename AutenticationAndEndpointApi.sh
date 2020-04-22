#!/bin/bash
# Written by Heiko Horn 2020-04-16 
# This script will use the Follett Destiny API to receive an athentication token and request information from the API Endpoints

# Please modify the following variables: 
URL='https://xxx.xxx.xxx/api/v1/rest/'
ID=''
SECRET=''

# Function to get authenticaton token
function getAuthToken {
    ENDPOINT='auth/accessToken'
    JSON_TOKEN=$( curl --request POST "${URL}${ENDPOINT}" --data "client_id=${ID}&client_secret=${SECRET}&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=client_credentials" --silent )
    AUTH_TOKEN=$( echo "${JSON_TOKEN}" | /usr/bin/python -c 'import json,sys; obj=json.load(sys.stdin); authToken=obj["access_token"];print authToken' )
    # Enable this to view the the access_token
    #echo ${AUTH_TOKEN}
}

# Function to acccess an endpoint
function accessEndpoint {
    JSON=$( curl --location --request GET "${URL}${ENDPOINT}" --header "Authorization: Bearer ${AUTH_TOKEN}" --silent )
    # Enable this to view the infornamion returned from the endpoint in JSON
    #echo ${JSON}
}

### Exectute the functions below
# get authenticaton token
getAuthToken

# # get patron information
# ID='9419'
# ENDPOINT="patrons/${ID}"
# accessEndpoint

# # Print individual information from the patron endpoint
# BARCODE=$( echo "${JSON}" | /usr/bin/python -c 'import json,sys; obj=json.load(sys.stdin); string=obj["districtId"];print string' )
# LASTNAME=$( echo "${JSON}" | /usr/bin/python -c 'import json,sys; obj=json.load(sys.stdin); string=obj["lastName"];print string' )
# FIRSTNAME=$( echo "${JSON}" | /usr/bin/python -c 'import json,sys; obj=json.load(sys.stdin); string=obj["firstName"];print string' )
# echo "Barcode: ${BARCODE}"
# echo "LASTNAME: ${LASTNAME}"
# echo "FIRSTNAME: ${FIRSTNAME}"

# # get site information
# ARRAY_SITES=(100 101 102)
# for SITE in ${ARRAY_SITES[@]}; do
#     echo ${SITE}
#     ENDPOINT="sites/${SITE}"
#     accessEndpoint
#     echo "${JSON}"
# done

# # Lookup a patron at a specific site
# SITE_ID=102
# PATRON_ID=9419
# ENDPOINT="sites/${SITE_ID}/patrons/${PATRON_ID}"
# accessEndpoint
# echo "${JSON}"

# # Get resource type hierarchy
# ENDPOINT='materials/resourcetypes'
# accessEndpoint
# echo "${JSON}"

# # Get specific resource type
# TYPE=2730
# ENDPOINT="materials/resourcetypes/${TYPE}"
# accessEndpoint
# echo "${JSON}"

# # Get specific resource
# ID=85755
# ENDPOINT="materials/resources/${ID}"
# accessEndpoint
# echo "${JSON}"

# # Get all items
# ENDPOINT='materials/resources/items'
# accessEndpoint
# echo "${JSON}"

# Get specific item
# ID=41136
# ENDPOINT="materials/resources/items?id=${ID}"
# accessEndpoint
# echo "${JSON}"

# # Gets list of digital content available for this resource item
# ID=???
# ENDPOINT="materials/resources/items/${ID}/digitalcontent"
# accessEndpoint
# echo "${JSON}"

# # Download digital content file available for this resource item
# ITEM_ID=???
# ID=???
# ENDPOINT="materials/resources/items/${ITEM_ID}/digitalcontent/${ID}"
# accessEndpoint
# echo "${JSON}"

# # Get resources by resource type
# TYPE=2730
# ENDPOINT="materials/resourcetypes/${TYPE}/resources"
# accessEndpoint
# echo "${JSON}"

# # Get items by resource
# ID=???
# ENDPOINT="materials/resources/${ID}/items"
# accessEndpoint
# echo "${JSON}"

# # Get items by resource type
# TYPE=2730
# ENDPOINT="materials/resourcetypes/${TYPE}/items"
# accessEndpoint
# echo "${JSON}"

# # Get fines across the district
# ENDPOINT="fines"
# accessEndpoint
# echo "${JSON}"

# Get all items checked out to a specific patron
# ID=100249
# ENDPOINT="materials/resources/items?checkoutPatronBarcode=${ID}"
# accessEndpoint
# echo "${JSON}"