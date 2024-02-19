//
//  Staple.swift
//  TasteMaster
//
//  Created by Sekiro on 28/10/2023.
//

import Foundation
import SwiftUI


struct Staple: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        NavigationStack {
            CardPlacer(cardInfoList: StapleManager.getCardInfoArray(), color: colorScheme)
                    .navigationTitle("主食")
            
        }
    }
}

struct previewStaple: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Staple()
        }
    }
}


