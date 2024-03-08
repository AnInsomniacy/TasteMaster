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
    @State private var isSearching = false
    @State private var searchResultText = "开始搜索"
    @State private var articles: [SearchArticleData] = []
    @State private var buttonColor: Color = .blue
    @State private var successColor: Color = .green
    @State private var failureColor: Color = .red
    @State private var showAlert = false // 用于控制搜索内容为空的提示
    @State private var showNoMatchMessage = false // 用于控制无匹配文章的提示
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
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
                    Button(action: {
                        searchText = ""
                    }, label: {
                        Text("重置内容")
                            .fontWeight(.semibold)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(12)
                    })
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        if searchText.isEmpty {
                            // 搜索框为空，弹出提示
                            showAlert = true
                            return
                        }
                        
                        Task {
                            do {
                                isSearching = true
                                searchResultText = "正在搜索"
                                
                                let request = SearchArticleRequest()
                                request.keyword = searchText
                                try await request.request()
                                
                                if let response = request.response {
                                    print(response)
                                    articles = response.articleList
                                    showNoMatchMessage = articles.isEmpty
                                }
                                
                                isSearching = false
                                searchResultText = "搜索成功"
                                buttonColor = successColor
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                withAnimation {
                                    searchResultText = "开始搜索"
                                    buttonColor = .blue
                                }
                            } catch {
                                print(error)
                                isSearching = false
                                searchResultText = "搜索失败"
                                buttonColor = failureColor
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                withAnimation{
                                    searchResultText = "开始搜索"
                                    buttonColor = .blue
                                }
                            }
                        }
                    }, label: {
                        Text(searchResultText)
                            .fontWeight(.semibold)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(isSearching ? Color.gray : buttonColor)
                            .cornerRadius(12)
                    })
                }
                .padding(.top, 10)
                
                VStack(spacing: -16) {
                    ForEach(articles, id: \.articleID) { article in
                        ArticleCard(avatarUrl_input: article.articleImageURL, author_name: article.articleAuthor, article_title: article.articleTitle, article_id: article.articleID)
                    }
                    
                    if showNoMatchMessage && !isSearching {
                        Text("无匹配文章")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .bold()
                            .font(.title)
                    }
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("注意"), message: Text("搜索内容不能为空"), dismissButton: .default(Text("确定")))
            }
        }
    }
}






//后端适配
//返回结构体
struct SearchArticleResponse: Codable {
    var result: String
    //文章数
    var articleCount: Int
    //文章列表
    var articleList: [SearchArticleData]
}

//文章结构体
struct SearchArticleData: Codable {
    var articleID: Int
    var articleTitle: String
    var articleImageURL: String
    var articleAuthor: String
    var authorID: Int
    var createTime: String
    var updateTime: String
}

//请求类
class SearchArticleRequest: ObservableObject{
    @Published var response: SearchArticleResponse?
    @Published var keyword: String = ""
    
    func request() async throws{
        // 构建获取关注用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/search_article_by_keyword/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "keyword", value: keyword),
        ]
        
        
        if let query = bodyComponents.percentEncodedQuery {
            request.httpBody = Data(query.utf8)
        }
        
        
        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(SearchArticleResponse.self, from: data)
            
            // 在主线程更新关注用户列表信息
            DispatchQueue.main.async {
                self.response = result
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
        
        
    }
    
}


#Preview {
    NavigationStack{
        SearchArticle().navigationTitle("搜索文章")
    }
}
