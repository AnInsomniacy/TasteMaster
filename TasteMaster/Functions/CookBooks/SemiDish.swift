//
//  SemiDish.swift
//  TasteMaster
//
//  Created by Sekiro on 28/10/2023.
//

import Foundation
import SwiftUI


struct SemiDish: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        NavigationStack {
            CardPlacer(cardInfoList: SemiDishManager.getCardInfoArray(), color: colorScheme)
                    .navigationTitle("半成品加工")
        }
    }
}

struct previewSemiDish: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SemiDish()
        }
    }
}



