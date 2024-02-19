//
//  CommonEquipments.swift
//  TasteMaster
//
//  Created by Sekiro on 13/10/2023.
//

import Foundation
import SwiftUI


struct CommonEquipments: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        CardPlacer(cardInfoList: CommonEquipmentsCardsManager.getCardInfoArray(), color: colorScheme)
            .navigationTitle("常用器材")
        }
    }

struct CommonEquipmentsPreview: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CommonEquipments()
        }
    }
}
