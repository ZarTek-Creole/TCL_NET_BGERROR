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

# Variables de configuration pour le client de NET_BGERROR
# Configuration variables for NET_BGERROR client
namespace eval ::NET_BGERROR_CLIENT {
    set PATH_SCRIPT "[file dirname [file normalize [info script]]]/NET_BGERROR.conf"
    if { [ catch {
        source ${PATH_SCRIPT}
    } err ] } {
        putlog "[namespace current] > Error: Chargement du fichier '${PATH_SCRIPT}' > $err"
        return -code error $err
    }
    set List_Var_Conf [list         \
                        "channel"   \
                        "botName"   \
                        "cryptKey"  \
                        "cryptType" \
    ];
    foreach varName [split ${List_Var_Conf}] {
        if { ![info exists [namespace current]::${varName}] } {
            putlog "[namespace current]> Error: La configuration ${varName} est manquante dans ${PATH_SCRIPT}"
            exit
        }
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
    foreach message_line [split $::errorInfo "\n"] {
        set message_encrypt    [encrypt ${cryptType}:${cryptKey} $message_line]
        if {$botName == ""} {
            putallbots "NET_BGERROR ${message_encrypt}";
        } else {
            if { [islinked $botName] } {
                putbot $botName "NET_BGERROR $message_encrypt"
            } else {
                putlog "::NET_BGERROR_CLIENT > Erreur : le robot '$botName' n'ai pas connecté"
            }
        }
    }



}

# Définit la commande pour envoyer les erreurs de fond d'écran au bot
proc bgerror {message} { ::NET_BGERROR_CLIENT::sendError }

putlog "::NET_BGERROR_CLIENT is loaded."