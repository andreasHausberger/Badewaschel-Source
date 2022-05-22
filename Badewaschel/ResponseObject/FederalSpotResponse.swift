// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let federalSpotResponse = try? newJSONDecoder().decode(FederalSpotResponse.self, from: jsonData)

import Foundation

// MARK: - FederalSpotResponse
struct FederalSpotResponse: Codable {
    let version: String
    let states: [FederalState]

    enum CodingKeys: String, CodingKey {
        case version = "VERSION"
        case states = "BUNDESLAENDER"
    }
}

// MARK: - Bundeslaender
struct FederalState: Codable, Hashable {
    static func == (lhs: FederalState, rhs: FederalState) -> Bool {
        lhs.stateName == rhs.stateName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(stateName)
    }
    
    let stateName: String
    let spots: [FederalSpot]

    enum CodingKeys: String, CodingKey {
        case stateName = "BUNDESLAND"
        case spots = "BADEGEWAESSER"
    }
}

// MARK: - Badegewaesser
struct FederalSpot: Codable, Hashable {
    static func == (lhs: FederalSpot, rhs: FederalSpot) -> Bool {
        lhs.badegewaesserid == rhs.badegewaesserid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(badegewaesserid)
        hasher.combine(badegewaessername)
    }
    
    
    let badegewaesserid, badegewaessername, bezirk, gemeinde: String
    let longitude, latitude, ansprechstelle, strasseNummer: String
    let plzOrt, telefon, email, tgesperrt: String
    let enterokokkenEinheit, eColiEinheit: Einheit
    let wassertemperaturEinheit: WassertemperaturEinheit
    let sichttiefeEinheit: SichttiefeEinheit
    let sperrgrund, wasserqualitaetJahrHeuer, qualitaet2022, wasserqualitaetJahrVoriges: String
    let qualitaet2021: String
    let wasserqualitaetJahrVorVoriges, qualitaet2020, wasserqualitaetJahrVorVorVoriges, qualitaet2019: Qualitaet2018
    let qualitaet2018: Qualitaet2018
    let messwerte: [QualityMeasurement]

    enum CodingKeys: String, CodingKey {
        case badegewaesserid = "BADEGEWAESSERID"
        case badegewaessername = "BADEGEWAESSERNAME"
        case bezirk = "BEZIRK"
        case gemeinde = "GEMEINDE"
        case longitude = "LONGITUDE"
        case latitude = "LATITUDE"
        case ansprechstelle = "ANSPRECHSTELLE"
        case strasseNummer = "STRASSE_NUMMER"
        case plzOrt = "PLZ_ORT"
        case telefon = "TELEFON"
        case email = "EMAIL"
        case tgesperrt = "TGESPERRT"
        case enterokokkenEinheit = "ENTEROKOKKEN_EINHEIT"
        case eColiEinheit = "E_COLI_EINHEIT"
        case wassertemperaturEinheit = "WASSERTEMPERATUR_EINHEIT"
        case sichttiefeEinheit = "SICHTTIEFE_EINHEIT"
        case sperrgrund = "SPERRGRUND"
        case wasserqualitaetJahrHeuer = "WASSERQUALITAET_JAHR_HEUER"
        case qualitaet2022 = "QUALITAET_2022"
        case wasserqualitaetJahrVoriges = "WASSERQUALITAET_JAHR_VORIGES"
        case qualitaet2021 = "QUALITAET_2021"
        case wasserqualitaetJahrVorVoriges = "WASSERQUALITAET_JAHR_VOR_VORIGES"
        case qualitaet2020 = "QUALITAET_2020"
        case wasserqualitaetJahrVorVorVoriges = "WASSERQUALITAET_JAHR_VOR_VOR_VORIGES"
        case qualitaet2019 = "QUALITAET_2019"
        case qualitaet2018 = "QUALITAET_2018"
        case messwerte = "MESSWERTE"
    }
    
    var isOpen: Bool {
        self.tgesperrt == "0"
    }
    
    var isOpenText: String {
        self.isOpen ? "Ja, offen" : "Nein, gesperrt"
    }
    
    var validEmail: String? {
        if self.email == "0" { return nil }
        return self.email
    }
}

enum Einheit: String, Codable {
    case kbe100Ml = "KBE/100ml"
}

// MARK: - Messwerte
struct QualityMeasurement: Codable, Hashable {
    let date: String
    let enterokokken, eColi: Int
    let waterTemperature, sightLevel: Double
    let quality: Int

    enum CodingKeys: String, CodingKey {
        case date = "D"
        case enterokokken = "E"
        case eColi = "E_C"
        case waterTemperature = "W"
        case sightLevel = "S"
        case quality = "A"
    }
    
    var qualityLabel: String {
        switch self.quality {
        case 1:
            return "Ausgezeichnete Badegewässerqualität"
        case 2:
            return "Gute Badegewässerqualität"
        case 3:
            return "Mangelhafte Badegewässerqualität"
        case 4:
            return "Baden verboten / vom Baden wird abgeraten"
        default:
            return "Keine Informationen"
        }
    }
}

enum Qualitaet2018: String, Codable {
    case a = "A"
    case b = "B"
    case empty = ""
    case g = "G"
}

enum SichttiefeEinheit: String, Codable {
    case m = "m"
}

enum WassertemperaturEinheit: String, Codable {
    case c = "°C"
}
