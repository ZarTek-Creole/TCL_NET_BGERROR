# TCL_NET_BGERROR

## Introduction
Envois les erreurs BGERROR (TCL) vers un master Eggdrops


Vous avez un botnet de plusieurs Eggdrops ? ous désirez centraliser les erreurs de ceux-ci vers un seul Eggdrops, sur un salon ?
Ce script fait exactement çà.


## Explication
Il vous suffis de mettre *NET_BGERROR_SERVEUR.tcl* sur le Eggdrop qui est sur votre salon, d'informer les variables CHANNEL de votre salon et CRYPT_KEY avec une clef (pour encrypter les messages sur votre botnet)

Sur les Eggdrops que vous désirez recolter les erreurs (bg error), charger le *NET_BGERROR_CLIENT.tcl*, renseigner les variables TO_BOTNAME avec le nom du eggdrop serveur, et, CRYPT_KEY avec la meme valeur que dans *NET_BGERROR_SERVEUR.tcl*

## Informations
Retrouver mes autres scripts sur https://github.com/ZarTek-Creole

## Donation
Ce script vous est utile ? Pensez a me payer un café !

https://github.com/ZarTek-Creole/DONATE