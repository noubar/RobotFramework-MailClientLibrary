from robotlibcore import DynamicCore
from .version import VERSION
from .keywords import (ImapKeywords,
                                   Pop3Keywords,
                                   SmtpKeywords,
                                   SetterKeywords)

class MailClientLibrary(DynamicCore):
    """
    MailClientLibrary is a Robot Framework library for sending and receiving mails.

    This library uses python's imaplib poplib and smtplib libraries.

    = Getting started =

    == Library init ==

    MailClientLibrary excepts the username and password as init arguments.
    These values will be used for authentication for all protocols.
    These settings could be set at library inititialization as follow in the settings section of robot file.
    Example:
    | Library | MailClientLibrary | Username=UsernameStr | Password=PasswordStr |

    MailClientLibrary contains by default the following port numbers:
    | = Protocol = | = SSL = | = No SSL = |
    |     IMAP     |   993   |    143     |
    |     POP3     |   995   |    110     |
    |     SMTP     |   465   |     25     |
    These settings could be changed at library inititialization as follow in the settings section of robot file.
    Example:
    | Library | MailClientLibrary | ImapPort=[993,143] | Pop3Port=[995,110] | SmtpPort=[587,26] |

    MailClientLibrary contains by default the following mail server address: 127.0.0.1.
    These settings could be changed at library inititialization as follow in the settings section of robot file.
    Example:
    | Library | MailClientLibrary | MailServerAddress=127.0.0.1 |

    MailClientLibrary can be imported with several arguments.
    All Avialable Args:
      | Username | The user id, which will initially set for all protocols |
      | Password | The user password, which will initially set for all protocols |
      | MailServerAddress | The newtwork address of the mail server to be connected.
                            currently supports only one MailServerAddress for all protocols |
      | ImapPorts | The imap communication port numbers: [<ssl>,<no ssl>] |
      | Pop3Ports | The pop3 communication port numbers: [<ssl>,<no ssl>] |
      | SmtpPorts | The smtp communication port numbers: [<ssl>,<no ssl>] |
    Example:
    | Library | MailClientLibrary | Username=UsernameStr | Password=PasswordStr | MailServerAddress=127.0.0.1 | ImapPort=[993,143] | Pop3Port=[995,110] | SmtpPort=[587,26] |

    == Changing valuse of init variables ==

    Protocol port numbers are changable during testing through the following provided keywords:
    Example:
    | Set Both IMAP Ports | 993 | 143 |
    | Set Both POP3 Ports | 995 | 110 |
    | Set Both SMTP Ports | 465 | 25  |

    ### OR INDIVIDUALY ###

    | Set IMAP Port | 143 |
    | Set IMAP Ssl Port | 993 |
    | Set POP3 Port | 143 |
    | Set POP3 Ssl Port | 993 |
    | Set SMTP Port | 143 |
    | Set SMTP Ssl Port | 993 |

    Mail Server Address is changable during testing through the following provided keywords:
    Example:
    | Set Mail Server Address | AddressStr |

    Username and Password are changable during testing through the following provided keywords:
    Set Mail Username And Password  NameStr  PassStr  
    This keyword sets a common cridentials for all protocols. It can also be set seperately as follow:
    Example:
    | Set IMAP Username And Password | NameStr | PassStr |   # Receiver's mailbox cridentials
    | Set POP3 Username And Password | NameStr | PassStr |   # Receiver's mailbox cridentials
    | Set SMTP Username And Password | NameStr | PassStr |   # Sender's mail cridentials

    """
    ROBOT_LIBRARY_VERSION = VERSION
    ROBOT_LIBRARY_SCOPE = "Global"
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, Username="user", Password="pass", MailServerAddress="127.0.0.1", ImapPorts=[993,143], Pop3Ports=[995,110], SmtpPorts=[465,25]):
        libraries = [
          ImapKeywords(),
          Pop3Keywords(),
          SmtpKeywords(),
          SetterKeywords(Username, Password, MailServerAddress, ImapPorts, Pop3Ports, SmtpPorts),
        ]
        DynamicCore.__init__(self, libraries)