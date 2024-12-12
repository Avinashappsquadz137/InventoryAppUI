//
//  MainViewVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI

struct MainViewVC: View {
    var body: some View {
        ItemDetailCell(
                   itemName: "Item Name",
                   itemDetail: "dfghfdhfh",
                   itemDesc: "Descrifgjnsdfgxbgdfgb",
                   itemCount: "3",
                   itemImage: UIImage(named: "ic_favourite_tabbar") ?? UIImage() 
               )
     
    }
}

#Preview {
    MainViewVC()
}
