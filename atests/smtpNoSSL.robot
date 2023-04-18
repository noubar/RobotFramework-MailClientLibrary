*** Settings ***
Documentation   Test suite for Smtp keywords and Smtp related Setter keywords.
...    | Test Case Name                                           | Tested Keyword | Return Case/Value |
...    | Send A Mail                                              | Send Mail      | True              |
...    | Send A Mail With Attachment                              | Send Mail      | True              |
...    | Send A Mail As If It Sent By Receiver                    | Send Mail      | True              |
...    | Send A Mail As If It Sent By A Non Existing Mail Address | Send Mail      | True              |
...    | Send A Mail To A Non Existing Mail Address               | Send Mail      | True              |
...    | Send A Mail From You To You                              | Send Mail      | True              |
...                                                                                     
...    Unit Tests Are: 
...    | Send A Mail |
...    | Set Both Smtp Ports |
...    | Set Smtp Port |
...    
...    all others are extra because they are all tested in ssl test case.
...    

Resource        common.robot
Suite Setup     Run Keywords
...             Set All Mail Server Configs
...  AND        Start Mail Server Docker
Suite Teardown  Stop Mail Server Docker

Test Setup      Run Keywords
...             Set All Mail Server Configs
...  AND        Restart Mail Server Docker

*** Variables ***
${RECEIVERMAIL}  ${ENV_IMAP_USER}${DOMAIN}

*** Test Cases ***
Send A Mail
    [Tags]    unit  smtp  smtp_nossl
    ${MIME}    Open Latest Imap Mail   useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Send Mail  @{FIRST_MAIL}   useSsl=${False}
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}

Send A Mail With Attachment
    [Tags]    unit  smtp  smtp_nossl
    ${MIME}    Open Latest Imap Mail   useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Send Mail  @{FIRST_MAIL}  attachmentFullpath=${CURDIR}${/}robotframework-mailclientlibrary.png    useSsl=${False}
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail  useSsl=${False}
    Should Contain    ${MIME}  Content-Type: image/png
    Should Contain    ${MIME}  Content-Transfer-Encoding: base64
    Should Contain    ${MIME}  Content-Disposition: attachment;
    Should Contain    ${MIME}  filename\="robotframework-mailclientlibrary.png"
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}

Send A Mail As If It Sent By Receiver
    [Tags]    unit_extra  smtp  smtp_nossl
    ${STATUS}  Send Mail  @{LOOP_MAIL}   useSsl=${False}
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail   useSsl=${False}
    Mail Should Contain  ${MIME}  @{LOOP_MAIL}
    
Send A Mail As If It Sent By A Non Existing Mail Address
    [Tags]    unit_extra  smtp  smtp_nossl
    ${STATUS}  Send Mail  @{NOS_MAIL}   useSsl=${False}
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail   useSsl=${False}
    Mail Should Contain  ${MIME}  @{NOS_MAIL}
    
Send A Mail To A Non Existing Mail Address
    [Tags]    unit_extra  smtp  smtp_nossl
    ${STATUS}  Send Mail  @{NOR_MAIL}   useSsl=${False}
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail   useSsl=${False}
    Should Be Equal  ${MIME}  ${False}

Send A Mail From And To Non Existing Mail Address
    [Tags]    unit_extra  smtp  smtp_nossl
    ${STATUS}  Send Mail  @{NOSNOR_MAIL}   useSsl=${False}
    Should Be True  ${STATUS}
    ${MIME}    Open Latest Imap Mail   useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    
Send A Mail From You To You
    [Tags]    unit_extra  smtp  smtp_nossl
    Set Imap Username And Password  ${ENV_SMTP_USER}  ${ENV_SMTP_PASS}
    Send Mail  ${ENV_SMTP_USER}${DOMAIN}  ${ENV_SMTP_USER}${DOMAIN}  subject  text  useSsl=${False}
    ${MIME}    Open Latest Imap Mail   useSsl=${False}
    Mail Should Contain  ${MIME}    ${ENV_SMTP_USER}${DOMAIN}  ${ENV_SMTP_USER}${DOMAIN}  subject  text

Set Both Smtp Ports
    [Tags]    unit  smtp  smtp_nossl
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Smtp Ports   ${ENV_Smtp_SSL_PORT}  ${ENV_Smtp_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Smtp Ports    3331  3332
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Smtp   3332
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Send Mail  @{SECOND_MAIL}  useSsl=${False}
    Set Both Smtp Ports   ${ENV_Smtp_SSL_PORT}  ${ENV_Smtp_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}

Set Smtp Port
    [Tags]    unit  smtp  smtp_nossl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Smtp Port   ${ENV_Smtp_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Smtp Port    3331
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Smtp   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}   Send Mail  @{SECOND_MAIL}  useSsl=${False}
    Set Smtp Port   ${ENV_Smtp_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}