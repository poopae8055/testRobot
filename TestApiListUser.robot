# {"page":2,"per_page":3,"total":12,"total_pages":4,"data":
# [{"id":4,"first_name":"Eve","last_name":"Holt",
# "avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/marcoramires/128.jpg"},
# {"id":5,"first_name":"Charles","last_name":"Morris",
# "avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/stephenmoon/128.jpg"},
# {"id":6,"first_name":"Tracey","last_name":"Ramos",
# "avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/bigmancho/128.jpg"}]}

*** Settings ***
Resource   Variables.robot
Library    Collections
Library    HttpLibrary.HTTP
Library    RequestsLibrary

*** Variables ***
@{data_response}    first_name    last_name    id    avatar

*** Keywords ***
Create Sessions API
    [Arguments]    &{params}
    Create Session    USERAPI   ${URL_1}
    ${resp}=    Get Request    USERAPI    /api/users?page=2    params=${params}
    Return From Keyword    ${resp}

Response Status should be Success
    [Arguments]    ${resp}
    Should Be Equal As Strings    ${resp.status_code}    200

Get Json Value and Convert to Object
    [Arguments]    ${json_string}    ${path}
    ${value}=    Get Json Value    ${json_string}    ${path}
    ${value}=    Parse Json    ${value}
    Return From Keyword    ${value}

Response Should Contain Keys
    [Arguments]    ${object}    ${expected_keys}
    ${object_keys}    Get Dictionary Keys    ${object}
    Sort List    ${object_keys}
    Sort List    ${expected_keys}
    Log To Console    ${object_keys}
    Log List    ${expected_keys}
    Lists Should Be Equal    ${object_keys}    ${expected_keys}


*** Test Cases ***
Test Get Data
    &{params}=    Create Dictionary   type=json
    ${resp}=    Create Sessions API    &{params}
    Response Status should be Success    ${resp}
    ${data}=   Get Json Value and Convert to Object    ${resp.content}    /data
    # Response Should Contain Keys    ${data}    ${data_response}
    ${len}=    Get Length    ${data}
    Log To Console    ${len}
    Run Keyword If    ${len} > 0    Response Should Contain Keys    ${data}[0]    ${data_response}

Test Get Data id 5
    &{params}=    Create Dictionary   type=json   first_name=Charles
    ${resp}=    Create Sessions API    &{params}
    Response Status should be Success    ${resp}
    ${data}=   Get Json Value and Convert to Object    ${resp.content}    /data
    # Response Should Contain Keys    ${data}    ${data_response}
    ${len}=    Get Length    ${data}
    Log To Console    ${len}
    Run Keyword If    ${len} > 0    Response Should Contain Keys    ${data}[0]    ${data_response}