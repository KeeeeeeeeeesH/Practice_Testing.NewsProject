*** Settings ***
Documentation     Scenario 03 - ตรวจสอบฟังก์ชันการจัดการรูปภาพในระบบ
Library           SeleniumLibrary
Resource          ../resources/keywords.robot

*** Test Cases ***
TC-SR-007
    Open Browser To Login Page
    Login As Admin
    Navigate to Picture Dashboard
    Navigate to Add Picture Page
    Sleep    1s
    Select From List By Value    xpath=//*[@id="newsId"]    214
    Sleep    1s
    Upload False Cover Image
    Sleep    1s
    Upload Multiple Content Pictures
    Sleep    1s
    Click Button    xpath=//*[@id="uploadForm"]/button
    Sleep    5s
    Should Warning about Cover Image Filename
    Sleep    3s
    Close All Browsers

TC-SR-008
    Open Browser To Login Page
    Login As Admin
    Navigate to Picture Dashboard
    Navigate to Add Picture Page
    Sleep    1s
    Select From List By Value    xpath=//*[@id="newsId"]    214
    Sleep    1s
    Choose File    xpath=//*[@id="coverImage"]    E:/HawKishZ/งาน2025+/QA/Practice_web_test_project/project_web/NewsImage/Cover/cover_crime1.png
    Sleep    1s
    Choose File    xpath=//*[@id="contentImages"]    E:/HawKishZ/งาน2025+/QA/Practice_web_test_project/project_web/NewsImage/Cover/gif mock.gif
    Sleep    1s
    Click Button    xpath=//*[@id="uploadForm"]/button
    Sleep    5s
    Should Warning about Image File Type
    Sleep    3s
    Close All Browsers

TC-SR-009
    Open Browser To Login Page
    Login As Admin
    Navigate to Picture Dashboard
    Search and Delete Picture    214
    Sleep    3s
    Close All Browsers

    