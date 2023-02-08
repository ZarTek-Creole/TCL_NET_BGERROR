
# Visite https://github.com/ZarTek-Creole/TCL_NET_BGERROR
namespace eval ::NET_BGERROR_SRV {
    variable CHANNEL        "<#CHANNEL_POUR_LES_ERREURS>"; # Channel to sent message
    variable CRYPT_KEY      ""; # key of encryption?
    variable CRYPT_TYPE     ""; # ecb or cbc encryption?
    variable PREFIX         "NET_BGERROR";
    variable SPLITER        " > ";
    variable DEBUG          "1";
}
proc ::NET_BGERROR_SRV::NET_BGERROR { frombot fromcmd message_encrypt } {
    if { [validchan ${::NET_BGERROR_SRV::CHANNEL}] } {
        if {
            ![info exists ::NET_BGERROR_CLI::CRYPT_KEY]                           || \
                ${::NET_BGERROR_CLI::CRYPT_KEY} == "" } {
                } {
                    set CRYPT_KEY     "UNSHADOW";
            } else {
                set CRYPT_KEY     ${::NET_BGERROR_CLI::CRYPT_KEY};
            }
            if { [expr {"${CRYPT_MODE}" != "ecb"} && {"${CRYPT_MODE}" != "cbc"}] } {
                putlog "[namespace current] :: Error: CRYPT_TYPE inlavid value: 'CRYPT_TYPE', set default value to 'cbc'"
            }
            foreach { message_line } [split [decrypt ${CRYPT_KEY} ${message_encrypt}] "\n"] {
                putnow "PRIVMSG ${::NET_BGERROR_SRV::CHANNEL} :${::NET_BGERROR_SRV::CHANNEL}${::NET_BGERROR_SRV::SPLITER}${frombot}${::NET_BGERROR_SRV::SPLITER}${message_line}";
            }
        } {
            if { ${::NET_BGERROR_SRV::DEBUG} != "1" } {
                putlog "::NET_BGERROR_SRV > Le salon '${::NET_BGERROR_SRV::CHANNEL}' est invalide. Je ne peu pas envoyer dessus.";
            }
        }
    }
    bind bot - NET_BGERROR ::NET_BGERROR_SRV::NET_BGERROR