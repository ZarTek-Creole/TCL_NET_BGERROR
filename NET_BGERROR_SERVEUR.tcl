###############################################################################################
#
#	Name		:
#		NET_BGERROR_CLIENT.tcl
#
#	Description	:
#       Send BGERROR (TCL) errors to an Eggdrops master
#       Do you have a botnet of several Eggdrops?
#       You want to centralize the errors of these towards a single Eggdrops, on a show?
#       This script does exactly that.
#
#		Envois les erreurs BGERROR (TCL) vers un master Eggdrops
#       Vous avez un botnet de plusieurs Eggdrops ?
#       Vous désirez centraliser les erreurs de ceux-ci vers un seul Eggdrops, sur un salon ?
#       Ce script fait exactement çà.
#
#	Donation	:
#		https://github.com/ZarTek-Creole/DONATE
#
#	Auteur		:
#		ZarTek @ https://github.com/ZarTek-Creole
#
#	Website		:
#		https://github.com/ZarTek-Creole/TCL_NET_BGERROR
#
#	Support		:
#		https://github.com/ZarTek-Creole/TCL_NET_BGERROR/issues
#
#	Docs		:
#		https://github.com/ZarTek-Creole/TCL_NET_BGERROR/wiki
#
#	Thanks to	:
#		All donators, testers, repporters & contributors
#
###############################################################################################

# Variables de configuration pour le serveur de NET_BGERROR
# Configuration variables for NET_BGERROR server

namespace eval ::NET_BGERROR_SERVER {
    set PATH_SCRIPT [file dirname [file normalize [info script]]]
    if { [ catch {
        source ${PATH_SCRIPT}/NET_BGERROR.conf
    } err ] } {
        putlog "::NET_BGERROR_SERVER > Error: Chargement du fichier '${PATH_SCRIPT}/NET_BGERROR.conf' > $err"
        return -code error $err
    }
}

# Procedure to handle messages received from clients
proc ::NET_BGERROR_SERVER::handle_message { frombot fromcmd encrypted_message } {
    set channel             ${::NET_BGERROR_SERVER::channel}
    set debug               ${::NET_BGERROR_SERVER::debug}
    set cryptKey            ${::NET_BGERROR_SERVER::cryptKey}
    set cryptType           ${::NET_BGERROR_SERVER::cryptType}
    set message_delimiter   ${::NET_BGERROR_SERVER::message_delimiter}

    # Check if the channel is valid
    if { ![validchan ${channel}] } {
        # If the channel is invalid, log an error message if the debug flag is set
        if { ${debug} != 0 } {
            putlog "::NET_BGERROR_SERVER > The channel '${channel}' is invalid. Cannot send messages to it."
        }
    return
}

# Get the encryption key to use, defaulting to "UNSHADOW" if it is not set
set cryptKey      [expr {
    ${cryptKey} != ""
    ? ${cryptKey} : "UNSHADOW"
    }]

    # Get the encryption type to use, defaulting to "cbc" if it is not set
    set cryptType     [expr {
        ${cryptType} in {"ecb", "cbc"}
        ? ${cryptType} : "cbc"
        }]

        # Decrypt the message
        set decrypted_message   [catch {decrypt ${cryptType}:${cryptKey} ${encrypted_message}}]
        if {[string length $decrypted_message] == 0} {
            putlog "::NET_BGERROR_SERVER > Invalid encryption key. Could not decrypt message."
            return
        }

# Split the decrypted message into separate lines
foreach message_line [split $decrypted_message "\n"] {
    # Send the message to the channel
    putnow "PRIVMSG ${channel} :${channel}${message_delimiter}${frombot}${message_delimiter}${message_line}"
    }
}

# Bind the message handler to the bot
bind bot - NET_BGERROR ::NET_BGERROR_SERVER::handle_message

putlog "::NET_BGERROR_SERVER is loaded."