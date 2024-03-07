//
//  SearchArticle.swift
//  TasteMaster
//
//  Created by Sekiro on 7/3/2024.
//

import Foundation
import SwiftUI

struct SearchArticle: View {
    
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack {
                // 输入搜索关键字
                TextField("输入搜索关键字", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                // 确认搜索和取消搜索按钮
                HStack {

                    Button(action: {
                        // 执行取消搜索操作
                        // 在这里添加你的取消搜索逻辑
                        searchText = ""
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("取消搜索")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    
                    
                        Button(action: {
                            // 执行搜索操作，使用 searchText
                            // 在这里添加你的搜索逻辑
                            print("搜索关键字: \(searchText)")
                        }) {
                            Text("确认搜索")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    
                }
            }
            .padding()
        }
    }
}


#Preview {
    NavigationStack{
        SearchArticle().navigationTitle("搜索文章")
    }
}
