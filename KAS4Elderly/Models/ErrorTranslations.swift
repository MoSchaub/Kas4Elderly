//
//  ErrorTranslations.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 11.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import Foundation

struct parseError{
    var code : Int
    
    var description: String
    
    func germanDescrition(for code: Int) -> String{
        switch code {
		case 1:
			return "interner Serverfehler"
		case 100:
			return "Verbindung fehlgeschlagen"
        case 101:
            return "Benutzername/Passwort sind Falsch"
		case 102:
			return "Datentyp unterstützt keinen exakten Datenbankabgleich"
		case 103:
			return "fehlender/ungültiger Klassenname"
		case 104:
			return "fehlende Objekt-Id"
		case 105:
			return "ungültiger Key"
		case 106:
			return "fehlerhafter Zeiger"
		case 107:
			return "fehlerhaftes Json Objekt"
		case 108:
			return "nur intern verfügbare Funktion"
		case 111:
			return "fehlerhafter Typ"
		case 112:
			return "fehlerhafter Kanalname"
		case 114:
			return "fehlerhafter Geräte-Token"
		case 116:
			return "zu großes Objekt"
		case 125:
			return "E-mail fehlerhaft"
		case 137:
			return "ein wert ist bereits belegt"
		case 139:
			return "fehlerhaftzer Name"
		case 150:
			return "fehlerhafte Bilddaten"
		case 200:
			return "Benutzername fehlt"
		case 202:
			return "Benutzername ist schon vergeben"
		case 203:
			return "E-mail ist schon vergeben"
		case 204:
			return "E-mail fehlt"
		case 205:
			return "Kein Benutzer mit dieser e-mail"
        default:
            return "Fehler, bitte versuche es erneut"
        }
    }
}

