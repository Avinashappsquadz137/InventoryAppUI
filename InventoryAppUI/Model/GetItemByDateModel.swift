//
//  GetItemByDateModel.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 16/01/25.
//

import Foundation
struct GetItemByDate : Codable {
    let status : Bool?
    let message : String?
    let data : [Items]?
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
        data = try values.decodeIfPresent([Items].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
struct Items : Codable {
    let iTEM_MASTER_ID : String?
    let iTEM_NAME : String?
    let iTEM_CATEGORY_ID : String?
    let mODEL_NO : String?
    let bRAND : String?
    let sR_NUMBER : String?
    let iTEM_THUMBNAIL : String?
    let currently_available : String?

    enum CodingKeys: String, CodingKey {

        case iTEM_MASTER_ID = "ITEM_MASTER_ID"
        case iTEM_NAME = "ITEM_NAME"
        case iTEM_CATEGORY_ID = "ITEM_CATEGORY_ID"
        case mODEL_NO = "MODEL_NO"
        case bRAND = "BRAND"
        case sR_NUMBER = "SR_NUMBER"
        case iTEM_THUMBNAIL = "ITEM_THUMBNAIL"
        case currently_available = "currently_available"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iTEM_MASTER_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_MASTER_ID)
        iTEM_NAME = try values.decodeIfPresent(String.self, forKey: .iTEM_NAME)
        iTEM_CATEGORY_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_CATEGORY_ID)
        mODEL_NO = try values.decodeIfPresent(String.self, forKey: .mODEL_NO)
        bRAND = try values.decodeIfPresent(String.self, forKey: .bRAND)
        sR_NUMBER = try values.decodeIfPresent(String.self, forKey: .sR_NUMBER)
        iTEM_THUMBNAIL = try values.decodeIfPresent(String.self, forKey: .iTEM_THUMBNAIL)
        currently_available = try values.decodeIfPresent(String.self, forKey: .currently_available)
    }

}
