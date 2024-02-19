//
//  Breakfast.swift
//  TasteMaster
//
//  Created by Sekiro on 28/10/2023.
//

import Foundation
import SwiftUI


struct Breakfast: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        NavigationStack {
            CardPlacer(cardInfoList: BreakfastManager.getCardInfoArray(), color: colorScheme)
                    .navigationTitle("早餐")
        }
    }
}

struct previewBreakfast: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Breakfast()
        }
    }
}

