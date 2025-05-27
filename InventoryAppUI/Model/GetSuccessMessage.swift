//
//  GetSuccessMessage.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 27/05/25.
//

import Foundation

struct GetSuccessMessage: Codable {
    let status: Bool?
    let message: String?
    let data: [String]?
    let error: [String]?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
        case error
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([String].self, forKey: .data)
        
        // Handle "error" as either a string or an array of strings
        if let errorArray = try? values.decodeIfPresent([String].self, forKey: .error) {
            error = errorArray
        } else if let errorString = try? values.decodeIfPresent(String.self, forKey: .error) {
            error = [errorString]
        } else {
            error = nil
        }
    }
}
