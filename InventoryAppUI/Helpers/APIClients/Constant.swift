//
//  Constant.swift
//  Binko Movi
//
//  Created by Warln on 20/08/22.


import UIKit

class ApiRequest {
    static let shared = ApiRequest()
    
    enum BuildType {
        case dev
        case pro
    }
    
    struct Url {
        static var buildType: BuildType = .dev
        
        static var serverURL: String {
            switch buildType {
            case .dev:
                return "https://store.totalbhakti.com/tmedia/"
            case .pro:
                return "https://store.totalbhakti.com/tmedia/"
            }
        }
    }
}

struct Constant {

    static let BASEURL                     = ApiRequest.Url.serverURL
    
    static let getlogin                    = "api_panel/login"
    static let getAllItem                  = "api_panel/get_all_item"
    static let allcartlistByDate           = "api_panel/all_cart_list_by_date"
    static let addtocart                   = "api_panel/add_to_cart"
    static let addToCartByItemQr           = "api_panel/add_to_cart_by_item_qr"
    static let deleteCartItem              = "api_panel/delete_cart_item"
    static let requestdetailapi            = "api_panel/order_list"
    static let addSaveChallanmaster        = "api_panel/add_save_challan_master"
    static let getCrewMember               = "api_panel/get-crew-member"
    static let getItemDetailByChallanId    = "api_panel/get_item_detail_by_challan_id"
    static let getItemByDate               = "api_panel/get_item_by_date"
    static let returnItemByChallanId       = "api_panel/return_item_by_challan_id"
    static let getInventoryDetail          = "api_panel/get_inventory_detail"
    static let createOrderByCartItem       = "api_panel/create_order_by_cart_item"
    static let getTransportCategory        = "api_panel/get_transport_category"

}


