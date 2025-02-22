//
//  RepairListModel.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 28/01/25.
//

import Foundation

struct RepairListModel : Codable {
    let status : Bool?
    let message : String?
    let data : [RepairList]?
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
        data = try values.decodeIfPresent([RepairList].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
struct RepairList : Codable {
    let iTEM_MASTER_ID : String?
    let iTEM_NAME : String?
    let mODEL_NO : String?
    let bRAND : String?
    let iTEM_THUMBNAIL : String?
    let iTEM_REPAIR_ID : String?
    let rEPAIR_STATUS : String?
    let rEPAIR_PRICE : String?
    let rEPAIR_DATE : String?
    let rEMARKS : String?
    
    enum CodingKeys: String, CodingKey {

        case iTEM_MASTER_ID = "ITEM_MASTER_ID"
        case iTEM_NAME = "ITEM_NAME"
        case mODEL_NO = "MODEL_NO"
        case bRAND = "BRAND"
        case iTEM_THUMBNAIL = "ITEM_THUMBNAIL"
        case iTEM_REPAIR_ID = "ITEM_REPAIR_ID"
        case rEPAIR_STATUS = "REPAIR_STATUS"
        case rEPAIR_PRICE = "REPAIR_PRICE"
        case rEPAIR_DATE = "REPAIR_DATE"
        case rEMARKS = "REMARKS"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iTEM_MASTER_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_MASTER_ID)
        iTEM_NAME = try values.decodeIfPresent(String.self, forKey: .iTEM_NAME)
        mODEL_NO = try values.decodeIfPresent(String.self, forKey: .mODEL_NO)
        bRAND = try values.decodeIfPresent(String.self, forKey: .bRAND)
        iTEM_THUMBNAIL = try values.decodeIfPresent(String.self, forKey: .iTEM_THUMBNAIL)
        iTEM_REPAIR_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_REPAIR_ID)
        rEPAIR_STATUS = try values.decodeIfPresent(String.self, forKey: .rEPAIR_STATUS)
        rEPAIR_PRICE = try values.decodeIfPresent(String.self, forKey: .rEPAIR_PRICE)
        rEPAIR_DATE = try values.decodeIfPresent(String.self, forKey: .rEPAIR_DATE)
        rEMARKS = try values.decodeIfPresent(String.self, forKey: .rEMARKS)
    }

}
struct  repairDetails : Codable {
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
