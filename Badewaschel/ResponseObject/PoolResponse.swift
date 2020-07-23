// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

import Foundation

// MARK: - PoolResponse
struct PoolResponse: Response {
    let type: String
    let totalFeatures: Int
    let features: [Pool]
    let crs: CRS
}

// MARK: - CRS
struct CRS: Codable {
    let type: String
    let properties: CRSProperties
}

// MARK: - CRSProperties
struct CRSProperties: Codable {
    let name: String
}

// MARK: - Pool
public struct Pool: Codable, Identifiable {
    let type: String?
    public let id: String
    let geometry: Geometry
    let geometryName: String
    let properties: FeatureProperties

    enum CodingKeys: String, CodingKey {
        case type, id, geometry
        case geometryName = "geometry_name"
        case properties
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - FeatureProperties
struct FeatureProperties: Codable {
    let name, adresse: String
    let weblink1: String?
    let bezirk: Int
    let auslastungTag0: String?
    let auslastungAmpelKatTxt0: String?
    let auslastungAmpelKategorie0: Int
    let auslastungTag1: String?
    let auslastungAmpelKatTxt1: String?
    let auslastungAmpelKategorie1: Int?
    let auslastungTag2: String?
    let auslastungAmpelKatTxt2: String?
    let auslastungAmpelKategorie2: Int?
    let auslastungTag3: String?
    let auslastungAmpelKatTxt3: String?
    let auslastungAmpelKategorie3: Int?
    let timestampModifiedFormat: String?
    let seSdoRowid: Int
    let seAnnoCADData: JSONNull?

    enum CodingKeys: String, CodingKey {
        case name = "NAME"
        case adresse = "ADRESSE"
        case weblink1 = "WEBLINK1"
        case bezirk = "BEZIRK"
        case auslastungTag0 = "AUSLASTUNG_TAG_0"
        case auslastungAmpelKatTxt0 = "AUSLASTUNG_AMPEL_KAT_TXT_0"
        case auslastungAmpelKategorie0 = "AUSLASTUNG_AMPEL_KATEGORIE_0"
        case auslastungTag1 = "AUSLASTUNG_TAG_1"
        case auslastungAmpelKatTxt1 = "AUSLASTUNG_AMPEL_KAT_TXT_1"
        case auslastungAmpelKategorie1 = "AUSLASTUNG_AMPEL_KATEGORIE_1"
        case auslastungTag2 = "AUSLASTUNG_TAG_2"
        case auslastungAmpelKatTxt2 = "AUSLASTUNG_AMPEL_KAT_TXT_2"
        case auslastungAmpelKategorie2 = "AUSLASTUNG_AMPEL_KATEGORIE_2"
        case auslastungTag3 = "AUSLASTUNG_TAG_3"
        case auslastungAmpelKatTxt3 = "AUSLASTUNG_AMPEL_KAT_TXT_3"
        case auslastungAmpelKategorie3 = "AUSLASTUNG_AMPEL_KATEGORIE_3"
        case timestampModifiedFormat = "TIMESTAMP_MODIFIED_FORMAT"
        case seSdoRowid = "SE_SDO_ROWID"
        case seAnnoCADData = "SE_ANNO_CAD_DATA"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
