//
//  CloudStore.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation
import SwiftUI

struct CloudSpace: View{
    
    let cardData = AccountCardData()//卡片规格信息
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    @ObservedObject var getArticle = GetArticleRequest()
    
    var body: some View{
        ScrollView{
            
            HStack(spacing: -16){
                Button(action: {
                    Task{
                        do{
                            try await getArticle.request()
                        }
                    }
                }){
                    RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                        .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                        .overlay(
                            HStack {
                                
                                Text("刷新文章").foregroundColor(Color.primary)
                                
                            }
                        )
                        .padding()
                        .frame(height: 100) // 设置 HStack 的固定宽度
                        .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                .padding()
                            
                        )
                }
                
                //搜索文章
                NavigationLink(destination: Text("搜索文章").navigationTitle("搜索文章")){
                    RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                        .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                        .overlay(
                            HStack {
                                Text("搜索文章  ->").foregroundColor(Color.primary)
                            }
                        )
                        .padding()
                        .frame(height: 100) // 设置 HStack 的固定宽度
                        .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                .padding()
                            
                        )
                }
                
            }
            //渲染文章卡片
            VStack(spacing: -16){
                if let response = getArticle.response{
                    ForEach(response.articleList, id: \.articleID){ article in
                        ArticleCard(avatarUrl_input: article.articleImageURL, author_name: article.articleAuthor            ,article_title: article.articleTitle, article_id: article.articleID)
                    }
                }
            }
            
            
        }.onAppear{
            Task{
                do{
                    try await getArticle.request()
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

//获取接口
class GetArticleRequest: ObservableObject{
    
    @Published var response: RandomArticleResponse?
    
    func request() async throws{
        // 构建获取关注用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/get_random_ten_articles/") else {
            return
        }
        
        //构建GET请求
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //设置请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            // 发起请求
            let (data, _) = try await URLSession.shared.data(for: request)
            // 解析返回的数据
            let decodedData = try JSONDecoder().decode(RandomArticleResponse.self, from: data)
            // 更新response,在主线程
            DispatchQueue.main.async {
                self.response = decodedData
            }
        
        } catch {
            print(error)
        }
        
        
    }
}

#Preview {
    NavigationStack{
        CloudSpace().navigationTitle("味评共鉴")
    }
}
