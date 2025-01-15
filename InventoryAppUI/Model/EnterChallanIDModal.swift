//
//  EnterChallanIDModal.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 14/01/25.
//

import Foundation

struct EnterChallanIDModal : Codable {
    let error : String?
    let status : Bool?
    let message : String?
    let data : ChallanIDModal?

    enum CodingKeys: String, CodingKey {

        case error = "error"
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ChallanIDModal.self, forKey: .data)
    }

}

struct ChallanIDModal : Codable {
    let rENTAMOUNT : String?
    let location : String?
    let showEndDate : String?
    let gst_no : String?
    let vehicleNo : String?
    let consignee : String?
    let client_name : String?
    let company_name_and_address : String?
    let temp_id : String?
    let eway_bill_transaction : String?
    let team_member : String?
    let vehicle : String?
    let products : [Products]?
    let state : String?
    let items_in_cart : String?
    let transport_id : String?
    let mobileNo : String?
    let items_quantity_detail : String?
    let pincode : String?
    let inventoryLoadingDate : String?
    let eway_bill_date : String?
    let contactPerson : String?
    let eway_bill_no : String?
    let transporter : String?
    let consigner : String?
    let hsn_sac_code : String?
    let showStartDate : String?

    enum CodingKeys: String, CodingKey {

        case rENTAMOUNT = "RENTAMOUNT"
        case location = "location"
        case showEndDate = "showEndDate"
        case gst_no = "gst_no"
        case vehicleNo = "vehicleNo"
        case consignee = "consignee"
        case client_name = "client_name"
        case company_name_and_address = "company_name_and_address"
        case temp_id = "temp_id"
        case eway_bill_transaction = "eway_bill_transaction"
        case team_member = "team_member"
        case vehicle = "vehicle"
        case products = "products"
        case state = "state"
        case items_in_cart = "items_in_cart"
        case transport_id = "transport_id"
        case mobileNo = "mobileNo"
        case items_quantity_detail = "items_quantity_detail"
        case pincode = "pincode"
        case inventoryLoadingDate = "inventoryLoadingDate"
        case eway_bill_date = "eway_bill_date"
        case contactPerson = "contactPerson"
        case eway_bill_no = "eway_bill_no"
        case transporter = "transporter"
        case consigner = "consigner"
        case hsn_sac_code = "hsn_sac_code"
        case showStartDate = "showStartDate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rENTAMOUNT = try values.decodeIfPresent(String.self, forKey: .rENTAMOUNT)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        showEndDate = try values.decodeIfPresent(String.self, forKey: .showEndDate)
        gst_no = try values.decodeIfPresent(String.self, forKey: .gst_no)
        vehicleNo = try values.decodeIfPresent(String.self, forKey: .vehicleNo)
        consignee = try values.decodeIfPresent(String.self, forKey: .consignee)
        client_name = try values.decodeIfPresent(String.self, forKey: .client_name)
        company_name_and_address = try values.decodeIfPresent(String.self, forKey: .company_name_and_address)
        temp_id = try values.decodeIfPresent(String.self, forKey: .temp_id)
        eway_bill_transaction = try values.decodeIfPresent(String.self, forKey: .eway_bill_transaction)
        team_member = try values.decodeIfPresent(String.self, forKey: .team_member)
        vehicle = try values.decodeIfPresent(String.self, forKey: .vehicle)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        items_in_cart = try values.decodeIfPresent(String.self, forKey: .items_in_cart)
        transport_id = try values.decodeIfPresent(String.self, forKey: .transport_id)
        mobileNo = try values.decodeIfPresent(String.self, forKey: .mobileNo)
        items_quantity_detail = try values.decodeIfPresent(String.self, forKey: .items_quantity_detail)
        pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
        inventoryLoadingDate = try values.decodeIfPresent(String.self, forKey: .inventoryLoadingDate)
        eway_bill_date = try values.decodeIfPresent(String.self, forKey: .eway_bill_date)
        contactPerson = try values.decodeIfPresent(String.self, forKey: .contactPerson)
        eway_bill_no = try values.decodeIfPresent(String.self, forKey: .eway_bill_no)
        transporter = try values.decodeIfPresent(String.self, forKey: .transporter)
        consigner = try values.decodeIfPresent(String.self, forKey: .consigner)
        hsn_sac_code = try values.decodeIfPresent(String.self, forKey: .hsn_sac_code)
        showStartDate = try values.decodeIfPresent(String.self, forKey: .showStartDate)
    }

}

struct Products : Codable , Identifiable {
    var id: String { iTEM_MASTER_ID ?? UUID().uuidString }
    let mODEL_NO : String?
    let iTEM_MASTER_ID : String?
    let iTEM_NAME : String?
    let iTEM_THUMBNAIL : String?
    let iSSUED_ITEMS : String?
    let bRAND : String?

    enum CodingKeys: String, CodingKey {

        case mODEL_NO = "MODEL_NO"
        case iTEM_MASTER_ID = "ITEM_MASTER_ID"
        case iTEM_NAME = "ITEM_NAME"
        case iTEM_THUMBNAIL = "ITEM_THUMBNAIL"
        case iSSUED_ITEMS = "ISSUED_ITEMS"
        case bRAND = "BRAND"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mODEL_NO = try values.decodeIfPresent(String.self, forKey: .mODEL_NO)
        iTEM_MASTER_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_MASTER_ID)
        iTEM_NAME = try values.decodeIfPresent(String.self, forKey: .iTEM_NAME)
        iTEM_THUMBNAIL = try values.decodeIfPresent(String.self, forKey: .iTEM_THUMBNAIL)
        iSSUED_ITEMS = try values.decodeIfPresent(String.self, forKey: .iSSUED_ITEMS)
        bRAND = try values.decodeIfPresent(String.self, forKey: .bRAND)
    }

}
