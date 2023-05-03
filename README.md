# MailClientLibrary

The [`MailClientLibrary`](https://github.com/noubar/RobotFramework-MailClientLibrary) is a Python based library for the [Robot Framework](https://robotframework.org/) that provides keywords to interact with mail clients using IMAP, POP3, and SMTP protocols.
The library officially supports Python >= 3.7 and can be installed using pip.

## Installation

To install the library, run the following command:

```
pip install robotframework-mailclient
```

## Usage

After installing the library, you can import it into your Robot Framework test suite using the following line:

```
*** Settings ***
Library  MailClientLibrary
```

Or provide optionally the following arguments:

```
Library  MailClientLibrary  Username=UsernameStr  Password=PasswordStr  MailServerAddress=127.0.0.1  ImapPort=[993,143]  Pop3Port=[995,110]  SmtpPort=[587,26]
```

If these not provided as arguments it should be set during the test using provided setter keywords look in Keyword Documentation.
The `MailClientLibrary` provides keywords for interacting with mail clients using IMAP, POP3, and SMTP protocols.

### Supported protocols

The `MailClientLibrary` supports the following protocols:

- IMAP
- POP3
- SMTP

### SSL support

The `MailClientLibrary` supports SSL for all protocols and is enabled per default. To disable SSL, simply use the `UseSsl=True` argument when using any keyword.

## Keyword Documentation

[Page](https://noubar.github.io/RobotFramework-MailClientLibrary/)

## License

The `MailClientLibrary` is released under the [MIT License](https://opensource.org/licenses/MIT).
