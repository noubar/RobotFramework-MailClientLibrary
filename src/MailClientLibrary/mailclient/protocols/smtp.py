import smtplib
# import mimetypes
# import os
# from email.message import EmailMessage
from ..variables import Variables
from ..mail import Mail
from ..errors import MailClientError
# import base64

class Smtp:

    def __init__(self, useSsl:bool):
        """
        Smtp object will be initialized to be used in all class functions.
        """
        if useSsl:
            try:
                self.smtpobj = smtplib.SMTP_SSL(Variables.smtp_mail_server, Variables.smtp_ssl_port)
                # self.smtpobj.ehlo()
            except (smtplib.SMTPException):
                self.smtpobj = smtplib.SMTP(Variables.smtp_mail_server, Variables.smtp_ssl_port)
                self.smtpobj.starttls()
            except(ConnectionRefusedError):
                MailClientError.raise_mail_client_error(MailClientError.FalsePort.format("Smtp",Variables.smtp_ssl_port))
            except(TimeoutError, OSError):
                MailClientError.raise_mail_client_error(MailClientError.FalseHost.format("Smtp",Variables.smtp_mail_server))
            try:
                self.smtpobj.login(str(Variables.smtp_username), str(Variables.smtp_password))
                print("smtp login done")
            except(smtplib.SMTPAuthenticationError):
                MailClientError.raise_mail_client_error(MailClientError.FalseCridentials.format("Smtp",Variables.smtp_username, Variables.smtp_password))
        else: # no ssl
            try:
                self.smtpobj = smtplib.SMTP(Variables.smtp_mail_server, Variables.smtp_port)
            except(TimeoutError):
                MailClientError.raise_mail_client_error(MailClientError.FalseHost.format("Smtp",Variables.smtp_mail_server))
            except(ConnectionRefusedError):
                MailClientError.raise_mail_client_error(MailClientError.FalsePort.format("Smtp",Variables.smtp_port))

    def __del__(self):
        try:
            if self.smtpobj:
                self.smtpobj.quit()
            self.smtpobj = None
        except(AttributeError,smtplib.SMTPServerDisconnected):
            pass

    def delivery_status(recipient, status):
        if status:
            print(f"Delivery to {recipient} failed with status {status}")
        else:
            print(f"Delivery to {recipient} succeeded")
    
    def send_mail(self, senderMail:str, receiverMail:str, subject:str, text:str,cc=None, bcc=None, attachmentPaths=None):
        """
        This function sends a mail using smtp protocol.

        Args:
        | Name | Type | Description |
        | senderMail | String | The mail address to be sent from |
        | receiverMail | String | The mail address to be sent to |
        | subject | String | The subject of the mail |
        | text | String | The body text of the mail |
        | cc | String | The cc mail address |
        | bcc | String | The bcc mail address |

        Return:
            Error occured by sending
        """
        t = self.smtpobj.verify(receiverMail)
        msg = Mail.compose_mail(senderMail, receiverMail, subject, text, cc=cc, bcc=bcc, attachments=attachmentPaths)
        notSent = self.smtpobj.sendmail(senderMail, receiverMail, msg.as_string())
        if notSent != {}:
            MailClientError.raise_mail_client_error(MailClientError.MailNotSent.format(str(list(notSent.keys()))))
        return True