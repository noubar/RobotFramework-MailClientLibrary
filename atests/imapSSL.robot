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
...    | Set Imap Username and Password       | Set Imap Username and Password    | True,No Error     |
...    | Set Imap Server Address              | Set Imap Server Address           | True,No Error     |
...    | Set Both Imap Ports                  | Set Both Imap Ports               | True,No Error     |
...    | Set Imap Ssl Port                    | Set Imap Ssl Port                 | True,No Error     |

Resource        common.robot
Suite Setup     Run Keywords
...             Start Mail Server Docker
...  AND        Set All Mail Server Configs
Suite Teardown  Stop Mail Server Docker

Test Setup      Run Keywords
...             Set All Mail Server Configs
...  AND        Delete Every Imap Mail

*** Variables ***
${RECEIVERMAIL}  ${ENV_IMAP_USER}${DOMAIN}

*** Test Cases ***
Open And Delete Imap Mail By Subject
    [Tags]    unit  imap  imap_ssl
    ${MIME}    Open Imap Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Delete Imap Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}
    ${MIME}    Open Imap Mail By Subject  ${SUBJECT1}
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Imap Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${STATUS}  ${True}

Open And Delete Imap Mail By Sender
    [Tags]    unit  imap  imap_ssl
    ${MIME}    Open Imap Mail By Sender  ${SENDERMAIL}
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Imap Mail By Sender    ${SENDERMAIL}
    Should Be Equal    ${STATUS}    ${False}
    Send Mail  @{FIRST_MAIL}
    ${MIME}     Open Imap Mail By Sender  ${SENDERMAIL}
    Mail Should Contain    ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Imap Mail By Sender    ${SENDERMAIL}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Imap Mail By Index
    [Tags]    unit  imap  imap_ssl
    ${MIME}    Open Imap Mail By Index    ${1}
    Should Be Equal  ${MIME}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${1}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}
    ${MIME}    Open Imap Mail By Index  ${1}
    Mail Should Contain  ${MIME}    @{FIRST_MAIL}
    ${STATUS}  Delete Imap Mail By Index  ${2}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${2}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${-1}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Imap Mail By Index  ${1}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Latest Imap Mail
    [Tags]    unit  imap  imap_ssl
    ${MIME}    Open Latest Imap Mail
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Latest Imap Mail
    Should Be Equal    ${STATUS}    ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Open Latest Imap Mail
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Latest Imap Mail
    Should Be Equal  ${STATUS}  ${True}

Delete Every Imap Mail By Subject
    [Tags]    unit  imap  imap_ssl
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{SECOND_MAIL}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${False}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT2}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Imap Mail By Subject  ${SUBJECT2}
    Should Be Equal  ${MIME}  ${False}

Delete Every Imap Mail By Sender
    [Tags]    unit  imap  imap_ssl
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{SECOND_MAIL}
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Imap Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${False}

Delete Every Imap Mail
    [Tags]    unit  imap  imap_ssl
    ${MIME}    Delete Every Imap Mail
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Imap Mail
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{SECOND_MAIL}
    ${MIME}    Delete Every Imap Mail
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Imap Mail
    Should Be Equal  ${MIME}  ${False}

Is Imap Inbox Empty
    [Tags]    unit  imap  imap_ssl
    Imap Inbox Should Be Empty
    ${STATUS}  Is Imap Inbox Empty
    Should Be Equal  ${STATUS}  ${True}
    ${COUNT}  Get Imap Mail Count
    Should Be Equal As Integers  ${COUNT}  ${0}
    Send Mail    @{FIRST_MAIL}
    ${STATUS}  Is Imap Inbox Empty
    Should Be Equal  ${STATUS}  ${False}
    ${COUNT}  Get Imap Mail Count
    Should Be Equal As Integers  ${COUNT}  ${1}
    Send Mail    @{FIRST_MAIL}
    ${COUNT}  Get Imap Mail Count
    Should Be Equal As Integers  ${COUNT}  ${2}
    ${EXP_ERR_MSG}  Format String   ${InboxNotEmpty}   Imap
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Imap Inbox Should Be Empty
    Delete Every Imap Mail

Set Imap Username and Password
    [Tags]    unit  imap  imap_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Username and Password   ${ENV_IMAP_USER}   ${ENV_IMAP_PASS}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Username and Password   ${ENV_ALT_USER}   ${ENV_ALT_PASS}
    ${MIME}  Open Latest Imap Mail
    Should Be Equal  ${MIME}  ${False}
    Set Imap Username and Password   ${ENV_IMAP_USER}   ${ENV_IMAP_PASS}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Delete Every Imap Mail
    Set Imap Username and Password   WrongUser    WrongPass
    ${EXP_ERR_MSG}  Format String   ${FalseCridentials}   Imap  WrongUser  WrongPass
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Imap Inbox Should Be Empty

Set Imap Server Address
    [Tags]    unit  imap  imap_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Server Address    127.0.0.1
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Server Address    10.0.0.2
    ${EXP_ERR_MSG}  Format String   ${FalseHost}   Imap  10.0.0.2
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Imap Mail
    Set Imap Server Address    127.0.0.1
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}

Set Both Imap Ports
    [Tags]    unit  imap  imap_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Imap Ports   ${ENV_IMAP_SSL_PORT}  ${ENV_IMAP_PORT}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Imap Ports    3331  3332
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Imap   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Imap Mail
    Set Both Imap Ports   ${ENV_IMAP_SSL_PORT}  ${ENV_IMAP_PORT}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}

Set Imap Ssl Port
    [Tags]    unit  imap  imap_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Ssl Port   ${ENV_IMAP_SSL_PORT}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Imap Ssl Port    3331
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Imap   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Imap Mail
    Set Imap Ssl Port   ${ENV_IMAP_SSL_PORT}
    ${MIME}  Open Latest Imap Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}