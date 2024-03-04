//
//  SearchAccount.swift
//  TasteMaster
//
//  Created by Sekiro on 4/3/2024.
//

import Foundation
import SwiftUI

import SwiftUI

struct SearchAccount: View {
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            VStack {
                // 搜索框和图标
                HStack {
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    TextField("请输入用户名", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                }
                .padding(.horizontal)
                
                // 确认和取消按钮
                HStack {
                    
                    Button(action: {
                        // 在这里添加取消操作
                        // 例如：print("点击了取消按钮")
                    }) {
                        Text("取消搜索")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // 在这里添加确认操作
                        // 例如：print("点击了确认按钮")
                    }) {
                        Text("开始搜索")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
        }
        .padding(.top, 20)
    }
}


#Preview {
    NavigationStack{
        SearchAccount().navigationTitle("搜索账户")
    }
}
