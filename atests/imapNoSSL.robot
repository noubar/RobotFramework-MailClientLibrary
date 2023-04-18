*** Settings ***
Documentation   Test suite for Imap keywords and Imap related Setter keywords.
...    
...    | Test Case Name                       | Tested Keyword                    | Return Case/Value |
...    | Open And Delete Imap Mail By Subject | Open Imap Mail By Subject         | True,False        |
...    |                                      | Delete Imap Mail By Subject       | True,False        |
...    | Open And Delete Imap Mail By Sender  | Open Imap Mail By Sender          | True,False        |
...    |                                      | Delete Imap Mail By Sender        | True,False        |
...    | Open And Delete Imap Mail By Index   | Open Imap Mail By Index           | True,False        |
...    |                                      | Delete Imap Mail By Index         | True,False        |
...    | Open And Delete Latest Imap Mail     | Open Latest Imap Mail             | True,False        |
...    |                                      | Delete Latest Imap Mail           | True,False        |
...    | Delete Every Imap Mail By Sender     | Delete Every Imap Mail By Sender  | True,False        |
...    | Delete Every Imap Mail By Subject    | Delete Every Imap Mail By Subject | True,False        |
...    | Delete Latest Imap Mail              | Delete Latest Imap Mail           | True,False        |
...    | Delete Every Imap Mail               | Delete Every Imap Mail            | True,False        |
...    | Is Imap Inbox Empty                  | Is Imap Inbox Empty               | True,False        |
...    |                                      | Imap Inbox Should Be Empty        | No Error,Error    |
...    |                                      | Get Imap Mail Count               | True,False        |
...    | Set Both Imap Ports                  | Set Both Imap Ports               | No Error          |
...    | Set Imap Port                        | Set Imap Port                     | No Error          |
...    
...    Unit Tests Are: 
...    | Open And Delete Imap Mail By Subject |
...    | Set Both Imap Ports |
...    | Set Imap Port |
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
Open And Delete Imap Mail By Subject
    [Tags]    unit  imap  imap_nossl
    ${MIME}    Open Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Delete Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}    useSsl=${False}
    ${MIME}    Open Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${STATUS}  ${True}

Open And Delete Imap Mail By Sender
    [Tags]    unit_extra  imap  imap_nossl
    ${MIME}    Open Imap Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Imap Mail By Sender    ${SENDERMAIL}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    Send Mail  @{FIRST_MAIL}  useSsl=${False}
    ${MIME}     Open Imap Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Mail Should Contain    ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Imap Mail By Sender    ${SENDERMAIL}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Imap Mail By Index
    [Tags]    unit_extra  imap  imap_nossl
    ${MIME}    Open Imap Mail By Index    ${1}  useSsl=${False}
    Should Be Equal  ${MIME}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${1}  useSsl=${False}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}  useSsl=${False}
    ${MIME}    Open Imap Mail By Index  ${1}  useSsl=${False}
    Mail Should Contain  ${MIME}    @{FIRST_MAIL}
    ${STATUS}  Delete Imap Mail By Index  ${2}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${2}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${-1}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${1}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Latest Imap Mail
    [Tags]    unit_extra  imap  imap_nossl
    ${MIME}    Open Latest Imap Mail  useSsl=${False}
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Latest Imap Mail  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Latest Imap Mail  useSsl=${False}
    Should Be Equal  ${STATUS}  ${True}

Delete Every Imap Mail By Subject
    [Tags]    unit_extra  imap  imap_nossl
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{SECOND_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}  useSsl=${False}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}  
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT2}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT2}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}

Delete Every Imap Mail By Sender
    [Tags]    unit_extra  imap  imap_nossl
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{SECOND_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}

Delete Every Imap Mail
    [Tags]    unit_extra  imap  imap_nossl
    ${MIME}    Delete Every Imap Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Imap Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{SECOND_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Imap Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Imap Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}

Is Imap Inbox Empty
    [Tags]    unit_extra  imap  imap_nossl
    Imap Inbox Should Be Empty
    ${STATUS}  Is Imap Inbox Empty  useSsl=${False}
    Should Be Equal  ${STATUS}  ${True}
    ${COUNT}  Get Imap Mail Count  useSsl=${False}
    Should Be Equal As Integers  ${COUNT}  ${0}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${STATUS}  Is Imap Inbox Empty  useSsl=${False}
    Should Be Equal  ${STATUS}  ${False}
    ${COUNT}  Get Imap Mail Count  useSsl=${False}
    Should Be Equal As Integers  ${COUNT}  ${1}
    Send Mail    @{FIRST_MAIL}
    ${COUNT}  Get Imap Mail Count  useSsl=${False}
    Should Be Equal As Integers  ${COUNT}  ${2}
    ${EXP_ERR_MSG}  Format String   ${InboxNotEmpty}   Imap
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Imap Inbox Should Be Empty  useSsl=${False}
    Delete Every Imap Mail

Set Both Imap Ports
    [Tags]    unit  imap  imap_nossl
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Imap Ports   ${ENV_IMAP_SSL_PORT}  ${ENV_IMAP_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Imap Ports    3331  3332
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Imap   3332
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Imap Mail  useSsl=${False}
    Set Both Imap Ports   ${ENV_IMAP_SSL_PORT}  ${ENV_IMAP_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}

Set Imap Port
    [Tags]    unit  imap  imap_nossl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Port   ${ENV_IMAP_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Port    3331
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Imap   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Imap Mail  useSsl=${False}
    Set Imap Port   ${ENV_IMAP_PORT}
    ${MIME}  Open Latest Imap Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}