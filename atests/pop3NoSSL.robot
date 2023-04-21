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
...    | Set Both Pop3 Ports                  | Set Both Pop3 Ports               | No Error          |
...    | Set Pop3 Port                        | Set Pop3 Port                     | No Error          |
...    
...    Unit Tests Are: 
...    | Open And Delete Pop3 Mail By Subject |
...    | Set Both Pop3 Ports |
...    | Set Pop3 Port |
...    
...    all others are extra because they are all tested in ssl test case.

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
    [Tags]    unit  pop3  pop3_nossl
    ${MIME}    Open Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    ${STATUS}  Delete Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}    useSsl=${False}
    ${MIME}    Open Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${STATUS}  ${True}

Open And Delete Pop3 Mail By Sender
    [Tags]    unit_extra  pop3  pop3_nossl
    ${MIME}    Open Pop3 Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Pop3 Mail By Sender    ${SENDERMAIL}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    Send Mail  @{FIRST_MAIL}  useSsl=${False}
    ${MIME}     Open Pop3 Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Mail Should Contain    ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Pop3 Mail By Sender    ${SENDERMAIL}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Pop3 Mail By Index
    [Tags]    unit_extra  pop3  pop3_nossl
    ${MIME}    Open Pop3 Mail By Index    ${1}  useSsl=${False}
    Should Be Equal  ${MIME}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${1}  useSsl=${False}
    Should Be Equal  ${STATUS}  ${False}
    Send Mail  @{FIRST_MAIL}  useSsl=${False}
    ${MIME}    Open Pop3 Mail By Index  ${1}  useSsl=${False}
    Mail Should Contain  ${MIME}    @{FIRST_MAIL}
    ${STATUS}  Delete Pop3 Mail By Index  ${2}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${2}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${-1}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    ${STATUS}  Delete Pop3 Mail By Index  ${1}  useSsl=${False}
    Should Be Equal    ${STATUS}    ${True}

Open And Delete Latest Pop3 Mail
    [Tags]    unit_extra  pop3  pop3_nossl
    ${MIME}    Open Latest Pop3 Mail  useSsl=${False}
    Should Be Equal    ${MIME}    ${False}
    ${STATUS}  Delete Latest Pop3 Mail  useSsl=${False}
    Should Be Equal    ${STATUS}    ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Open Latest Pop3 Mail  useSsl=${False}
    Mail Should Contain  ${MIME}  @{FIRST_MAIL}
    ${STATUS}  Delete Latest Pop3 Mail  useSsl=${False}
    Should Be Equal  ${STATUS}  ${True}

Delete Every Pop3 Mail By Subject
    [Tags]    unit_extra  pop3  pop3_nossl
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{SECOND_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}  useSsl=${False}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT1}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}  
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT2}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Pop3 Mail By Subject  ${SUBJECT2}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}

Delete Every Pop3 Mail By Sender
    [Tags]    unit_extra  pop3  pop3_nossl
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{SECOND_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Pop3 Mail By Sender  ${SENDERMAIL}  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}

Delete Every Pop3 Mail
    [Tags]    unit_extra  pop3  pop3_nossl
    ${MIME}    Delete Every Pop3 Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Pop3 Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    Send Mail    @{SECOND_MAIL}  useSsl=${False}
    ${MIME}    Delete Every Pop3 Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${True}
    ${MIME}    Delete Every Pop3 Mail  useSsl=${False}
    Should Be Equal  ${MIME}  ${False}

Is Pop3 Inbox Empty
    [Tags]    unit_extra  pop3  pop3_nossl
    Pop3 Inbox Should Be Empty
    ${STATUS}  Is Pop3 Inbox Empty  useSsl=${False}
    Should Be Equal  ${STATUS}  ${True}
    ${COUNT}  Get Pop3 Mail Count  useSsl=${False}
    Should Be Equal As Integers  ${COUNT}  ${0}
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${STATUS}  Is Pop3 Inbox Empty  useSsl=${False}
    Should Be Equal  ${STATUS}  ${False}
    ${COUNT}  Get Pop3 Mail Count  useSsl=${False}
    Should Be Equal As Integers  ${COUNT}  ${1}
    Send Mail    @{FIRST_MAIL}
    ${COUNT}  Get Pop3 Mail Count  useSsl=${False}
    Should Be Equal As Integers  ${COUNT}  ${2}
    ${EXP_ERR_MSG}  Format String   ${InboxNotEmpty}   Pop3
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Pop3 Inbox Should Be Empty  useSsl=${False}
    Delete Every Pop3 Mail

Set Both Pop3 Ports
    [Tags]    unit  pop3  pop3_nossl
    Send Mail    @{FIRST_MAIL}  useSsl=${False}
    ${MIME}  Open Latest Pop3 Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Pop3 Ports   ${ENV_POP3_SSL_PORT}  ${ENV_POP3_PORT}
    ${MIME}  Open Latest Pop3 Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Both Pop3 Ports    3331  3332
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Pop3   3332
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Pop3 Mail  useSsl=${False}
    Set Both Pop3 Ports   ${ENV_POP3_SSL_PORT}  ${ENV_POP3_PORT}
    ${MIME}  Open Latest Pop3 Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}

Set Pop3 Port
    [Tags]    unit  pop3  pop3_nossl
    Send Mail    @{FIRST_MAIL}
    ${MIME}  Open Latest Pop3 Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Port   ${ENV_POP3_PORT}
    ${MIME}  Open Latest Pop3 Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}
    Set Pop3 Port    3331
    ${EXP_ERR_MSG}  Format String   ${FalsePort}   Pop3   3331
    Run Keyword And Expect Error    ${EXP_ERR_MSG}     Open Latest Pop3 Mail  useSsl=${False}
    Set Pop3 Port   ${ENV_POP3_PORT}
    ${MIME}  Open Latest Pop3 Mail  useSsl=${False}
    Mail Should Contain   ${MIME}   @{FIRST_MAIL}