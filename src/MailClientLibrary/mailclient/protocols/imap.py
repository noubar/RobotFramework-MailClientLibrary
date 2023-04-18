import imaplib
from ..variables import Variables
from ..errors import MailClientError
from enum import Enum

class Imap:
    class criternia(Enum):
        FROM = "FROM"
        SUBJECT = "SUBJECT"

    def __init__(self, useSsl:bool):
        """
        Initialize an Imap object and imap mailbox, which will be used by further functions.
        The receiver email account is a constant variable and saved under mailVariables.py file.
        """
        if useSsl:
            try:
                self.imapobj = imaplib.IMAP4_SSL(Variables.imap_mail_server, Variables.imap_ssl_port)
            except(ConnectionRefusedError):
                MailClientError.raise_mail_client_error(MailClientError.FalsePort.format("Imap",Variables.imap_ssl_port))
            except(TimeoutError, OSError):
                MailClientError.raise_mail_client_error(MailClientError.FalseHost.format("Imap",Variables.imap_mail_server))
            except:
                try:
                    self.imapobj = imaplib.IMAP4(Variables.imap_mail_server, Variables.imap_ssl_port)
                    self.imapobj.starttls()
                except:
                    MailClientError.raise_mail_client_error(MailClientError.FalseHostOrPort.format("Imap", Variables.imap_mail_server, Variables.imap_ssl_port))

        else:
            try:
                self.imapobj = imaplib.IMAP4(Variables.imap_mail_server, Variables.imap_port)
            except(TimeoutError):
                MailClientError.raise_mail_client_error(MailClientError.FalseHost.format("Imap",Variables.imap_mail_server))
            except(ConnectionRefusedError):
                MailClientError.raise_mail_client_error(MailClientError.FalsePort.format("Imap",Variables.imap_port))
        # login to server
        try:
            self.imapobj.login(str(Variables.imap_username), str(Variables.imap_password))
        except:
            MailClientError.raise_mail_client_error(MailClientError.FalseCridentials.format("Imap",Variables.imap_username,Variables.imap_password))
        print("imap login done")
        # select the inbox as default path
        self.imapobj.select('Inbox')
        self.status, self.data = self.imapobj.search(None, "ALL")

    def __del__(self):
        try:
            if self.imapobj:
                self.imapobj.close()
                self.imapobj.logout()
        except(AttributeError,imaplib.IMAP4.error,imaplib.IMAP4_SSL.error):
            pass
        self.imapobj = None

    def get_mail_count(self):
        if self.is_inbox_empty():
            return 0
        return len(self.data[0].split(b' '))

    def is_inbox_empty(self):
        """
        This function returns True if the initialized imap mailbox is empty otherwise False
        """
        # to get all mails
        # convert data to a list of email IDs
        data = self.data[0].split(b' ')
        # no mail found
        if data ==[b'']:
            return True
        elif len(data) >=1:
            return False

    def open_mail_by_criteria(self, criteria:str, value:str, firstOnly=True):
        """
        This function finds the first mail in the initialized imap mailbox with the given subject
        Criteria= "FROM" or "SUBJECT"
        Returns the entire mail's mime as string. 
        """
        messageTextList = []
        indexes = self._get_mail_indexes_by_criteria(criteria,value)
        for index in indexes:
            tmp, data = self.imapobj.fetch(index, 'BODY.PEEK[]')
            messageText = data[0][1].decode('utf-8')
            if firstOnly:
                return messageText
            messageTextList.append(messageText)
        if messageTextList:
            return messageTextList
        return False

    def open_mail_by_index(self,index:int):
        """
        This function returns the index-th mail raw context from initialized imap mailbox
        Returns False if there is no mail with the given index in mailbox
        """
        if self.is_inbox_empty():
            return False
        num = bytes(str(index), encoding='utf-8')
        if num in self.data[0].split():
            status, data = self.imapobj.fetch(num, 'BODY.PEEK[]')
            messageText = data[0][1].decode('utf-8')
            return messageText
        return False

    def delete_every_mail(self):
        """
        This function deletes every mail in initialized imap mailbox
        Returns True if any mail is deleted otherwise False
        """
        if self.is_inbox_empty():
            return False
        for num in self.data[0].split():
            # mark the mail as deleted
            self.imapobj.store(num, "+FLAGS", "\\Deleted")
            self.imapobj.noop()
        self.imapobj.expunge()
        return True

    def delete_mail_by_criteria(self, criteria, subject, firstOnly=True):
        """
        This function reads an email inbox using imap protocol and deletes the email with corresponding subject.
        Returns True if any mail is deleted otherwise False
        """
        deletedAny = False
        indexes = self._get_mail_indexes_by_criteria(criteria, subject)
        for index in indexes:
            self.imapobj.store(index, "+FLAGS", "\\Deleted")
            self.imapobj.noop()
            deletedAny = True
            if firstOnly:
                self.imapobj.expunge()
                return True
        self.imapobj.expunge()
        return deletedAny

    def delete_mail_by_index(self, index:int):
        """
        This function reads an email inbox using imap protocol and deletes the email with corresponding subject.
        """
        if self.is_inbox_empty():
            return False
        num = bytes(str(index), encoding='utf-8')
        if num in self.data[0].split():
            self.imapobj.store(num, "+FLAGS", "\\Deleted")
            self.imapobj.noop()
            self.imapobj.expunge()
            return True
        return False

    def _get_mail_indexes_by_criteria(self, criteria, value):
        """ This function iterates only through subjects of the mails in initialized imap mailbox
        and returns the first index found with the given subject or sender
        Args:
        Creteria = "SUBJECT" or "FROM"
        Value = <subjectText> or <SendersMailAdress>
        Example Return value:
        [b'1', b'3']
        """
        if self.is_inbox_empty():
            return []
        tmp, data = self.imapobj.search(None, f'({criteria} "{value}")')
        if data[0] != b'':
            return data[0].split(b' ')
        return []
