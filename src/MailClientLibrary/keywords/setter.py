from robot.api.deco import keyword
from ..mailclient.variables import Variables

class SetterKeywords:
    def __init__(self,MailUsername:str, MailPassword:str, MailServerAddress:str, ImapPorts:list, Pop3Ports:list, SmtpPorts:list):
        self.set_mail_username_and_password(MailUsername, MailPassword)
        self.set_mail_server_address(MailServerAddress)
        # set all initial ports
        self.set_both_imap_ports(int(ImapPorts[0]),int(ImapPorts[1]))
        self.set_both_pop3_ports(int(Pop3Ports[0]),int(Pop3Ports[1]))
        self.set_both_smtp_ports(int(SmtpPorts[0]),int(SmtpPorts[1]))

    @keyword
    def set_mail_username_and_password(self,username:str, password:str):
        """
        This Keyword is a setter keyword to set mail username and password
        These will be used as login cridential for all three mail protocls
        (Imap, Pop3, Smtp)

        Args:
        | Name     | Type    | Description                                    |
        | username | String  | The Username needed to login to mail protocols |
        | password | Boolean | The Password needed to login to mail protocols |

        Return:
        | Boolean | True |

        Examples:
        | Set Mail Username And Password | <User> | <Pass> |

        See also: `Set Imap Username and Password`, `Set Pop3 Username and Password`, `Set Smtp Username and Password`
        """
        self.set_imap_username_and_password(username,password)
        self.set_pop3_username_and_password(username,password)
        self.set_smtp_username_and_password(username,password)
        return True

    @keyword
    def set_imap_username_and_password(self,username:str, password:str):
        """
        This Keyword is a setter keyword to set Imap username and password
        These will be used as login cridential for Imap protocol only
        This means it can be set three different login cridentials for every protocol individualy.

        Args:
        | Name     | Type    | Description                                   |
        | username | String  | The Username needed to login to Imap protocol |
        | password | Boolean | The Password needed to login to Imap protocol |

        Return:
        | Boolean | True |

        Examples:
        | Set Imap Username And Password | <User> | <Pass> |

        See also: `Set Mail Username and Password`, `Set Pop3 Username and Password`, `Set Smtp Username and Password`
        """
        Variables.imap_username = str(username)
        Variables.imap_password = str(password)
        return True

    @keyword
    def set_pop3_username_and_password(self,username:str, password:str):
        """
        This Keyword is a setter keyword to set mail username and password
        These will be used as login cridential for Pop3 protocol only
        This means it can be set three different login cridentials for every protocol individualy.
    
        Args:
        | Name     | Type    | Description                                   |
        | username | String  | The Username needed to login to Pop3 protocol |
        | password | Boolean | The Password needed to login to Pop3 protocol |
    
        Return:
        | Boolean | True |

        Examples:
        | Set Pop3 Username And Password | <User> | <Pass> |
    
        See also: `Set Mail Username and Password`, `Set Iamp Username and Password`, `Set Smtp Username and Password`
        """
        Variables.pop3_username = str(username)
        Variables.pop3_password = str(password)
        return True

    @keyword
    def set_smtp_username_and_password(self,username:str, password:str):
        """
        This Keyword is a setter keyword to set Smtp username and password
        These will be used as login cridential for Smtp protocol only
        This means it can be set three different login cridentials for every protocol individualy.

        Args:
        | Name     | Type    | Description                                   |
        | username | String  | The Username needed to login to Smtp protocol |
        | password | Boolean | The Password needed to login to Smtp protocol |

        Return:
        | Boolean | True |

        Examples:
        | Set Smtp Username And Password | <User> | <Pass> |

        See also: `Set Mail Username and Password`, `Set Imap Username and Password`, `Set Pop3 Username and Password`
        """
        Variables.smtp_username = str(username)
        Variables.smtp_password = str(password)
        return True

    @keyword
    def set_mail_server_address(self, address:str):
        """
        This Keyword is a setter keyword to set mail server's host address
        This will be used as host address for mail server of all three protocols
        (Imap, Pop3, Smtp)

        Args:
        | Name    | Type    | Description                     |
        | address | String  | The Host address of mail server |

        Return:
        | Boolean | True |

        Examples:
        | Set Mail Server Address | 127.0.0.1 |

        See also: `Set Imap Server Address`, `Set Pop3 Server Address`, `Set Smtp Server Address`
        """
        self.set_imap_server_address(address)
        self.set_pop3_server_address(address)
        self.set_smtp_server_address(address)
        return True

    @keyword
    def set_imap_server_address(self, address:str):
        """
        This Keyword is a setter keyword to set Imap mail server's host address
        This will be used as host address for mail server of Imap protocol only
        This means it can be set three different hosts for every protocol individualy.

        Args:
        | Name    | Type    | Description                     |
        | address | String  | The Host address of Imap server |

        Return:
        | Boolean | True |

        Examples:
        | Set Imap Server Address | 127.0.0.1 |

        See also: `Set Mail Server Address`, `Set Pop3 Server Address`, `Set Smtp Server Address`
        """
        Variables.imap_mail_server = str(address)
        return True

    @keyword
    def set_pop3_server_address(self, address:str):
        """
        This Keyword is a setter keyword to set Pop3 mail server's host address
        This will be used as host address for mail server of Pop3 protocol only
        This means it can be set three different hosts for every protocol individualy.

        Args:
        | Name    | Type    | Description                     |
        | address | String  | The Host address of Pop3 server |

        Return:
        | Boolean | True |

        Examples:
        | Set Pop3 Server Address | 127.0.0.1 |

        See also: `Set Mail Server Address`, `Set Imap Server Address`, `Set Smtp Server Address`
        """
        Variables.pop3_mail_server = str(address)
        return True

    @keyword
    def set_smtp_server_address(self, address:str):
        """
        This Keyword is a setter keyword to set Smtp mail server's host address
        This will be used as host address for mail server of Smtp protocol only
        This means it can be set three different hosts for every protocol individualy.

        Args:
        | Name    | Type   | Description                     |
        | address | String | The Host address of Smtp server |

        Return:
        | Boolean | True |

        Examples:
        | Set Smtp Server Address | 127.0.0.1 |

        See also: `Set Mail Server Address`, `Set Imap Server Address`, `Set Pop3 Server Address`
        """
        Variables.smtp_mail_server = str(address)
        return True

    @keyword
    def set_both_imap_ports(self, portssl:str, port:str):
        """
        This Keyword is a setter keyword to set the both ports of Imap server
        These will be used as initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | portssl | String | The SSL/TLS or StartTls Port number of Imap Server |
        | port    | String | The Port number of Imap Server with no encryption  |

        Return:
        | Boolean | True |

        Examples:
        | Set Both Imap Ports | 993 | 143 |

        See also: `Set Imap Ssl Port`, `Set Imap Port`
        """
        self.set_imap_ssl_port(portssl)
        self.set_imap_port(port)
        return True

    @keyword
    def set_imap_ssl_port(self, portssl:str):
        """
        This Keyword is a setter keyword to set the ssl port of Imap server
        These will be used initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | portssl | String | The SSL/TLS or StartTls Port number of Imap Server |

        Return:
        | Boolean | True |

        Examples:
        | Set Imap Ssl Port | 993 |

        See also: `Set Both Imap Ports`, `Set Imap Port`
        """
        Variables.imap_ssl_port = int(portssl)
        return True

    @keyword
    def set_imap_port(self, port:str):
        """
        This Keyword is a setter keyword to set the (NoSsl) port of Imap server
        These will be used initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | port    | String | The Port number of Imap Server with no encryption  |

        Return:
        | Boolean | True |

        Examples:
        | Set Imap Port | 143 |

        See also: `Set Both Imap Ports`, `Set Imap Ssl Port`
        """
        Variables.imap_port = int(port)
        return True

    @keyword
    def set_both_pop3_ports(self, portssl:str, port:str):
        """
        This Keyword is a setter keyword to set the both ports of Pop3 server
        These will be used as initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | portssl | String | The SSL/TLS or StartTls Port number of Pop3 Server |
        | port    | String | The Port number of Pop3 Server with no encryption  |

        Return:
        | Boolean | True |

        Examples:
        | Set Both Pop3 Ports | 995 | 110 |

        See also: `Set Pop3 Ssl Port`, `Set Pop3 Port`
        """
        self.set_pop3_ssl_port(portssl)
        self.set_pop3_port(port)
        return True

    @keyword
    def set_pop3_ssl_port(self, portssl:str):
        """
        This Keyword is a setter keyword to set the ssl port of Pop3 server
        These will be used initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | portssl | String | The SSL/TLS or StartTls Port number of Pop3 Server |

        Return:
        | Boolean | True |

        Examples:
        | Set Pop3 Ssl Port | 995 |

        See also: `Set Both Pop3 Ports`, `Set Pop3 Port`
        """
        Variables.pop3_ssl_port = int(portssl)
        return True

    @keyword
    def set_pop3_port(self, port:str):
        """
        This Keyword is a setter keyword to set the (NoSsl) port of Pop3 server
        These will be used initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | port    | String | The Port number of Pop3 Server with no encryption  |

        Return:
        | Boolean | True |

        Examples:
        | Set Pop3 Port | 110 |

        See also: `Set Both Pop3 Ports`, `Set Pop3 Ssl Port`
        """
        Variables.pop3_port = int(port)
        return True

    @keyword
    def set_both_smtp_ports(self, portssl:str, port:str):
        """
        This Keyword is a setter keyword to set the both ports of Smtp server
        These will be used as initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | portssl | String | The SSL/TLS or StartTls Port number of Smtp Server |
        | port    | String | The Port number of Smtp Server with no encryption  |

        Return:
        | Boolean | True |

        Examples:
        | Set Both Smtp Ports | 465 | 25 |

        See also: `Set Smtp Ssl Port`, `Set Smtp Port`
        """
        self.set_smtp_ssl_port(portssl)
        self.set_smtp_port(port)
        return True

    @keyword
    def set_smtp_ssl_port(self, portssl:str):
        """
        This Keyword is a setter keyword to set the ssl port of Smtp server
        These will be used initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | portssl | String | The SSL/TLS or StartTls Port number of Smtp Server |

        Return:
        | Boolean | True |

        Examples:
        | Set Smtp Ssl Port | 465 |

        See also: `Set Both Smtp Ports`, `Set Smtp Port`
        """
        Variables.smtp_ssl_port = int(portssl)
        return True

    @keyword
    def set_smtp_port(self, port:str):
        """
        This Keyword is a setter keyword to set the (NoSsl) port of Smtp server
        These will be used initial ports to connect to

        Args:
        | Name    | Type   | Description                                        |
        | port    | String | The Port number of Smtp Server with no encryption  |

        Return:
        | Boolean | True |

        Examples:
        | Set Smtp Port | 25 |

        See also: `Set Both Smtp Ports`, `Set Smtp Ssl Port`
        """
        Variables.smtp_port = int(port)
        return True
