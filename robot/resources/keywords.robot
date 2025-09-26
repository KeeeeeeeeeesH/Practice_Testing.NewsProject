*** Settings ***
Library    SeleniumLibrary
Library    XML
Library    DateTime
Library    OperatingSystem
*** Variables ***
${URL}           https://co-newsproject.com/
${BROWSER}       Chrome

${USERNAME}      abcd
${PASSWORD}      1234

${TITLE}         ทดสอบ Robot Framework
${DETAIL}        ทดสอบเนื้อหา
${CATEGORY}      กีฬา
${MAJOR}         0

${EDIT_DETAIL}    ทดสอบ แก้ไข

${SEARCH_TYPE_1}    ค้นหาตามชื่อข่าว
${SEARCH_TYPE_2}    ค้นหาตามวันที่

${IMG_PATH1}    E:/HawKishZ/งาน2025+/QA/Practice_web_test_project/project_web/NewsImage/sport2.1.png
${IMG_PATH2}    E:/HawKishZ/งาน2025+/QA/Practice_web_test_project/project_web/NewsImage/sport2.2.png

*** Keywords ***

Open Browser To Login Page
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    ${args}=       Create List    --disable-blink-features=AutomationControlled    --incognito
    FOR    ${arg}    IN    @{args}
        Call Method    ${options}    add_argument    ${arg}
    END

    &{prefs}=      Create Dictionary    credentials_enable_service=False    profile.password_manager_enabled=False
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Create WebDriver    Chrome    options=${options}

    Maximize Browser Window
    Go To    ${URL}

Login As Admin
    Input Text    id=login    ${USERNAME}
    Input Text    id=password    ${PASSWORD}
    Click Button    xpath=//*[@id="loginForm"]/button
    Handle Alert    accept
    Wait Until Location Contains    dashboard

Navigate to News Dashboard
    Click Element    id=newsDropdown
    Click Element    xpath=//*[@id="newsDropdownContent"]/a[1]
    Wait Until Page Contains Element    xpath=//tbody[@id="newsList"]    timeout=10s

Navigate to Add News Page
    Click Element    xpath=//*[@id="content"]/a[1]

Add News
    ${NEWS_DATE}     Get Current Date    result_format=%Y-%m-%dT%H:%M
    Input Text    id=newsName    ${TITLE}
    Input Text    id=newsDetails    ${DETAIL}
    Input Text    id=newsDate    ${NEWS_DATE}
    Click Element    id=newsDetails
    Select From List By Label    id=catId    ${CATEGORY}       
    Select From List By Label    id=majorId    ${MAJOR}
    Click Button    xpath=//*[@id="addNewsForm"]/button[2]
    Handle Alert    accept
    Wait Until Location Contains    expected=${URL}views/news/news.html
    Wait Until Page Contains    text=${TITLE}    timeout=10s

Navigate to Edit News Page
    [Arguments]    ${news_title}
    ${xpath}=    Set Variable    //tbody[@id="newsList"]/tr[td[2][normalize-space(text())="${news_title}"]]/td[last()]/button[contains(@onclick, 'editNews')]
    Wait Until Element Is Visible    xpath=${xpath}    timeout=5s
    Click Element    xpath=${xpath}
    Wait Until Location Contains    expected=${URL}views/news/edit-news.html    timeout=5s

Search and Navigate to Edit News Page
    Select From List By Label    id=searchType    ${SEARCH_TYPE_1}
    Input Text    id=searchInput    ${TITLE}
    [Arguments]    ${news_title}
    ${xpath}=    Set Variable    //tbody[@id="newsList"]/tr[td[2][normalize-space(text())="${news_title}"]]/td[last()]/button[contains(@onclick, 'editNews')]
    Wait Until Element Is Visible    xpath=${xpath}    timeout=5s
    Click Element    xpath=${xpath}
    Wait Until Location Contains    expected=${URL}views/news/edit-news.html    timeout=5s

Edit News
    ${NEWS_DATE}     Get Current Date    result_format=%Y-%m-%dT%H:%M
    Wait Until Element Is Visible    id=newsDetails    timeout=5s
    Execute JavaScript    document.getElementById("newsDetails").value = ""
    Input Text    id=newsDetails    ${EDIT_DETAIL}
    Execute JavaScript    document.getElementById("newsDate").value = "${NEWS_DATE}";
    Sleep    3s
    Click Element    id=newsDetails
    Click Button    xpath=//*[@id="editNewsForm"]/button[2]
    Handle Alert    accept
    Wait Until Location Contains    expected=${URL}views/news/news.html
    Wait Until Page Contains    text=${EDIT_DETAIL}    timeout=10s

Search and Delete News
    Select From List By Label    id=searchType    ${SEARCH_TYPE_1}
    Input Text    id=searchInput    ${TITLE}
    [Arguments]    ${news_title}
    ${xpath}=    Set Variable    //tbody[@id="newsList"]/tr[td[2][normalize-space(text())="${news_title}"]]/td[last()]/button[contains(@onclick, 'deleteNews')]
    Wait Until Element Is Visible    xpath=${xpath}    timeout=5s
    Click Element    xpath=${xpath}
    Handle Alert    accept
    Handle Alert    accept
    Wait Until Page Does Not Contain    ${news_title}    timeout=5s

Navigate to Picture Dashboard
    Click Element    id=newsDropdown
    Click Element    xpath=//*[@id="newsDropdownContent"]/a[3]
    Wait Until Page Contains Element    xpath=//*[@id="gallery"]

Navigate to Add Picture Page
    Click Element    xpath=//*[@id="content"]/a

Upload False Cover Image
    Choose File    xpath=//*[@id="coverImage"]    E:/HawKishZ/งาน2025+/QA/Practice_web_test_project/project_web/NewsImage/crime1.png

Upload Multiple Content Pictures
    ${file1}=    Normalize Path    ${IMG_PATH1}
    ${file2}=    Normalize Path    ${IMG_PATH2}
    ${js}=    Catenate
    ...    const input = document.getElementById("contentImages");
    ...    const dt = new DataTransfer();
    ...    const file1 = new File([""], "${file1}", { type: "image/png" });
    ...    const file2 = new File([""], "${file2}", { type: "image/png" });
    ...    dt.items.add(file1);
    ...    dt.items.add(file2);
    ...    input.files = dt.files;
    Execute JavaScript    ${js}

Should Warning about Cover Image Filename
    ${warning}=    Handle Alert    action=accept
    Should Be Equal    ${warning}    Cover image filename must start with "cover_".

Should Warning about Image File Type
    ${warning}=    Handle Alert    action=accept
    Should Be Equal    ${warning}    อนุญาตให้อัพโหลดเฉพาะไฟล์ .jpg และ .png เท่านั้น.

Search and Delete Picture
    [Arguments]    ${news_id}
    Input Text    id=searchInput    ${news_id}
    ${xpath}=    Set Variable    //tbody[@id="gallery"]/tr/td[3]/button[contains(@onclick, "deleteImage(${news_id}")]
    Wait Until Element Is Visible    xpath=${xpath}    timeout=10s
    Click Element    xpath=${xpath}
    Wait Until Page Does Not Contain    ${news_id}    timeout=10s

Logout
    Click Button    id=logoutButton

