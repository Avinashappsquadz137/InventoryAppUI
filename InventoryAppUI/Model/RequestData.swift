//
//  RequestData.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 11/01/25.
//

import Foundation

// MARK: - API Response
struct Requestresponsedata: Codable {
    let status: Bool
    let message: String
    let data: [ItemDetail]?
    let error: String?
}

// MARK: - ItemDetail
struct ItemDetail: Codable {
    let tempID: String
    let clientName: String
    let contactPerson: String
    let personMobileNo: String
    let empCode: String
    let toLocation: String
    let showDate: String
    let transportBy: String
    let transportNo: String
    let transportDetail: String
    let items: [Item]
    let miscItems: [String: String]

    enum CodingKeys: String, CodingKey {
        case tempID = "TEMP_ID"
        case clientName = "CLIENT_NAME"
        case contactPerson = "CONTACT_PERSON"
        case personMobileNo = "PERSON_MOBILE_NO"
        case empCode = "EMPCODE"
        case toLocation = "TO_LOCATION"
        case showDate = "SHOW_DATE"
        case transportBy = "TRANSPORT_BY"
        case transportNo = "TRANSPORT_NO"
        case transportDetail = "TRANSPORT_DETAIL"
        case items = "ITEMS"
        case miscItems = "MISC_ITEMS"
    }
    
    // Custom initializer to handle cases where miscItems could be an empty array
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tempID = try container.decode(String.self, forKey: .tempID)
        clientName = try container.decode(String.self, forKey: .clientName)
        contactPerson = try container.decode(String.self, forKey: .contactPerson)
        personMobileNo = try container.decode(String.self, forKey: .personMobileNo)
        empCode = try container.decode(String.self, forKey: .empCode)
        toLocation = try container.decode(String.self, forKey: .toLocation)
        showDate = try container.decode(String.self, forKey: .showDate)
        transportBy = try container.decode(String.self, forKey: .transportBy)
        transportNo = try container.decode(String.self, forKey: .transportNo)
        transportDetail = try container.decode(String.self, forKey: .transportDetail)
        items = try container.decode([Item].self, forKey: .items)
        
        // Try decoding miscItems as a dictionary, otherwise assign an empty dictionary if decoding fails
        if let miscItemsDict = try? container.decode([String: String].self, forKey: .miscItems) {
            miscItems = miscItemsDict
        } else {
            miscItems = [:]
        }
    }
}

// MARK: - Item
struct Item: Codable {
    let category: String
    let itemName: String
    let quantity: String
    let itemId : String

    enum CodingKeys: String, CodingKey {
        case category = "Category"
        case itemName = "Item Name"
        case quantity = "Quantity"
        case itemId = "ItemId"
    }
}


struct SaveChallanMaster : Codable {
    let status : Bool?
    let message : String?
    let data : MessageData?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(MessageData.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct MessageData : Codable {
    let temp_id : String?

    enum CodingKeys: String, CodingKey {

        case temp_id = "temp_id"
    }

    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let intValue = try? container.decode(Int.self, forKey: .temp_id) {
                temp_id = String(intValue)
            } else if let stringValue = try? container.decode(String.self, forKey: .temp_id) {
                temp_id = stringValue
            } else {
                temp_id = nil
            }
        }

}

struct SubmitChallan : Codable {
    let status : Bool?
    let message : String?
    let data : String?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
