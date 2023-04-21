import poplib
from email import message_from_bytes
from ssl import SSLError
# import email
# from email.header import decode_header
from ..errors import MailClientError
from ..variables import Variables
from enum import Enum

class Pop3:
    class criternia(Enum):
        FROM = "From"
        SUBJECT = "Subject"

    def __init__(self, useSsl:bool):
        """
        Pop3 object will be initialized to be used in all class functions
        """
        if useSsl:
            try:
                self.pop3obj = poplib.POP3_SSL(Variables.pop3_mail_server, Variables.pop3_ssl_port)
            except(ConnectionRefusedError):
                MailClientError.raise_mail_client_error(MailClientError.FalsePort.format("Pop3",Variables.pop3_ssl_port))
            except(TimeoutError,OSError):
                MailClientError.raise_mail_client_error(MailClientError.FalseHost.format("Pop3",Variables.pop3_mail_server))
            except:
                try:
                    self.pop3obj = poplib.POP3(Variables.imap_mail_server, Variables.imap_ssl_port)
                    self.pop3obj.stls()
                except(poplib.error_proto):
                    MailClientError.raise_mail_client_error(MailClientError.FalseHostOrPort.format("Pop3", Variables.pop3_mail_server, Variables.pop3_ssl_port))

        else:
            try:
                self.pop3obj = poplib.POP3(Variables.pop3_mail_server, Variables.pop3_port)
            except(TimeoutError):
                MailClientError.raise_mail_client_error(MailClientError.FalseHost.format("Pop3",Variables.pop3_mail_server))
            except(ConnectionRefusedError):
                MailClientError.raise_mail_client_error(MailClientError.FalsePort.format("Pop3",Variables.pop3_port))
        # login to mail server
        try:
            self.pop3obj.user(Variables.pop3_username)
            self.pop3obj.pass_(Variables.pop3_password)
            print("pop3 login done")
            self.resp, self.mails, self.octets = self.pop3obj.list()
        except:
            MailClientError.raise_mail_client_error(MailClientError.FalseCridentials.format("Pop3",Variables.pop3_username,Variables.pop3_password))
        self.data = []
        for mail in self.mails:
            self.data.append(int(mail[:1].decode()))
        print("pop3 obj created")

    def __del__(self):
        """
        Pop3 object will be destucted and quited
        so the changes can take place, the connetction will be closed and mailbox unlocked
        """
        try:
            if self.pop3obj:
                self.pop3obj.quit()
        except(AttributeError, SSLError):
            pass
        self.pop3obj = None

    def get_mail_count(self):
        if self.is_inbox_empty():
            return 0
        return len(self.data)

    def is_inbox_empty(self):
        """
        This function reads a mail inbox using pop3 protocol
        Return:
            True if inbox is empty
            False if inbox is not empty
        """
        # mails found
        # convert data to a list of email IDs
        if self.data:
            return False
        else:
            return True

    def open_mail_by_criteria(self, criteria:str, value:str, firstOnly=True):
        """
        This function finds the first mail in the initialized imap mailbox with the given subject
        Criteria= "From" or "Subject"  (Case Sensitive)
        Returns the entire mail's mime as string. 
        """
        if self.is_inbox_empty():
            return False
        indexes = self._get_mail_indexes_by_criteria(criteria, value)
        messageTextList = []
        for i in indexes:
            # call mail by index
            byte_lines = self.pop3obj.retr(i)[1]
            messageText = str(message_from_bytes(b'\n'.join(byte_lines)))
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
        if index in self.data:
            byte_lines = self.pop3obj.retr(index)[1]
            messageText = str(message_from_bytes(b'\r\n'.join(byte_lines)))
            return messageText
        return False

    def delete_every_mail(self):
        """
        This function deletes every mail in initialized imap mailbox
        Returns True if any mail is deleted otherwise False
        """
        if self.is_inbox_empty():
            return False
        deleteAny = False
        # retrieve the newest email index number
        # delete the email from pop3 server directly by email index.
        for i in self.data:
            self.pop3obj.dele(i)
            deleteAny = True
        return deleteAny

    def delete_mail_by_criteria(self, criteria, subject, firstOnly=True):
        """
        This function reads an email inbox using imap protocol and deletes the email with corresponding subject.
        Returns True if any mail is deleted otherwise False
        """
        deletedAny = False
        indexes = self._get_mail_indexes_by_criteria(criteria, subject)
        for index in indexes:
            self.pop3obj.dele(index)
            deletedAny = True
            if firstOnly:
                return True
        return deletedAny

    def delete_mail_by_index(self, index:int):
        """
        This function reads an email inbox using imap protocol and deletes the email with corresponding subject.
        """
        if self.is_inbox_empty():
            return False
        if index in self.data:
            self.pop3obj.dele(index)
            return True
        return False

    def _get_mail_indexes_by_criteria(self, criteria, value):
        """ This function iterates only through subjects of the mails in initialized imap mailbox
        and returns the first index found with the given subject or sender
        Args:
        Creteria = "Subject" or "From"  (CaseSensible)
        Value = <subjectText> or <SendersMailAdress>
        Example Return value:
        [1, 3]
        """
        if self.is_inbox_empty():
            return []
        indexList = []
        for i in self.data:
            # call mail by index
            byte_lines = self.pop3obj.retr(i)[1]
            mail_content = message_from_bytes(b'\n'.join(byte_lines))
            a = mail_content[criteria]
            if value in mail_content.get(criteria):
                indexList.append(i)
        return indexList