//
//  Condiment.swift
//  TasteMaster
//
//  Created by Sekiro on 28/10/2023.
//

import Foundation
import SwiftUI


struct Condiment: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        NavigationStack {
           CardPlacer(cardInfoList: CondimentManager.getCardInfoArray(), color: colorScheme)
                    .navigationTitle("酱料和其它材料")
        }
    }
}

struct previewCondiment: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Condiment()
        }
    }
}
