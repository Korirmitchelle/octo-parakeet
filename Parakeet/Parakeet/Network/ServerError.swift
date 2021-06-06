//
//  ServerError.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import Foundation

struct ServerError : Error {
    let description : String
    
    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}
