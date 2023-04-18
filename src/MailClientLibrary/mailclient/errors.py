class MailClientError(AttributeError):
    """
    Error message handler
    """
    GenericError = "{}"
    Name = "Text"
    InboxNotEmpty = "{} inbox is not empty"
    FalseCridentials = "The given '{}' username: '{}' or password: '{}' is false"
    FalseHostOrPort = "The given '{}' host: '{}' or port: '{}' is false"
    FalseHost = "The given '{}' host: '{}' is false"
    FalsePort = "The given '{}' port: '{}' is false"
    MailNotSent = "The Mail to '{}' could not be sent"

    @staticmethod
    def raise_mail_client_error(message):
        """
        Static method usage to raise mail client exceptions

        Args:
            message (String): Error message to raise.
        """
        raise MailClientError(message)