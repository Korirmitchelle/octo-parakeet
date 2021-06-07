//
//  LocationsModel.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import Foundation

// MARK: - Welcome
struct Locations: Codable {
    let predictions: [Prediction]
    let status: String
}

// MARK: - Prediction
struct Prediction: Codable {
    let predictionDescription: String
    let placeID, reference: String
    let structuredFormatting: StructuredFormatting

    enum CodingKeys: String, CodingKey {
        case predictionDescription = "description"
        case placeID = "place_id"
        case reference
        case structuredFormatting = "structured_formatting"
    }
}


// MARK: - StructuredFormatting
struct StructuredFormatting: Codable {
    let mainText: String?
    let secondaryText: String?

    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case secondaryText = "secondary_text"
    }
}



struct Location : Encodable, Decodable {
    var name: String
    var detail: String
    var id: String
    var lat: Double
    var lon: Double    
}
