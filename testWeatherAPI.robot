*** Setting ***
Library    Collections
Library    String
Library    HttpLibrary.HTTP
Library    RequestsLibrary

*** Variables ***
${url}    http://data.tmd.go.th/api

@{header_response}        Title    Description    Uri    LastBuiltDate
...    CopyRight    Generator
@{stations_response}        WmoNumber    StationNameTh    StationNameEng
...    Province    Latitude    Longitude    Observe

*** Keywords ***
Response Status should be Success
    [Arguments]    ${resp}
    Should Be Equal As Strings    ${resp.status_code}    200

Get Json Value and convert to Object
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

Get Weather3Hours
    [Arguments]    ${params}
    Create Session    tmd    ${url}
    # Create session name tmd when going to uel
    ${resp}=    Get Request    tmd    /Weather3Hours/V1    params=${params}
    # Choose type request, session that we create, and  location

    Return From Keyword    ${resp}


*** Test Cases ***
Get Weather3Hours Should Success and return data
    &{params}=    Create Dictionary    type=json
    # case when we want to send request with data we have to create Dictionary
    # เวลาที่ ${resp} มันเรียกใช้มันจะได้รู้จักเราก่อน เช่นกรณีที่ PUT กับ POST
    # &{data}=  Create Dictionary    name=nantRobot    text=Hello world

    Log To Console   ${params}
    ${resp}=    Get Weather3Hours    ${params}
    Log To Console   ${resp}
    Log Json    ${resp.content}
    Response Status should be Success    ${resp}
    ${header}=    Get Json Value and convert to Object    ${resp.content}    /Header


    Response Should Contain Keys    ${header}    ${header_response}
    ${stations}=    Get Json Value and convert to Object    ${resp.content}    /Stations
    ${len}=    Get Length    ${stations}
    Log To Console   ${len}
    Run Keyword If    ${len} > 0    Response Should Contain Keys    @{stations}[0]    ${stations_response}

