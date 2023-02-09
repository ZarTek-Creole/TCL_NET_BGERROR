# Visite https://github.com/ZarTek-Creole/TCL_NET_BGERROR

# Variables de configuration pour le client de NET_BGERROR
# Configuration variables for NET_BGERROR client

namespace eval ::NET_BGERROR_CLIENT {
    set PATH_SCRIPT [file dirname [file normalize [info script]]]
    if { [ catch {
        source ${PATH_SCRIPT}/NET_BGERROR.conf
    } err ] } {
        putlog "::NET_BGERROR_CLIENT > Error: Chargement du fichier '${PATH_SCRIPT}/NET_BGERROR.conf' > $err"
        return -code error $err
    }
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