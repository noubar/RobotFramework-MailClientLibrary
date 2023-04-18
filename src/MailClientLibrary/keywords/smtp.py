from ..mailclient.protocols.smtp import Smtp
from ..mailclient.errors import MailClientError
from robot.api.deco import keyword
from ..mailclient.variables import Variables
# ToDo Add logger.infos

class SmtpKeywords:

    @keyword
    def send_mail(self,  senderMail:str, receiverMail:str, subject:str, text:str, cc=None, bc=None, attachmentFullpath=None, useSsl=True):
        """
        This Keyword sends a mail using smtp protocol.
        The mail contains only plaintext. It can also be empty.

        Args:
        | Name | Type | Description |
        | senderMail | String | The mail address of the sender. The smtp username or random |
        | receiverMail | String | The mail address of the receiver |
        | subject | String | The subject of the mail to be sent |
        | text | String | The body Text of the mail to be sent |
        | cc | String | The cc mail address |
        | bcc | String | The bcc mail address |
        | attachmentFullpath | String | The path of the attachment to be sent within the mail|
        | useSsl | Boolean | wheather to use ssl or not to connect |

        Return:
        | text | The first text of mail found by subject |

        Examples:
        | ${Mail_Text} | Send Mail | <Subject> |
        | Should Be True | ${Mail_Text} |
        """
        return Smtp(bool(useSsl)).send_mail(senderMail, receiverMail, subject, text, cc, bc, attachmentFullpath)

    # ToDo reply and reply all and forward 
    # reply/reply all/forward by subject
    # reply/reply all/forward by sender
    # reply/reply all/forward by index
