//
//  MyFavorite.swift
//  TasteMaster
//
//  Created by Sekiro on 25/10/2023.
//

import Foundation
import SwiftUI

struct MyFavorite: View{
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    @StateObject var favoriteManager = FavoriteCardsInfoManager
    
    var body: some View {
        NavigationStack {
            ScrollView{
                
                if FavoriteCardsInfoManager.favoriteCards.count == 0 {
                    Text("您还没有收藏任何卡片")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding()
                }else{
                    //清空收藏按钮
                    Button(action: {
                        FavoriteCardsInfoManager.clear()
                    }, label: {
                        Text("清空收藏")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .overlay(  
                                // 这里添加边框
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .padding([.top, .bottom], 10)  // 根据需要添加额外的内边距
                    }
                    )
                }
                
                CardPlacer(cardInfoList: favoriteManager.getFavoriteCards(), color: colorScheme)
                    .navigationTitle("我的收藏")
            }
        }
    }
}


struct MyFavoritePreview: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MyFavorite()
        }
    }
}
