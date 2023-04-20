*** Settings ***
Library    MailClientLibrary
Library    OperatingSystem
Library    Process
Library    String
Library    OperatingSystem
Library    dockerControl.py
Resource   errors.robot
Variables  envars.py

*** Variables ***
${DOMAIN}        @mail.com
${SUBJECT}       I am the subject
${TEXT}          I am the text
${SUBJECT1}      ${SUBJECT}1
${TEXT1}         ${TEXT}1
${SUBJECT2}      ${SUBJECT}2
${TEXT2}         ${TEXT}2
${SUBJECT3}      ${SUBJECT}3
${TEXT3}         ${TEXT}3
${NOSUBJECT}     ${SUBJECT} does not exist
${NOTEXT}        ${TEXT} does not exist
${SENDERMAIL}    ${ENV_SMTP_USER}${DOMAIN}
${NOMAIL}        user@doesnot.exist

# RECEIVERMAIL Should be chosen in every suite seperatly
@{FIRST_MAIL}     ${SENDERMAIL}    ${RECEIVERMAIL}  ${SUBJECT1}   ${TEXT1}
@{SECOND_MAIL}    ${SENDERMAIL}    ${RECEIVERMAIL}  ${SUBJECT2}   ${TEXT2}
@{THIRD_MAIL}     ${SENDERMAIL}    ${RECEIVERMAIL}  ${SUBJECT3}   ${TEXT3}

@{LOOP_MAIL}      ${RECEIVERMAIL}  ${RECEIVERMAIL}  ${SUBJECT}LOOP    ${TEXT}LOOP    # Same sender and same receiver
@{NOS_MAIL}       ${NOMAIL}        ${RECEIVERMAIL}  ${SUBJECT}NOS     ${TEXT}NOS     # False sender
@{NOR_MAIL}       ${RECEIVERMAIL}  ${NOMAIL}        ${SUBJECT}NOR     ${TEXT}NOR     # False receiver
@{NOSNOR_MAIL}    ${NOMAIL}        ${NOMAIL}        ${SUBJECT}NOSNOR  ${TEXT}NOSNOR  # False sender and false receiver

*** Keywords ***
Mail Should Contain
    [Documentation]  Proves all the needed parameters of the mail
    ...              The mail is given as string
    [Arguments]  ${mail}  ${sender}  ${receiver}  ${subject}  ${text}
    Should Contain   ${mail}    From: ${sender}
    Should Contain   ${mail}    To: ${receiver}
    Should Contain   ${mail}    Subject: ${subject}
    Should Contain   ${mail}    \n${text}

Set All Mail Server Configs
    [Documentation]  Sets all the mail configs using variables from vars.py
    Set Imap Username And Password  ${ENV_IMAP_USER}      ${ENV_IMAP_PASS}
    Set Pop3 Username And Password  ${ENV_POP3_USER}      ${ENV_POP3_PASS}
    Set Smtp Username And Password  ${ENV_SMTP_USER}      ${ENV_SMTP_PASS}
    Set Mail Server Address         ${ENV_MAIL_SERVER}
    Set Both Imap Ports             ${ENV_IMAP_SSL_PORT}  ${ENV_IMAP_PORT}
    Set Both Pop3 Ports             ${ENV_POP3_SSL_PORT}  ${ENV_POP3_PORT}
    Set Both Smtp Ports             ${ENV_SMTP_SSL_PORT}  ${ENV_SMTP_PORT}
