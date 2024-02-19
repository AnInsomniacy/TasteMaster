//
//  GlobalSearch.swift
//  TasteMaster
//
//  Created by Sekiro on 13/10/2023.
//

import Foundation
import SwiftUI


struct GlobalSearch: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    //创建文本存储搜索内容
    @State var searchText = ""
    //cardinfo组成的数组
    @State var cardListResults = [CardInfo]()
    
    @State var isChecking = false
    @State var CheckButtonText = "开始搜索"
    @State var SearchResultBlank = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("搜索", text: $searchText)
                        .padding(.vertical, 14)
                }
                .padding(.horizontal, 14)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                HStack {
                    
                    // 重置搜索框按钮
                    Button(action: {
                        searchText = ""
                        cardListResults.removeAll()
                        SearchResultBlank = ""
                    }, label: {
                        Text("重置内容")
                            .fontWeight(.semibold)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(12)
                    })
                    
                    // 执行搜索按钮
                    Button(action: {
                        cardListResults.removeAll()
                        isChecking = true
                        CheckButtonText = "正在搜索"
                        //收起键盘
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        // 异步调用
                        Task {
                            do {
                                cardListResults += try await AllCardsManager.searchCardInfoUnStrictAsync(text: searchText)
                                if cardListResults.isEmpty {
                                    SearchResultBlank = "无匹配项目"}
                            } catch {
                                print("搜索出错")
                            }
                        }
                        isChecking = false
                        CheckButtonText = "开始搜索"
                    }, label: {
                        Text(CheckButtonText)
                            .fontWeight(.semibold)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(isChecking ? Color.gray : Color.green)
                            .cornerRadius(12)
                    })
                    
                }
                .padding(.top, 10) // 可根据需要调整垂直间距
            }
            ScrollView {
                //判定搜索结果是否为空
                if cardListResults.isEmpty {
                    Text(SearchResultBlank).font(.title).foregroundColor(.gray).padding()
                }
                //判定搜索结果是否为空
                if !cardListResults.isEmpty{
                    CardPlacer(cardInfoList: cardListResults, color: colorScheme)
                }
            } .padding(10).navigationTitle("全局搜索")
        }
    }
}


struct GlobalSearchPreview: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            GlobalSearch()
        }
    }
}
