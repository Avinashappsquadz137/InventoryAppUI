//
//  GetItemRepairByIdModel.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 01/02/25.
//

import Foundation

struct GetItemRepairByIdModel : Codable {
    let status : Bool?
    let message : String?
    let data : ItemRepairById?
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
        data = try values.decodeIfPresent(ItemRepairById.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
struct ItemRepairById : Codable {
    let id : String?
    let emp_code : String?
    let product_id : String?
    let repairing_price : String?
    let repair_address : String?
    let receipt_center_phoneno : String?
    let item_thumbnail : String?
    let receipt_bill : String?
    let remarks : String?
    let repair_date : String?
    let issue_date : String?
    let creation_time : String?
    let updation_time : String?
    let status : String?
    let product_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case emp_code = "emp_code"
        case product_id = "product_id"
        case repairing_price = "repairing_price"
        case repair_address = "repair_address"
        case receipt_center_phoneno = "receipt_center_phoneno"
        case item_thumbnail = "item_thumbnail"
        case receipt_bill = "receipt_bill"
        case remarks = "remarks"
        case repair_date = "repair_date"
        case issue_date = "issue_date"
        case creation_time = "creation_time"
        case updation_time = "updation_time"
        case status = "status"
        case product_name = "product_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        emp_code = try values.decodeIfPresent(String.self, forKey: .emp_code)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        repairing_price = try values.decodeIfPresent(String.self, forKey: .repairing_price)
        repair_address = try values.decodeIfPresent(String.self, forKey: .repair_address)
        receipt_center_phoneno = try values.decodeIfPresent(String.self, forKey: .receipt_center_phoneno)
        item_thumbnail = try values.decodeIfPresent(String.self, forKey: .item_thumbnail)
        receipt_bill = try values.decodeIfPresent(String.self, forKey: .receipt_bill)
        remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
        repair_date = try values.decodeIfPresent(String.self, forKey: .repair_date)
        issue_date = try values.decodeIfPresent(String.self, forKey: .issue_date)
        creation_time = try values.decodeIfPresent(String.self, forKey: .creation_time)
        updation_time = try values.decodeIfPresent(String.self, forKey: .updation_time)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
    }

}
