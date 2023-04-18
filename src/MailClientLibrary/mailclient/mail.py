from enum import Enum
from email.message import EmailMessage
import os
import mimetypes

class Mail:

    class Alternative:
        class Subtype(Enum):
            """
            "plain": Plain text, no formatting (default).
            "html": Hypertext Markup Language.
            "enriched": Rich text format.
            "richtext": Rich text format (alternative to "enriched").
            "mixed": Message with multiple parts, of different types (e.g. text and image).
            "related": Message with an HTML body that refers to images and other content within the message.
            "alternative": Message with multiple parts, of different types, but only one should be displayed (e.g. text and HTML).
            """
            plain = 'plain'
            html = 'html'
            enriched = 'enriched'
            richtext = 'richtext'
            mixed = 'mixed'
            related = 'related'
            alternative = 'alternative'

        def __init__(self, body: str, subtype: Subtype = Subtype.plain):
            self.body = body
            self.subtype = subtype.value

        
    @staticmethod
    def compose_mail(sender, receiver, subject:str, body_text=None, alternative=None,
                cc=None, bcc=None, attachments=[]):
        """
        Args:
        | Name | Type | Description |
        | sender | String | The sender mail address |
        | receiver | String/stringList | The receiver mail address(s) |
        | subject | String | The mail subject |
        | body_text | String | The mail body content in form of plaintext|
        | alternative | Alternative | The alternative mail body content in form of alternative.subtype |
        | attachments | String/stringList  | The paths of attachments to be added to mail |
        | cc | String/stringList | The cc mail address |
        | bcc | String/stringList | The bcc mail addresse |
        Return:
            EmailMessage() instance with given arguments
        """
        if isinstance(receiver, str):
            receiver = [receiver]
        if isinstance(cc, str):
            cc = [cc]
        if isinstance(bcc, str):
            bcc = [bcc]
        if isinstance(attachments, str):
            attachments = [attachments]
        # Create the email message object
        msg = EmailMessage()
        # Set the message headers
        msg['From'] = sender
        msg['To'] = ', '.join(receiver)
        msg['Subject'] = subject
        # Set the message body
        if not alternative:
            msg.set_content(body_text, subtype='plain')
        else:
            msg.set_content(body_text, subtype='plain')
            msg.add_alternative(alternative.body, subtype=alternative.subtype)
        # Set the CC and BCC recipients, if any
        if cc is not None:
            msg['Cc'] = ', '.join(cc)
        if bcc is not None:
            msg['Bcc'] = ', '.join(bcc)
        # Add any attachments, if any
        if attachments is not None:
            for attachmentPath in attachments:
                with open(attachmentPath, 'rb') as f:
                    filename = os.path.basename(attachmentPath)
                    # guess the content type based on the file's extension.
                    ctype, encoding = mimetypes.guess_type(attachmentPath)
                    if ctype is None or encoding is not None:
                        ctype = 'application/octet-stream'
                    maintype, subtype = ctype.split('/', 1)
                    attachment_data = f.read()
                    msg.add_attachment(attachment_data, maintype=maintype, subtype=subtype, filename=filename)
        return msg