//
//  CrewMemberModel.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 11/01/25.
//

import Foundation

struct CrewMemberModel : Codable {
    let data : [CrewMember]?
    let status : Bool?
    let message : String?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case status = "status"
        case message = "message"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([CrewMember].self, forKey: .data)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct CrewMember : Codable {
    let mobile : String?
    let emp_code : String?
    let creation_time : String?
    let id : String?
    let status : String?
    let email : String?
    let emp_name : String?

    enum CodingKeys: String, CodingKey {

        case mobile = "mobile"
        case emp_code = "emp_code"
        case creation_time = "creation_time"
        case id = "id"
        case status = "status"
        case email = "email"
        case emp_name = "emp_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        emp_code = try values.decodeIfPresent(String.self, forKey: .emp_code)
        creation_time = try values.decodeIfPresent(String.self, forKey: .creation_time)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        emp_name = try values.decodeIfPresent(String.self, forKey: .emp_name)
    }

}
