//
//  CookBookMainUI.swift
//  TasteMaster
//
//  Created by Sekiro on 25/10/2023.
//

import Foundation
import SwiftUI


struct Vegetarian: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        NavigationStack {
            
            CardPlacer(cardInfoList: VegetarianCardsManager.getCardInfoArray(), color: colorScheme)
                .navigationTitle("素菜")
        }
    }
}

struct previewVegetarian: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Vegetarian()
        }
    }
}
