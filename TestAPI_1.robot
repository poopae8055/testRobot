# https://www.getpostman.com/collections/ec36bda71462eb0eb096
# https://reqres.in/api/users/2
# {"data":{"id":2,"first_name":"Janet","last_name":"Weaver",
# "avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg"}}
*** Settings ***
Library    Collections
Library    String
Library    HttpLibrary.HTTP
Library    RequestsLibrary
Resource   Variables.robot


*** Variables ***
${URL_GET}  https://www.getpostman.com/collections/ec36bda71462eb0eb096
@{header_response}    first_name    last_name    id    avatar


*** Keywords ***
Response Should Contain Keywords
  [Arguments]  ${Object}  ${expected_keys}
  ${object_keys}  Get Dictionary Keys    ${Object}
  Sort List  ${object_keys}
  Sort List  ${expected_keys}
  Log To Console  ${object_keys}
  Log To Console  ${expected_keys}
  Lists Should Be Equal    ${object_keys}   ${expected_keys}


Response Status Should Be Success
  [Arguments]  ${resp}
  Should Be Equal As Strings  ${resp.status_code}  200

Create Session for testing
  [Arguments]      &{params}
  # Log To Console   ${URL_1}
  # Log To Console   ${params}
  Create Session    PAEAPI    ${URL_1}
  ${resp}=    Get Request  PAEAPI  /api/users/2  params=${params}
  # Log To Console   ${resp.content}
  Return From Keyword   ${resp}

Get Json Value and convert to Object
  [Arguments]  ${json_string}  ${path}
  ${value}=  Get Json Value  ${json_string}  ${path}
  Log To Console  ${value}
  ${value}=  Parse Json  ${value}
  Log To Console  ${value}
  Return From Keyword    ${value}


PUT API PAE TEST
  [Arguments]      &{params}
  Create Session    PAEAPI    ${URL_1}
  &{data}=  Create Dictionary  first_name=Janet  last_name=ppTest  avatar=00
  &{headers}=  Create Dictionary  Content-Type=from-data
  ${resp}=  PUT Request   PAEAPI  /api/users/2   data=${data}  headers=${headers}
  Log To Console   ${resp.content}
  Return From Keyword   ${resp}

POST API PAE TEST
  [Arguments]      &{params}
  Create Session    PAEAPI    ${URL_1}
  &{data}=  Create Dictionary  id=2  first_name=Janet  last_name=ppTest  avatar=00
  &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
  ${resp}=  POST Request   PAEAPI  /api/users/2   data=${data}  headers=${headers}
  Log To Console   ${resp.status_code}
  Log To Console   ${resp.text}
  Return From Keyword   ${resp}



*** Test Cases ***
GET API PAE TEST
  &{params}=    Create Dictionary    type=json
  ${resp}=  Create Session for testing   &{params}
  Response Status Should Be Success    ${resp}
  ${header}=    Get Json Value and convert to Object    ${resp.content}  /data

  Response Should Contain Keywords  ${header}  ${header_response}
  # POST API PAE TEST
#   &{params}=    Create Dictionary    type=json
#   ${resp}=  POST API PAE TEST   &{params}
#   Should Contain    ${resp.text}  201

# PUT API PAE TEST
#   &{params}=    Create Dictionary    type=json
#   ${resp}=    PUT API PAE TEST   &{params}
#   Log To Console   ${resp.text}
#   Response Status Should Be Success    ${resp}








# Get API PAE TEST
#   Create Session   PAEAPI   ${URL_GET}
#    Log To Console   PAEAPI
#   ${resp}=   Get Request  PAEAPI  /todos/36f18b33-9e8b-4840-881e-a4a3139ff797
#   Should be Equal As Strings   ${resp.status_code}   200
#   Should Contain   ${resp.text}   ok
  # Log To Console  ${resp.text}

# Response Status Should be Success
#     [Arguments]    ${resp}
#     Should be Equal As Strings   ${resp.status_code}   200
#     Should Contain   ${resp.text}   ok

# f51d781a-9ab3-4406-b32d-41cbb6978334


# Get API PAE TEST
#   Get API PAE TEST ${URL_GET}

  # Response Status Should be Success    ${resp}