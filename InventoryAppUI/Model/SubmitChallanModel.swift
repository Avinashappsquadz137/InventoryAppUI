//
//  SubmitChallanModel.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/01/25.
//

import Foundation
struct SubmitChallanModel : Codable {
    let status : Bool?
    let message : String?
    let data : [SubmitChallanItem]?
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
        data = try values.decodeIfPresent([SubmitChallanItem].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct SubmitChallanItem : Codable {
    let tEMP_ID : String?
    let cLIENT_NAME : String?
    let cONTACT_PERSON : String?
    let tO_LOCATION : String?
    let sHOW_DATE : String?
    let cHALLAN_DETAIL : String?

    enum CodingKeys: String, CodingKey {
        case tEMP_ID = "TEMP_ID"
        case cLIENT_NAME = "CLIENT_NAME"
        case cONTACT_PERSON = "CONTACT_PERSON"
        case tO_LOCATION = "TO_LOCATION"
        case sHOW_DATE = "SHOW_DATE"
        case cHALLAN_DETAIL = "CHALLAN_DETAIL"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tEMP_ID = try values.decodeIfPresent(String.self, forKey: .tEMP_ID)
        cLIENT_NAME = try values.decodeIfPresent(String.self, forKey: .cLIENT_NAME)
        cONTACT_PERSON = try values.decodeIfPresent(String.self, forKey: .cONTACT_PERSON)
        tO_LOCATION = try values.decodeIfPresent(String.self, forKey: .tO_LOCATION)
        sHOW_DATE = try values.decodeIfPresent(String.self, forKey: .sHOW_DATE)
        cHALLAN_DETAIL = try values.decodeIfPresent(String.self, forKey: .cHALLAN_DETAIL)
    }

}
