# Visite https://github.com/ZarTek-Creole/TCL_NET_BGERROR
namespace eval ::NET_BGERROR_CLI {
    variable TO_BOTNAME     "";
    variable CRYPT_KEY      "";
}
proc ::NET_BGERROR_CLI::SENT { args } {
    if {
        ![info exists ::NET_BGERROR_CLI::CRYPT_KEY]                             || \
            ${::NET_BGERROR_CLI::CRYPT_KEY} == "" } {
            } {
                set CRYPT_KEY     "UNSHADOW";
        } else {
            set CRYPT_KEY     ${::NET_BGERROR_CLI::CRYPT_KEY};
        }
        set message_encrypt     [encrypt ${CRYPT_KEY} $::errorInfo];
        if {
            ![info exists ::NET_BGERROR_CLI::TO_BOTNAME]                        || \
                ${::NET_BGERROR_CLI::TO_BOTNAME} == ""
        } {
            putallbots "NET_BGERROR ${message_encrypt}";
        } else {
            putbot ${::NET_BGERROR_CLI::TO_BOTNAME} "NET_BGERROR ${message_encrypt}";
        }

    }
    proc bgerror {message} { ::NET_BGERROR_CLI::SENT; }
