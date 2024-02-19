//
//  Soup.swift
//  TasteMaster
//
//  Created by Sekiro on 28/10/2023.
//

import Foundation
import SwiftUI


struct Soup: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        NavigationStack {
            CardPlacer(cardInfoList: SoupManager.getCardInfoArray(), color: colorScheme)
                    .navigationTitle("汤与粥")
        }
    }
}

struct previewSoup: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Soup()
        }
    }
}
