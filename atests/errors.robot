*** Variables ***
${InboxNotEmpty}     MailClientError: {0} inbox is not empty
${FalseCridentials}  MailClientError: The given '{0}' username: '{1}' or password: '{2}' is false
${FalseHostOrPort}   MailClientError: The given host: '{0}' or port: '{1}' is false
${FalseHost}  MailClientError: The given '{0}' host: '{1}' is false
${FalsePort}  MailClientError: The given '{0}' port: '{1}' is false
${MailNotSent}       The Mail to '{0}' could not be sent
