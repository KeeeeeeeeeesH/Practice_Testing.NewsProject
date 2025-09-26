*** Settings ***
Documentation     Scenario 02 - ตรวจสอบการทำงานของแถบนำทาง (Navigation Bar)
Library           SeleniumLibrary
Library    Telnet
Library    String
Resource          ../resources/keywords.robot

*** Test Cases ***
TC-SR-004
    Open Browser To Login Page
    Login As Admin
    Navigate to News Dashboard
    Wait Until Location Contains    expected=${URL}views/news/news.html
    Sleep    2s
    Close All Browsers

TC-SR-005
    Open Browser To Login Page
    Login As Admin
    Navigate to Picture Dashboard
    Wait Until Location Contains    expected=${URL}views/picture/picture.html
    Sleep    2s
    Close All Browsers

TC-SR-006
    Open Browser To Login Page
    Login As Admin
    Logout
    Wait Until Location Contains    expected=${URL}views/login.html
    ${session}=    Execute Javascript    return window.localStorage.getItem("isLoggedIn");
    Should Be Equal    ${session}    ${None}
    Sleep    2s
    Close All Browsers