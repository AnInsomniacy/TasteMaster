//
//  Meat.swift
//  TasteMaster
//
//  Created by Sekiro on 28/10/2023.
//

import Foundation
import SwiftUI


struct Meat: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        NavigationStack {
            CardPlacer(cardInfoList: MeatCardsManager.getCardInfoArray(), color: colorScheme)
                    .navigationTitle("荤菜")
            }
        }
    }

struct previewMeat: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Meat()
        }
    }
}
