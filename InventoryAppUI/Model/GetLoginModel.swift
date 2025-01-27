//
//  GetLoginModel.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 27/01/25.
//

import Foundation

struct GetLoginModel : Codable {
    let status : Bool?
    let message : String?
    let data : GetLogin?
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
        data = try values.decodeIfPresent(GetLogin.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
struct GetLogin : Codable {
    let username : String?
    let email : String?
    let mobile : String?
    let empCode : String?

    enum CodingKeys: String, CodingKey {

        case username = "username"
        case email = "email"
        case mobile = "mobile"
        case empCode = "EmpCode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
    }
}
