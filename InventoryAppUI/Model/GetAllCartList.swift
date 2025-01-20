//
//  GetAllCartList.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 13/12/24.
//

import Foundation

struct GetAllCartList : Codable {
    let status : Bool?
    let message : String?
    let from_date : String?
    let to_date : String?
    let data : [CartList]?
    let error : [ErrorDetail]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case from_date = "from_date"
        case to_date = "to_date"
        case data = "data"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        from_date = try values.decodeIfPresent(String.self, forKey: .from_date)
        to_date = try values.decodeIfPresent(String.self, forKey: .to_date)
        data = try values.decodeIfPresent([CartList].self, forKey: .data)
        error = try values.decodeIfPresent([ErrorDetail].self, forKey: .error)
    }

}


struct CartList : Codable {
    let id : String?
    let user_id : String?
    let iTEM_MASTER_ID : String?
    let iTEM_NAME : String?
    let mODEL_NO : String?
    let bRAND : String?
    let sR_NUMBER : String?
    let iTEM_CATEGORY_ID : String?
    let iTEM_CATEGORY : String?
    let from_date : String?
    let to_date : String?
    let iTEM_THUMBNAIL : String?
    var items_in_cart : Int?
    let currently_available : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case iTEM_MASTER_ID = "ITEM_MASTER_ID"
        case iTEM_NAME = "ITEM_NAME"
        case mODEL_NO = "MODEL_NO"
        case bRAND = "BRAND"
        case sR_NUMBER = "SR_NUMBER"
        case iTEM_CATEGORY_ID = "ITEM_CATEGORY_ID"
        case iTEM_CATEGORY = "ITEM_CATEGORY"
        case from_date = "from_date"
        case to_date = "to_date"
        case iTEM_THUMBNAIL = "ITEM_THUMBNAIL"
        case items_in_cart = "items_in_cart"
        case currently_available = "currently_available"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        iTEM_MASTER_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_MASTER_ID)
        iTEM_NAME = try values.decodeIfPresent(String.self, forKey: .iTEM_NAME)
        mODEL_NO = try values.decodeIfPresent(String.self, forKey: .mODEL_NO)
        bRAND = try values.decodeIfPresent(String.self, forKey: .bRAND)
        sR_NUMBER = try values.decodeIfPresent(String.self, forKey: .sR_NUMBER)
        iTEM_CATEGORY_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_CATEGORY_ID)
        iTEM_CATEGORY = try values.decodeIfPresent(String.self, forKey: .iTEM_CATEGORY)
        from_date = try values.decodeIfPresent(String.self, forKey: .from_date)
        to_date = try values.decodeIfPresent(String.self, forKey: .to_date)
        iTEM_THUMBNAIL = try values.decodeIfPresent(String.self, forKey: .iTEM_THUMBNAIL)
        items_in_cart = try values.decodeIfPresent(Int.self, forKey: .items_in_cart)
        currently_available = try values.decodeIfPresent(String.self, forKey: .currently_available)
    }

}
struct ErrorDetail: Codable {
    let code: Int?
   let message: String?
}
    

struct AddRemoveData : Codable {
    let status : Bool?
    let message : String?
    let data : Bool?
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
        data = try values.decodeIfPresent(Bool.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
