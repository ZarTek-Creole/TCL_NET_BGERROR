# Visite https://github.com/ZarTek-Creole/TCL_NET_BGERROR

# Variables de configuration pour le client de NET_BGERROR
# Configuration variables for NET_BGERROR client
namespace eval ::NET_BGERROR_CLIENT {
    variable botName    "" ;    # Nom du bot auquel envoyer les messages d'erreur | Name of the bot to send error messages to
    variable cryptKey   "";     # Clé de chiffrement | Encryption key
    variable cryptType  "cbc";  # Type de chiffrement : "ecb" ou "cbc" | Encryption type: "ecb" or "cbc"
}

# Procedure pour envoyer les erreurs
proc ::NET_BGERROR_CLIENT::sendError {args} {
    set botName     ${::NET_BGERROR_CLIENT::botName}
    set cryptKey    ${::NET_BGERROR_CLIENT::cryptKey}
    set cryptType   [string tolower ${::NET_BGERROR_CLIENT::cryptType}]

    if {$cryptKey == ""} {
        set cryptKey "UNSHADOW"
    }

    if {$cryptType != "ecb" && $cryptType != "cbc"} {
        putlog "::NET_BGERROR_CLIENT > Erreur : le type de chiffrement n'est pas valide. Valeur valide : 'ecb' ou 'cbc', utilisation de 'cbc'."
        return
    }
    set cryptType   [expr { ${cryptType} in {"ecb" "cbc"} ? ${cryptType} : "cbc" }]

    set encryptedMessage    [encrypt ${cryptType}:${cryptKey} $::errorInfo]
    if {$botName == ""} {
        putallbots "NET_BGERROR ${message_encrypt}";
    } else {
        if { [islinked $botName] } {
            putbot $botName "NET_BGERROR $encryptedMessage"
        } else {
            putlog "::NET_BGERROR_CLIENT > Erreur : le robot '$botName' n'ai pas connecté"
        }

    }

}

# Définit la commande pour envoyer les erreurs de fond d'écran au bot
proc bgerror {message} {::NET_BGERROR_CLIENT::sendError}

putlog "::NET_BGERROR_CLIENT is loaded."