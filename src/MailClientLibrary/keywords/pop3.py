from ..mailclient.protocols.pop3 import Pop3
from ..mailclient.errors import MailClientError
from robot.api.deco import keyword
# ToDo Add logger.infos

class Pop3Keywords:

    @keyword
    def open_pop3_mail_by_subject(self, subject, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        This keyword reads the mails and returns the raw source of
        the first found mail in the mailbox with the given subject

        Args:
        | Name    | Type    | Description                                           |
        | subject | String  | The subject of the mail to be opened                  |
        | useSsl  | Boolean | Whether to use SSL or not to connect to Pop3 protocol |

        Return:
        | Type   | Description                                              |
        | String | The MIME content of the first mail found by the subject  |

        Examples:
        | ${mail_content} | Open Pop3 Mail By Subject | <subject> |
        | Should Contain  | ${mail_content} | <text> |
        """
        return Pop3(bool(useSsl)).open_mail_by_criteria("SUBJECT", subject)

    @keyword
    def open_pop3_mail_by_sender(self, sender, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        This keyword reads the mails and returns the raw source of
        the first found mail in the mailbox with the given sender

        Args:
        | Name    | Type    | Description                                           |
        | sender  | String  | The sender of the mail to be opened                   |
        | useSsl  | Boolean | Whether to use SSL or not to connect to Pop3 protocol |

        Return:
        | Type   | Description                                             |
        | String | The MIME content of the first mail found by the sender  |

        Examples:
        | ${mail_content} | Open Pop3 Mail By Sender | <sender> |
        | Should Contain | ${mail_content} | <text> |
        """
        return Pop3(bool(useSsl)).open_mail_by_criteria("FROM", sender)

    @keyword
    def open_pop3_mail_by_index(self, index, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        This keyword reads the mails and returns the raw source of
        the mail in the mailbox at the given index

        Args:
        | Name    | Type            | Description                                           |
        | index   | String (number) | The index of the mail to be opened                    |
        | useSsl  | Boolean         | Whether to use SSL or not to connect to Pop3 protocol |

        Return:
        | Type   | Description                                           |
        | String | The MIME content of the mail in mailbox at the index  |

        Examples:
        | ${mail_content} | Open Pop3 Mail By Index | <index> |
        | Should Contain | ${mail_content} | <text> |
        """
        return Pop3(bool(useSsl)).open_mail_by_index(index)

    @keyword
    def open_latest_pop3_mail(self, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        This keyword reads the mails and returns the raw source of
        the latest sent mail in the mailbox

        Args:
        | Name   | Type    | Description                                           |
        | useSsl | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type   | Description                                       |
        | String | The MIME content of the first mail in the mailbox |

        Examples:
        | ${mail_content} | Open Latest Pop3 Mail |
        | Should Contain | ${mail_content} | <text> |
        """
        return self.open_pop3_mail_by_index(self.get_pop3_mail_count(useSsl), useSsl)

    @keyword
    def delete_pop3_mail_by_subject(self, subject, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and deletes the first found mail in the mailbox with the given subject

        Args:
        | Name    | Type    | Description                                           |
        | subject | String  | The subject of the mail to be deleted                 |
        | useSsl  | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                                   |
        | Boolean | True if the mail found and deleted else False |

        Examples:
        | ${status} | Delete Pop3 Mail By Subject | <subject> |
        | Should Be True | ${status} |
        """
        return Pop3(bool(useSsl)).delete_mail_by_criteria("SUBJECT", subject)

    @keyword
    def delete_every_pop3_mail_by_subject(self, subject, useSsl=True):
        """
        This keyword reaches the mail server using Imap protocol
        and deletes every found mail in the mailbox with the given subject

        Args:
        | Name    | Type    | Description                                           |
        | subject | String  | The subject of the mails to be deleted                |
        | useSsl  | Boolean | Whether to use ssl or not to connect to Imap protocol |

        Return:
        | Type    | Description                                   |
        | Boolean | True if any mail found and deleted else False |

        Examples:
        | ${status} | Delete Every Imap Mail By Subject | <subject> |
        | Should Be True | ${status} |
        """
        return Pop3(bool(useSsl)).delete_mail_by_criteria("SUBJECT", subject, firstOnly=False)

    @keyword
    def delete_pop3_mail_by_sender(self, sender, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and deletes the first found mail in the mailbox with the given sender

        Args:
        | Name    | Type    | Description                                           |
        | sender  | String  | The sender of the mail to be deleted                  |
        | useSsl  | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                                   |
        | Boolean | True if the mail found and deleted else False |

        Examples:
        | ${status} | Delete Pop3 Mail By Sender | <Sender> |
        | Should Be True | ${status} |
        """
        return Pop3(bool(useSsl)).delete_mail_by_criteria("FROM", sender)

    @keyword
    def delete_every_pop3_mail_by_sender(self, sender, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and deletes every found mail in the mailbox with the given sender

        Args:
        | Name   | Type    | Description                                           |
        | sender | String  | The sender of the mails to be deleted                 |
        | useSsl | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                                   |
        | Boolean | True if any mail found and deleted else False |

        Examples:
        | ${status} | Delete Every Pop3 Mail By Sender | <sender> |
        | Should Be True | ${status} |
        """
        return Pop3(bool(useSsl)).delete_mail_by_criteria("FROM", sender, firstOnly=False)

    @keyword
    def delete_pop3_mail_by_index(self, index, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and deletes the mail at the given index

        Args:
        | Name   | Type            | Description                                           |
        | index  | String (number) | The index number of the mail to be deleted            |
        | useSsl | Boolean         | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                                   |
        | Boolean | True if the mail found and deleted else False |

        Examples:
        | ${status} | Delete Pop3 Mail By Index | <index> |
        | Should Be True | ${status} |
        """
        return Pop3(bool(useSsl)).delete_mail_by_index(int(index))

    @keyword
    def delete_latest_pop3_mail(self, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and deletes the latest mail in mailbox

        Args:
        | Name   | Type    | Description                                           |
        | useSsl | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                                   |
        | Boolean | True if the mail found and deleted else False |

        Examples:
        | ${status} | Delete Latest Pop3 Mail |
        | Should Be True | ${status} |
        """
        return self.delete_pop3_mail_by_index(self.get_pop3_mail_count(useSsl), useSsl)

    @keyword
    def delete_every_pop3_mail(self, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and deletes every found mail in the mailbox

        Args:
        | Name   | Type    | Description                                           |
        | useSsl | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                                   |
        | Boolean | True if any mail found and deleted else False |

        Examples:
        | ${status} | Delete Every Pop3 Mail |
        | Should Be True | ${status} |
        """
        return Pop3(bool(useSsl)).delete_every_mail()

    @keyword
    def is_pop3_inbox_empty(self, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and reads the mailbox

        Args:
        | Name   | Type    | Description                                           |
        | useSsl | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                       |
        | Boolean | False if any mail found else True |

        Examples:
        | ${status} | Is Pop3 Inbox Empty |
        | Should Be True | ${status} |

        See also: `Pop3 Inbox Should Be Empty`
        """
        return Pop3(bool(useSsl)).is_inbox_empty()

    @keyword
    def Pop3_inbox_should_be_empty(self, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and fails if the mailbox is not empty

        Args:
        | Name   | Type    | Description                                           |
        | useSsl | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type    | Description                      |
        | Boolean | True if no mail found else fails |

        Examples:
        | Delete Every Pop3 Mail |
        | Is Pop3 Inbox Empty |

        See also: `Is Pop3 Inbox Empty`
        """
        if not Pop3(bool(useSsl)).is_inbox_empty():
            MailClientError.raise_mail_client_error(MailClientError.InboxNotEmpty.format("Pop3"))

    @keyword
    def get_pop3_mail_count(self, useSsl=True):
        """
        This keyword reaches the mail server using Pop3 protocol
        and fails if the mailbox is not empty

        Args:
        | Name   | Type    | Description                                           |
        | useSsl | Boolean | Whether to use ssl or not to connect to Pop3 protocol |

        Return:
        | Type | Description                          |
        | Int  | The number of mails found in mailbox |

        Examples:
        | ${number} | Get Pop3 Mail Count |
        | Should Be Equal As Integers | ${number} | <number> |

        See also: `Is Pop3 Inbox Empty`
        """
        return Pop3(bool(useSsl)).get_mail_count()

# ToDo
    # mark as read or if marked as read or get count not read