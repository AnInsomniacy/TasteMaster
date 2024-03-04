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
    @ObservedObject var searchAccount = SearchAccountRequest()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var isSearching = false
    @State var user_list = [SearchAccountUserInfo]()
    @State var resultText = "请输入要查询的用户名"

    var body: some View {
        ScrollView {
            VStack {
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

                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("取消搜索")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }

                    Button(action: {

                        //如果搜索框为空，不执行搜索
                        if searchText == "" {
                            resultText = "查询内容不能为空"
                            return
                        }
                        
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                        Task {
                            // 设置搜索状态
                            isSearching = true

                            do {
                                try await searchAccount.request(username: searchText)
                                
                                user_list = searchAccount.searchAccountResponse!.user_info_list
                                
                                if user_list.isEmpty == true {
                                    resultText = "没有找到相关用户"
                                } else {
                                    resultText = "找到了\(user_list.count)个用户"
                                }
                                
                                for user in searchAccount.searchAccountResponse!.user_info_list {
                                    print(user)
                                    print("")
                                }
                            } catch {
                                print(error)
                            }

                            // 恢复搜索状态
                            isSearching = false
                        }
                    }) {
                        Text(isSearching ? "正在搜索" : "开始搜索")
                            .foregroundColor(.white)
                            .padding()
                            .background(isSearching ? Color.gray.opacity(0.7) : colorScheme == .dark ? Color.blue : Color.blue)
                            .cornerRadius(8)
                            .disabled(isSearching)
                    }

                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Text(resultText)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                    .bold()
                    .font(.title)

                VStack(spacing: -16) {
                        ForEach(user_list, id: \.currentUserId) { user in
                            UserBriefInfo(avatarUrl_input: user.avatarUrl, currentUsername_input: user.currentUsername, user_id: String(user.currentUserId))
                        }
                }
            }
        }
        .padding(.top, 20)
    }
}


// 查询账户页面的API
//响应数据
struct SearchAccountResponse: Codable {
    var result: String
    var user_info_list: [SearchAccountUserInfo]
}

//用户信息Json
struct SearchAccountUserInfo: Codable {
    var currentUserId: Int
    var currentUsername: String
    var avatarUrl: String
    var selfIntroduction: String
    var followerNum: Int
    var fanNum: Int
    var articleNum: Int
}

//构建请求API
class SearchAccountRequest: ObservableObject {
    
    @Published var searchAccountResponse: SearchAccountResponse?
    
    func request(username: String) async throws {
        // 构建获取URL
        guard let url = URL(string: baseURL + "/api/search_user_by_username/") else {
            return
        }
        
        //创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //设置请求体
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "username", value: username)
        ]
        
        if let query = bodyComponents.percentEncodedQuery {
            request.httpBody = Data(query.utf8)
        }
        
        //发送请求
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(SearchAccountResponse.self, from: data)
            
            //主线程更新UI
            DispatchQueue.main.async {
                self.searchAccountResponse = response
            }
        }catch{
            print(error)
        }
    }
}

#Preview {
    NavigationStack{
        SearchAccount().navigationTitle("搜索账户")
    }
}
