*** Settings ***
Documentation     Scenario 01 - ตรวจสอบฟังก์ชันการจัดการข้อมูลข่าวในระบบ
Library           SeleniumLibrary
Resource          ../resources/keywords.robot

*** Test Cases ***
TC-SR-001
    Open Browser To Login Page
    Login As Admin
    Navigate to News Dashboard
    Navigate to Add News Page
    Add News
    Close All Browsers

TC-SR-002
    Open Browser To Login Page
    Login As Admin
    Navigate to News Dashboard
    Search and Navigate to Edit News Page    ${TITLE}
    Edit News
    Close All Browsers

TC-SR-003
    Open Browser To Login Page
    Login As Admin
    Navigate to News Dashboard
    Search and Delete News    ${TITLE}
    Close All Browsers

