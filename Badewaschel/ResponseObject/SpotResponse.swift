// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SpotResponse: Codable {
    let type: String
    let totalFeatures: Int
    let features: [Spot]
    let crs: CRS
}

// MARK: - Feature
struct Spot: Codable {
    let type: FeatureType
    let id: String
    let geometry: Geometry
    let geometryName: GeometryName
    let properties: FeatureProperties

    enum CodingKeys: String, CodingKey {
        case type, id, geometry
        case geometryName = "geometry_name"
        case properties
    }
}

enum GeometryType: String, Codable {
    case point = "Point"
}

enum GeometryName: String, Codable {
    case shape = "SHAPE"
}

// MARK: - FeatureProperties
struct SpotProperties: Codable {
    let bezeichnung: String
    let weitereInfo: String
    let bezirk, badequalitaet: Int
    let untersuchungsdatum: String
    let wassertemperatur, sichttiefe: Double
    let anzEcoli, anzEnterokokken, typ, seSdoRowid: Int
    let seAnnoCADData: JSONNull?

    enum CodingKeys: String, CodingKey {
        case bezeichnung = "BEZEICHNUNG"
        case weitereInfo = "WEITERE_INFO"
        case bezirk = "BEZIRK"
        case badequalitaet = "BADEQUALITAET"
        case untersuchungsdatum = "UNTERSUCHUNGSDATUM"
        case wassertemperatur = "WASSERTEMPERATUR"
        case sichttiefe = "SICHTTIEFE"
        case anzEcoli = "ANZ_ECOLI"
        case anzEnterokokken = "ANZ_ENTEROKOKKEN"
        case typ = "TYP"
        case seSdoRowid = "SE_SDO_ROWID"
        case seAnnoCADData = "SE_ANNO_CAD_DATA"
    }
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}
