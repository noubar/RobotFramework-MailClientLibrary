*** Settings ***
Documentation   Test suite for Pop3 keywords and Pop3 related Setter keywords.
...    
...    | Test Case Name                       | Tested Keyword                    | Return Case/Value |
...    | Open And Delete Pop3 Mail By Subject | Open Pop3 Mail By Subject         | True,False        |
...    |                                      | Delete Pop3 Mail By Subject       | True,False        |
...    | Open And Delete Pop3 Mail By Sender  | Open Pop3 Mail By Sender          | True,False        |
...    |                                      | Delete Pop3 Mail By Sender        | True,False        |
...    | Open And Delete Pop3 Mail By Index   | Open Pop3 Mail By Index           | True,False        |
...    |                                      | Delete Pop3 Mail By Index         | True,False        |
...    | Open And Delete Latest Pop3 Mail     | Open Latest Pop3 Mail             | True,False        |
...    |                                      | Delete Latest Pop3 Mail           | True,False        |
...    | Delete Every Pop3 Mail By Sender     | Delete Every Pop3 Mail By Sender  | True,False        |
...    | Delete Every Pop3 Mail By Subject    | Delete Every Pop3 Mail By Subject | True,False        |
...    | Delete Latest Pop3 Mail              | Delete Latest Pop3 Mail           | True,False        |
...    | Delete Every Pop3 Mail               | Delete Every Pop3 Mail            | True,False        |
...    | Is Pop3 Inbox Empty                  | Is Pop3 Inbox Empty               | True,False        |
...    |                                      | Pop3 Inbox Should Be Empty        | No Error,Error    |
...    |                                      | Get Pop3 Mail Count               | True,False        |
...    | Set Pop3 Username and Password       | Set Pop3 Username and Password    | True,No Error     |
...    | Set Pop3 Server Address              | Set Pop3 Server Address           | True,No Error     |
...    | Set Both Pop3 Ports                  | Set Both Pop3 Ports               | True,No Error     |
...    | Set Pop3 Ssl Port                    | Set Pop3 Ssl Port                 | True,No Error     |
...    

Resource        common.robot
Suite Setup     Run Keywords
...             Start Mail Server Docker
...  AND        Set All Mail Server Configs
Suite Teardown  Stop Mail Server Docker

Test Setup      Run Keywords
...             Set All Mail Server Configs
...  AND        Delete Every Pop3 Mail

*** Variables ***
${RECEIVERMAIL}  ${ENV_POP3_USER}${DOMAIN}

*** Test Cases ***
Open And Delete Pop3 Mail By Subject
    [Tags]    unit  pop3  pop3_ssl
    ${MIME}    Open Pop3 Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Delete Pop3 Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}
    ${MIME}    Open Pop3 Mail By Subject  ${SUBJECT1}
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Pop3 Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${STATUS}  ${True}

Open And Delete Pop3 Mail By Sender
    [Tags]    unit  pop3  pop3_ssl
    ${MIME}    Open Pop3 Mail By Sender  ${SENDERMAIL}
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Pop3 Mail By Sender    ${SENDERMAIL}
    Should Be Equal    ${STATUS}    ${False}
    Send Mail  @{FIRST_MAIL}
    ${MIME}     Open Pop3 Mail By Sender  ${SENDERMAIL}
    Mail Should Contain    ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Pop3 Mail By Sender    ${SENDERMAIL}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Pop3 Mail By Index
    [Tags]    unit  pop3  pop3_ssl
    ${MIME}    Open Pop3 Mail By Index    ${1}
    Should Be Equal  ${MIME}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${1}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}
    ${MIME}    Open Pop3 Mail By Index  ${1}
    Mail Should Contain  ${MIME}    @{FIRST_MAIL}
    ${STATUS}  Delete Pop3 Mail By Index  ${2}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${2}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${-1}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${1}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Latest Pop3 Mail
    [Tags]    unit  pop3  pop3_ssl
    ${MIME}    Open Latest Pop3 Mail
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Latest Pop3 Mail
    Should Be Equal    ${STATUS}    ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Open Latest Pop3 Mail
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Latest Pop3 Mail
    Should Be Equal  ${STATUS}  ${True}

Delete Every Pop3 Mail By Subject
    [Tags]    unit  pop3  pop3_ssl
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{SECOND_MAIL}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}
    Should Be Equal  ${MIME}  ${False}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT2}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT2}
    Should Be Equal  ${MIME}  ${False}

Delete Every Pop3 Mail By Sender
    [Tags]    unit  pop3  pop3_ssl
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{SECOND_MAIL}
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}
    Should Be Equal  ${MIME}  ${False}

Delete Every Pop3 Mail
    [Tags]    unit  pop3  pop3_ssl
    ${MIME}    Delete Every Pop3 Mail
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Pop3 Mail
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}
    Send Mail    @{SECOND_MAIL}
    ${MIME}    Delete Every Pop3 Mail
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Pop3 Mail
    Should Be Equal  ${MIME}  ${False}

Is Pop3 Inbox Empty
    [Tags]    unit  pop3  pop3_ssl
    Pop3 Inbox Should Be Empty
    ${STATUS}  Is Pop3 Inbox Empty
    Should Be Equal  ${STATUS}  ${True}
    ${COUNT}  Get Pop3 Mail Count
    Should Be Equal As Integers  ${COUNT}  ${0}
    Send Mail    @{FIRST_MAIL}
    ${STATUS}  Is Pop3 Inbox Empty
    Should Be Equal  ${STATUS}  ${False}
    ${COUNT}  Get Pop3 Mail Count
    Should Be Equal As Integers  ${COUNT}  ${1}
    Send Mail    @{FIRST_MAIL}
    ${COUNT}  Get Pop3 Mail Count
    Should Be Equal As Integers  ${COUNT}  ${2}
    ${EXP_ERR_MSG}  Format String   ${InboxNotEmpty}   Pop3
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Pop3 Inbox Should Be Empty
    Delete Every Pop3 Mail

Set Pop3 Username and Password
    [Tags]    unit  pop3  pop3_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Username and Password   ${ENV_POP3_USER}   ${ENV_POP3_PASS}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Username and Password   ${ENV_ALT_USER}   ${ENV_ALT_PASS}
    ${MIME}  Open Latest Pop3 Mail
    Should Be Equal  ${MIME}  ${False}
    Set Pop3 Username and Password   ${ENV_POP3_USER}   ${ENV_POP3_PASS}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Delete Every Pop3 Mail
    Set Pop3 Username and Password   WrongUser    WrongPass
    ${EXP_ERR_MSG}  Format String   ${FalseCridentials}   Pop3  WrongUser  WrongPass
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Pop3 Inbox Should Be Empty

Set Pop3 Server Address
    [Tags]    unit  pop3  pop3_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Server Address    127.0.0.1
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Server Address    10.0.0.2
    ${EXP_ERR_MSG}  Format String   ${FalseHost}   Pop3  10.0.0.2
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Pop3 Mail
    Set Pop3 Server Address    127.0.0.1
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}

Set Both Pop3 Ports
    [Tags]    unit  pop3  pop3_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Pop3 Ports   ${ENV_POP3_SSL_PORT}  ${ENV_POP3_PORT}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Pop3 Ports    3331  3332
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Pop3   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Pop3 Mail
    Set Both Pop3 Ports   ${ENV_POP3_SSL_PORT}  ${ENV_POP3_PORT}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}

Set Pop3 Ssl Port
    [Tags]    unit  pop3  pop3_ssl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Ssl Port   ${ENV_POP3_SSL_PORT}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Ssl Port    3331
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Pop3   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Pop3 Mail
    Set Pop3 Ssl Port   ${ENV_POP3_SSL_PORT}
    ${MIME}  Open Latest Pop3 Mail
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}