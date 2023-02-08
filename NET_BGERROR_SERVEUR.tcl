# Visite https://github.com/ZarTek-Creole/TCL_NET_BGERROR
namespace eval ::NET_BGERROR_SERVER {
    # Channel to send the error messages
    variable channel            "#error_channel"

    # Key used for encryption of messages
    variable encryption_key     ""

    # Encryption algorithm to use: either "ecb" or "cbc"
    variable encryption_type    "cbc"

    # Prefix to use in the messages sent to the channel
    variable message_prefix     "NET_BGERROR"

    # Delimiter to use between parts of the message
    variable message_delimiter  " > "

    # Debug flag to control logging of error messages
    variable debug 1
}

# Procedure to handle messages received from clients
proc ::NET_BGERROR_SERVER::handle_message { frombot fromcmd encrypted_message } {
    set channel             ${::NET_BGERROR_SERVER::channel}
    set debug               ${::NET_BGERROR_SERVER::debug}
    set encryption_key      ${::NET_BGERROR_SERVER::encryption_key}
    set encryption_type     ${::NET_BGERROR_SERVER::encryption_type}
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
set encryption_key      [expr {
    ${encryption_key} != ""
    ? ${encryption_key} : "UNSHADOW"
    }]

    # Get the encryption type to use, defaulting to "cbc" if it is not set
    set encryption_type     [expr {
        ${encryption_type} in {"ecb", "cbc"}
        ? ${encryption_type} : "cbc"
        }]

        # Decrypt the message
        set decrypted_message   [catch {decrypt ${encryption_type}:${encryption_key} ${encrypted_message}}]
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