//
//  CloudStore.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation
import SwiftUI

struct CloudSpace: View {
    
    let cardData = AccountCardData()
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var getArticle = GetArticleRequest()
    
    @State var refreshButtonText = "刷新文章"
    @State var isRefreshing = false
    @State var buttonColor: Color = .purple
    @State var articles: [ArticleData] = [] // 添加一个数组来存储文章
    @State var loadedContent = false // 添加标志以检查是否已加载内容
    
    var body: some View {
        ScrollView {
            HStack(spacing: -16) {
                Button(action: {
                    Task {
                        isRefreshing = true
                        refreshButtonText = "正在刷新"
                        buttonColor = .gray
                        
                        do {
                            try await getArticle.request()
                            
                            withAnimation {
                                refreshButtonText = "刷新完成"
                                buttonColor = .green
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    refreshButtonText = "刷新文章"
                                    isRefreshing = false
                                    buttonColor = .purple
                                    articles = getArticle.response?.articleList ?? [] // 更新文章数组
                                }
                            }
                        } catch RequestError.timeoutError {
                            print("请求超时")
                        } catch {
                            print("错误: \(error.localizedDescription)")
                            
                            withAnimation {
                                refreshButtonText = "刷新失败"
                                buttonColor = .red
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    refreshButtonText = "刷新文章"
                                    isRefreshing = false
                                    buttonColor = .purple
                                }
                            }
                        }
                    }
                }) {
                    RoundedRectangle(cornerRadius: cardData.cornerRadius)
                        .foregroundColor(buttonColor)
                        .overlay(
                            HStack {
                                Text(refreshButtonText)
                                    .foregroundColor(.white)
                            }
                        )
                        .padding()
                        .frame(height: 100)
                        .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                .padding()
                        )
                }
                
                NavigationLink(destination: SearchArticle().navigationTitle("搜索文章")) {
                    RoundedRectangle(cornerRadius: cardData.cornerRadius)
                        .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight)
                        .overlay(
                            HStack {
                                Text("搜索文章  ->").foregroundColor(Color.primary)
                            }
                        )
                        .padding()
                        .frame(height: 100)
                        .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                .padding()
                        )
                }
            }
            
            VStack(spacing: -16) {
                // 使用新的数组来渲染文章卡片
                ForEach(articles, id: \.articleID) { article in
                    ArticleCard(avatarUrl_input: article.articleImageURL, author_name: article.articleAuthor, article_title: article.articleTitle, article_id: article.articleID)
                }
                
                if articles.isEmpty {
                    Text("暂无文章")
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                        .bold()
                        .font(.title)
                }
            }
        }
        .onAppear {
            Task {
                // 只有在数组为空且未加载内容时执行刷新操作
                if articles.isEmpty && !loadedContent {
                    do {
                        try await getArticle.request()
                        articles = getArticle.response?.articleList ?? [] // 初始化文章数组
                        
                        // 标记为已加载内容
                        loadedContent = true
                    } catch {
                        print("错误: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}




//后端数据适配
//返回结构体,随即返回十篇文章的结构体
struct RandomArticleResponse: Codable {
    var result: String
    //文章数目
    var articleCount: Int
    //文章列表
    var articleList: [ArticleData]
}

//文章结构体
struct ArticleData: Codable {
    var articleID: Int
    var articleTitle: String
    var articleImageURL: String
    var articleAuthor: String
    var createTime: String
    var updateTime: String
}

enum RequestError: Error {
    case timeoutError
}


class GetArticleRequest: ObservableObject {
    
    @Published var response: RandomArticleResponse?
    
    func request() async throws {
        // 构建获取关注用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/get_random_ten_articles/") else {
            return
        }
        
        // 构建GET请求
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 设置请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // 发起请求，设置超时时间为5秒
            let (data, _) = try await withThrowingTaskGroup(of: (Data, URLResponse).self) { group in
                try await URLSession.shared.data(for: request)
            }
            
            // 解析返回的数据
            let decodedData = try JSONDecoder().decode(RandomArticleResponse.self, from: data)
            
            // 更新response，在主线程
            DispatchQueue.main.async {
                self.response = decodedData
            }
        } catch {
            print(error)
            
            // 处理超时错误
            if case URLError.timedOut = error {
                throw RequestError.timeoutError
            } else {
                throw error
            }
        }
    }
}


#Preview {
    NavigationStack{
        CloudSpace().navigationTitle("味评共鉴")
    }
}
