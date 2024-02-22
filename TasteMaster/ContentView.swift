//
//  ContentView.swift
//  TasteMaster
//
//  Created by Sekiro on 13/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 0 // 默认选中的Tab
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        TabView(selection: $selectedTab) {
            //基本技能
            NavigationStack {
                CardPlacer(cardInfoList: BasicSkillsCardsManager.getCardInfoArray(),color: colorScheme)
                    .navigationTitle("基本技能")
                
                
            }
            .tabItem {
                Image(systemName: "sparkles")
                Text("基本技能")
            }.tag(0)
            
            //菜谱分类
            NavigationStack {
                CardPlacer(cardInfoList: DishMenuCardsManager.getCardInfoArray(),color: colorScheme)
                    .navigationTitle("菜谱分类")
            }.tabItem {
                Image(systemName: "book.closed")
                Text("菜谱分类")
            }.tag(1)
            
            //味评共鉴
            NavigationStack {
                CloudSpace()
                    .navigationTitle("味评共鉴")
            }.tabItem {
                Image(systemName: "cloud")
                Text("味评共鉴")
            }.tag(2)
            
            //私厨空间
            NavigationStack {
                AccountManage().navigationTitle("私厨空间")
            }.tabItem {
                Image(systemName: "pencil.and.outline")
                Text("私厨空间")
            }.tag(3)
            
            //更多功能
            NavigationStack {
                CardPlacer(cardInfoList: ExtraFunctionsCardsManager.getCardInfoArray(),color: colorScheme)
                    .navigationTitle("更多功能")
            }.tabItem {
                Image(systemName: "slider.horizontal.3")
                Text("更多功能")
            }.tag(4)
            
        }
    }
}

#Preview {
    ContentView()
}
