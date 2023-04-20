*** Settings ***
Documentation   Test suite for Smtp keywords and Smtp related Setter keywords.
...    | Test Case Name                                           | Tested Keyword                 | Return Case/Value |
...    | Send A Mail                                              | Send Mail                      | True              |
...    | Send A Mail With Attachment                              | Send Mail                      | True              |
...    | Send A Mail As If It Sent By Receiver                    | Send Mail                      | True              |
...    | Send A Mail As If It Sent By A Non Existing Mail Address | Send Mail                      | True              |
...    | Send A Mail To A Non Existing Mail Address               | Send Mail                      | True              |
...    | Send A Mail From You To You                              | Send Mail                      | True              |
...    | Set Smtp Username and Password                           | Set Smtp Username and Password | True,No Error     |
...    | Set Smtp Server Address                                 | Set Smtp Server Address         | True,No Error     |
...    | Set Both Smtp Ports                                      | Set Both Smtp Ports            | True,No Error     |
...    | Set Smtp Ssl Port                                        | Set Smtp Ssl Port              | True,No Error     |
...    


Resource        common.robot
Suite Setup     Run Keywords
...             Start Mail Server Docker
...  AND        Set All Mail Server Configs
Suite Teardown  Stop Mail Server Docker

Test Setup      Run Keywords
...             Set All Mail Server Configs
...  AND        Restart Mail Server Docker

*** Variables ***
${RECEIVERMAIL}  ${ENV_IMAP_USER}${DOMAIN}

*** Test Cases ***
Send A Mail
    [Tags]    unit  smtp  smtp_ssl
    ${MIME}    Open Latest Imap Mail 
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Send Mail  @{FIRST_MAIL} 
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}

Send A Mail With Attachment
    [Tags]    unit  smtp  smtp_ssl
    ${MIME}    Open Latest Imap Mail 
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Send Mail  @{FIRST_MAIL}  attachmentFullpath=${CURDIR}${/}robotframework-mailclientlibrary.png  
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail
    Should Contain    ${MIME}  Content-Type: image/png
    Should Contain    ${MIME}  Content-Transfer-Encoding: base64
    Should Contain    ${MIME}  Content-Disposition: attachment;
    Should Contain    ${MIME}  filename\="robotframework-mailclientlibrary.png"
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}

Send A Mail As If It Sent By Receiver
    [Tags]    unit  smtp  smtp_ssl
    ${STATUS}  Send Mail  @{LOOP_MAIL} 
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail 
    Mail Should Contain  ${MIME}  @{LOOP_MAIL}
    
Send A Mail As If It Sent By A Non Existing Mail Address
    [Tags]    unit  smtp  smtp_ssl
    ${STATUS}  Send Mail  @{NOS_MAIL} 
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail 
    Mail Should Contain  ${MIME}  @{NOS_MAIL}
    
Send A Mail To A Non Existing Mail Address
    [Tags]    unit  smtp  smtp_ssl
    ${STATUS}  Send Mail  @{NOR_MAIL} 
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail 
    Should Be Equal  ${MIME}  ${False}

Send A Mail From And To Non Existing Mail Address
    [Tags]    unit  smtp  smtp_ssl
    ${STATUS}  Send Mail  @{NOSNOR_MAIL} 
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail 
    Should Be Equal  ${MIME}  ${False}
    
Send A Mail From You To You
    [Tags]    unit  smtp  smtp_ssl
    Set Imap Username And Password    ${ENV_SMTP_USER}    ${ENV_SMTP_PASS}
    Send Mail  ${ENV_SMTP_USER}${DOMAIN}  ${ENV_SMTP_USER}${DOMAIN}  subject  text
    ${MIME}    Open Latest Imap Mail 
    Mail Should Contain  ${MIME}  ${ENV_SMTP_USER}${DOMAIN}  ${ENV_SMTP_USER}${DOMAIN}  subject  text

Set Smtp Username and Password
    [Tags]    unit  smtp  smtp_ssl
    Set Smtp Username and Password  ${ENV_SMTP_USER}  ${ENV_SMTP_PASS}
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Smtp Username and Password  ${ENV_ALT_USER}   ${ENV_ALT_PASS}
    Send Mail    @{SECOND_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{SECOND_MAIL}
    Set Smtp Username and Password  WrongUser    WrongPass
    ${EXP_ERR_MSG}  Format String   ${FalseCridentials}    Smtp  WrongUser  WrongPass
    Run Keyword And Expect Error    ${EXP_ERR_MSG}    Send Mail    @{THIRD_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{SECOND_MAIL}
    Set Smtp Username and Password  ${ENV_SMTP_USER}  ${ENV_SMTP_PASS}
    Send Mail    @{THIRD_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{THIRD_MAIL}

Set Smtp Server Address
    [Tags]    unit  smtp  smtp_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Smtp Server Address    127.0.0.1
    Send Mail    @{SECOND_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{SECOND_MAIL}
    Set Smtp Server Address    10.0.0.2
    ${EXP_ERR_MSG}  Format String   ${FalseHost}   Smtp  10.0.0.2
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Send Mail    @{FIRST_MAIL}
    Set Smtp Server Address    127.0.0.1
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{SECOND_MAIL}

Set Both Smtp Ports
    [Tags]    unit  smtp  smtp_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Smtp Ports   ${ENV_SMTP_SSL_PORT}  ${ENV_SMTP_PORT}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Smtp Ports    3331  3332
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Smtp   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Send Mail    @{SECOND_MAIL}
    Set Both Smtp Ports   ${ENV_SMTP_SSL_PORT}  ${ENV_SMTP_PORT}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Send Mail    @{SECOND_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{SECOND_MAIL}

Set Smtp Ssl Port
    [Tags]    unit  smtp  smtp_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Smtp Ssl Port   ${ENV_SMTP_SSL_PORT}
    Send Mail    @{SECOND_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{SECOND_MAIL}
    Set Smtp Ssl Port    3331
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Smtp   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Send Mail    @{THIRD_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{SECOND_MAIL}
    Set Smtp Ssl Port   ${ENV_SMTP_SSL_PORT}
    Send Mail    @{THIRD_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{THIRD_MAIL}