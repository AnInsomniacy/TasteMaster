//
//  DetailDataConnector.swift
//  TasteMaster
//
//  Created by Sekiro on 21/2/2024.
//

import Foundation
import SwiftUI
import URLImage

//用户简要卡片信息
struct UserBriefInfo: View{
    
    @State var avatarUrl_input:String?
    @State var currentUsername_input:String
    @State var user_id:String
    @State var followButtonText:String = "立即关注"
    @State var followButtonColor:Color = .indigo
    
    @State var isFollowed:Bool = false
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    
    var body: some View{
        let cardData = AccountCardData()//卡片规格信息
        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
            .overlay(
                VStack{
                    
                    HStack{
                        VStack(spacing: -26){
                            if let avatarURLString = avatarUrl_input,
                               let avatarURL = URL(string: avatarURLString) {
                                URLImage(avatarURL) {
                                    // 显示加载中的占位图像
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } inProgress: { progress in
                                    // 显示下载进度
                                    Image(systemName: "cloud")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } failure: { error, retry in
                                    // 显示错误信息和重试按钮
                                    VStack {
                                        Text(error.localizedDescription)
                                        Button("重试", action: retry)
                                    }
                                } content: { image in
                                    // 下载完成的图片
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }.padding()
                            } else {
                                // 处理当 avatar_url 为 nil 或无法转换为 URL 的情况
                                // 可以显示默认的占位图像或采取其他处理方式
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                            }
                            
                            
                            Text(currentUsername_input)
                                .font(.title)
                                .fontWeight(.bold)
                            
                                .lineLimit(1) // 没有行数限制，自动换行
                                .fixedSize(horizontal: false, vertical: true).padding()
                        }
                        
                        VStack(spacing: -12){
                            
                            //查看主页按钮
                            NavigationLink(destination:UserMainPage(user_id: user_id)
                                .navigationTitle("用户主页")
                            ){
                                Text("查看主页")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }.padding()
                            
                            //关注判定按钮
                            Button(action: {
                                
                                if isFollowed {
                                    Task{
                                        do{
                                            
                                            let result = try await unfollowUser(unfollow_user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                                            
                                            isFollowed.toggle()
                                            followButtonText = isFollowed ? "取消关注" : "立即关注"
                                            followButtonColor = isFollowed ? .red : .indigo
                                            
                                            print(result)
                                            
                                        }catch{
                                            print("关注失败")
                                        }
                                    }
                                } else {
                                    
                                    Task{
                                        do{
                                            
                                            let result = try await followUser(follow_user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                                            
                                            isFollowed.toggle()
                                            followButtonText = isFollowed ? "取消关注" : "立即关注"
                                            followButtonColor = isFollowed ? .red : .indigo
                                            
                                            print(result)
                                            
                                        }catch{
                                            print("取消关注失败")
                                        }
                                    }
                                    
                                }
                                
                                
                            }) {
                                Text(followButtonText)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(followButtonColor)
                                    .cornerRadius(10)
                            }.padding()
                            
                        }
                        
                    }.padding()
                    
                    
                }
            ).padding().frame(height: 200).frame(maxWidth: 540)
            .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                    .padding()
            ).onAppear{
                //界面一出现就判定是否关注
                Task{
                    do{
                        isFollowed = try await getFollowStatus(user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                        
                        followButtonText = isFollowed ? "取消关注" : "立即关注"
                        
                        followButtonColor = isFollowed ? .red : .indigo
                        
                    }
                }
            }
    }
}

// 用户信息模型
struct UserInfo: Codable {
    let currentUsername: String
    let currentUserId: Int
    let avatarUrl: String?
    let selfIntroduction: String
    let followerNum: Int
    let fanNum: Int
    let articleNum: Int
    
    private enum CodingKeys: String, CodingKey {
        case currentUsername
        case currentUserId
        case avatarUrl
        case selfIntroduction
        case followerNum
        case fanNum
        case articleNum
    }
}

// 获取关注用户列表响应模型
struct FollowedUserInfoResponse: Codable {
    let result: String
    let followedUserInfoList: [UserInfo]?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case followedUserInfoList = "followed_user_info_list"
    }
}

// 获取粉丝用户列表响应模型
struct FanUserInfoResponse: Codable {
    let result: String
    let fanUserInfoList: [UserInfo]?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case fanUserInfoList = "fans_user_info_list"
    }
}

// 获取关注用户列表视图模型
class FollowedUserInfoViewModel: ObservableObject {
    // 发布关注用户列表的变量
    @Published var followedUserInfoList: [UserInfo]?
    
    // 修改获取关注用户列表函数为异步函数，并允许抛出错误
    func getFollowedUserInfo(user_id: String) async throws {
        // 构建获取关注用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/show_followers/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "user_id", value: user_id)
        ]
        
        if let bodyString = bodyComponents.query {
            request.httpBody = bodyString.data(using: .utf8)
        }
        
        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(FollowedUserInfoResponse.self, from: data)
            
            // 在主线程更新关注用户列表信息
            DispatchQueue.main.async {
                self.followedUserInfoList = result.followedUserInfoList
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}

// 获取粉丝用户列表视图模型
class FanUserInfoViewModel: ObservableObject {
    // 发布粉丝用户列表的变量
    @Published var fanUserInfoList: [UserInfo]?
    
    // 修改获取粉丝用户列表函数为异步函数，并允许抛出错误
    func getFanUserInfo(user_id: String) async throws {
        // 构建获取粉丝用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/get_user_fans_list/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "user_id", value: user_id)
        ]
        
        if let bodyString = bodyComponents.query {
            request.httpBody = bodyString.data(using: .utf8)
        }
        
        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(FanUserInfoResponse.self, from: data)
            
            // 在主线程更新粉丝用户列表信息
            DispatchQueue.main.async {
                self.fanUserInfoList = result.fanUserInfoList
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}

//获取用户文章列表
// 定义与JSON响应匹配的Swift结构体
struct ArticleResponse: Codable {
    var result: String
    var userID: Int?
    var username: String?
    var articleCount: Int?
    var articleList: [ArticleInfo]?
    
    enum CodingKeys: String, CodingKey {
        case result
        case userID = "user_id"
        case username
        case articleCount = "article_count"
        case articleList = "article_list"
    }
}

struct ArticleInfo: Codable {
    var article_id: Int
    var article_title: String
    var image_url: String
    var article_author: String
    var create_time: String
    var update_time: String
}

// 获取用户文章列表视图模型
class ArticleViewModel: ObservableObject {
    // 发布用户文章列表的变量
    @Published var ArticleData: ArticleResponse?
    
    // 修改获取用户文章列表函数为异步函数，并允许抛出错误
    func getArticleList(user_id: String) async throws {
        // 构建获取用户文章列表接口的URL
        guard let url = URL(string: baseURL + "/api/show_articles/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "user_id", value: user_id)
        ]
        
        if let bodyString = bodyComponents.query {
            request.httpBody = bodyString.data(using: .utf8)
        }
        
        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(ArticleResponse.self, from: data)
            
            // 在主线程更新用户文章列表信息
            DispatchQueue.main.async {
                self.ArticleData = result
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}

//文章列表展示卡片
struct ArticleCard: View {
    
    @State var avatarUrl_input:String?
    @State var author_name:String
    @State var article_title:String
    @State var article_id:Int
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View{
        
        let cardData = AccountCardData()//卡片规格信息
        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
            .overlay(
                VStack{
                    
                    HStack(spacing:-36){
                        
                        VStack(spacing :-40){
                            if let avatarURLString = avatarUrl_input,
                               let avatarURL = URL(string: avatarURLString) {
                                URLImage(avatarURL) {
                                    // 显示加载中的占位图像
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } inProgress: { progress in
                                    // 显示下载进度
                                    Image(systemName: "cloud")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } failure: { error, retry in
                                    // 显示错误信息和重试按钮
                                    VStack {
                                        Text(error.localizedDescription)
                                        Button("重试", action: retry)
                                    }
                                } content: { image in
                                    // 下载完成的图片
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 130, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }.padding()
                            } else {
                                // 处理当 avatar_url 为 nil 或无法转换为 URL 的情况
                                // 可以显示默认的占位图像或采取其他处理方式
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 130, height: 130)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                            }
                            
                            
                            Text("By: \(author_name)")
                                .font(.title)
                                .fontWeight(.bold)
                                .lineLimit(1) // 没有行数限制，自动换行
                                .fixedSize(horizontal: false, vertical: true).padding()
                        }.padding()
                        
                        VStack(spacing: -16){
                            Text(article_title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .lineLimit(2) // 最多显示3行
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                            
                            NavigationLink(destination: ArticleDetailView(article_id: article_id).navigationTitle("文章详情")){
                                RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                                    .foregroundColor(.indigo) // 根据配色方案设置背景颜色
                                    .overlay(
                                        HStack {
                                            Text("查看文章  ->").foregroundColor(Color.white)
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
                        }.padding()
                        
                    }
                    
                    
                }
            ).padding().frame(height: 200).frame(maxWidth: 540)
            .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                    .padding()
            )
        
        
        
    }
}


//文章获取接口
struct ArticleDetailResponse: Codable {
    let result: String
    let article_list: ArticleDetailInfo?
}

//文章信息
struct ArticleDetailInfo: Codable {
    let article_id: Int
    let author_id: Int
    let author: String
    let title: String
    let article_img_url: String
    let content: String
    let created_time: String
    let updated_time: String
}

//文章视图模型
class ArticleDetailViewModel: ObservableObject {
    // 发布文章信息的变量
    @Published var ArticleDetailData: ArticleDetailResponse?
    
    // 修改获取文章信息函数为异步函数，并允许抛出错误
    func getArticleDetail(article_id: String) async throws {
        // 构建获取文章信息接口的URL
        guard let url = URL(string: baseURL + "/api/show_article_by_id/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "article_id", value: article_id)
        ]
        
        if let bodyString = bodyComponents.query {
            request.httpBody = bodyString.data(using: .utf8)
        }
        
        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(ArticleDetailResponse.self, from: data)
            
            // 在主线程更新用户文章列表信息
            DispatchQueue.main.async {
                self.ArticleDetailData = result
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}

//查看文章详情页面
struct ArticleDetailView: View {
    // 传入的文章ID
    var article_id: Int
    
    let cardData = AccountCardData()//卡片规格信息
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    // 创建文章视图模型
    @StateObject private var articleDetailVM = ArticleDetailViewModel()
    
    var body: some View{
        NavigationStack{
            ScrollView{
                VStack(spacing: -16){
                    Text("")//移除顶部空白
                    if let articleDetailData = articleDetailVM.ArticleDetailData {
                        if articleDetailData.result == "success" {
                            if let article_list = articleDetailData.article_list {
                                
                                VStack(spacing: -60){
                                    VStack(spacing: -70){
                                        Text("")//移除顶部空白
                                        if let avatarURLString = articleDetailVM.ArticleDetailData?.article_list?.article_img_url,
                                           let avatarURL = URL(string: avatarURLString) {
                                            URLImage(avatarURL) {
                                                // 如果图像不可用，则占位符或其他视图
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 200, height: 200)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            } inProgress: { progress in
                                                // 显示下载进度
                                                Image(systemName: "cloud")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            } failure: { error, retry in
                                                // 显示错误信息和重试按钮
                                                VStack {
                                                    Text(error.localizedDescription)
                                                    Button("重试", action: retry)
                                                }
                                            } content: { image in
                                                // 下载完成的图片
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 200, height: 200)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }.padding()
                                        } else {
                                            // 处理当 avatar_url 为 nil 或无法转换为 URL 的情况
                                            // 可以显示默认的占位图像或采取其他处理方式
                                            Image(systemName: "person.fill.questionmark")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .padding()
                                        }
                                        
                                        HStack(spacing: -50){
                                            // 作者信息
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundColor(.indigo) // 根据配色方案设置背景颜色
                                                .padding()
                                                .overlay(
                                                    Text("作者: \(article_list.author)")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white) // 文本颜色
                                                ).padding().frame(height: 120)
                                            
                                            //进入作者主页
                                            NavigationLink(destination: UserMainPage(user_id: String(article_list.author_id)).navigationTitle("用户主页")){
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.indigo) // 根据配色方案设置背景颜色
                                                    .overlay(
                                                        HStack {
                                                            Text("查看主页 ->").foregroundColor(Color.white)
                                                        }
                                                    )
                                                    .padding()// 设置 HStack 的固定宽度
                                                    .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                                            .padding()
                                                        
                                                    )
                                            }.padding()
                                            
                                            
                                        }.padding()
                                    }.padding()
                                    
                                    
                                    //文章标题
                                    Text(article_list.title)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                
                                //文章内容
                                Text(article_list.content)
                                    .padding()
                                
                                
                                
                            }
                        }
                    }
                    
                    //                    Button("debug"){
                    //                        Task {
                    //                            do {
                    //                                try await articleDetailVM.getArticleDetail(article_id: String(article_id))
                    //                                if let articleDetailData = articleDetailVM.ArticleDetailData {
                    //                                    print(articleDetailData)
                    //                                }
                    //                            } catch {
                    //                                print(error)
                    //                            }
                    //                        }
                    //                    }
                    
                }.onAppear{
                        Task {
                            do {
                                try await articleDetailVM.getArticleDetail(article_id: String(article_id))
                                if let articleDetailData = articleDetailVM.ArticleDetailData {
                                    print(articleDetailData)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
            }
        }
    }
}

//获取返回信息用户模型
struct BasicUserInfoResponse: Codable {
    let result: String
    let BasicUserInfo: UserInfo?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case BasicUserInfo = "current_user_info"
    }
}

//获取用户信息视图模型
class BasicUserInfoViewModel: ObservableObject {
    // 发布用户信息的变量
    @Published var BasicUserInfo: UserInfo?
    
    // 修改获取用户信息函数为异步函数，并允许抛出错误
    func getBasicUserInfo(user_id: String) async throws {
        // 构建获取用户信息接口的URL
        guard let url = URL(string: baseURL + "/api/get_user_info_by_id/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "user_id", value: user_id)
        ]
        
        if let bodyString = bodyComponents.query {
            request.httpBody = bodyString.data(using: .utf8)
        }
        
        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(BasicUserInfoResponse.self, from: data)
            
            // 在主线程更新用户信息
            DispatchQueue.main.async {
                self.BasicUserInfo = result.BasicUserInfo
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}

//获取关注状态
func getFollowStatus(user_id: String, access_token: String) async throws -> Bool {
    
    struct FollowStatusResponse: Codable {
        let result: String?
        let isFollowed: Bool?
        let reason: String?
        
        private enum CodingKeys: String, CodingKey {
            case result
            case isFollowed = "isfollowed"
            case reason
        }
    }
    
    // 构建获取关注状态接口的URL
    guard let url = URL(string: baseURL + "/api/is_followed/") else {
        return false
    }
    
    // 创建POST请求
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 设置请求体参数
    var bodyComponents = URLComponents()
    bodyComponents.queryItems = [
        URLQueryItem(name: "user_id", value: user_id),
        URLQueryItem(name: "access_token", value: access_token)
    ]
    
    if let bodyString = bodyComponents.query {
        request.httpBody = bodyString.data(using: .utf8)
    }
    
    do {
        // 发起网络请求，并等待异步任务完成
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // 解码JSON响应
        let decoder = JSONDecoder()
        let result = try decoder.decode(FollowStatusResponse.self, from: data)
        
        // 返回关注状态
        //如果is_followed存在
        if let isFollowed = result.isFollowed {
            return isFollowed
        } else {
            return false
        }
        
    } catch {
        // 抛出错误，以便外部处理
        throw error
    }
}

//关注用户
func followUser(follow_user_id: String, access_token: String) async throws ->Bool {
    
    struct FollowUserResponse: Codable {
        let result: String
        let reason: String?
        let current_user: String?//发起关注操作的用户id
        let follow_user: Int?//被关注的用户id
        
    }
    
    // 构建关注用户接口的URL
    guard let url = URL(string: baseURL + "/api/follow_user/") else {
        return false
    }
    
    // 创建POST请求
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 设置请求体参数
    var bodyComponents = URLComponents()
    bodyComponents.queryItems = [
        URLQueryItem(name: "follow_user_id", value: follow_user_id),
        URLQueryItem(name: "access_token", value: access_token),
    ]
    
    //设置请求体
    if let bodyString = bodyComponents.query {
        request.httpBody = bodyString.data(using: .utf8)
    }
    
    do {
        // 发起网络请求，并等待异步任务完成
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // 解码JSON响应
        let decoder = JSONDecoder()
        let result = try decoder.decode(FollowUserResponse.self, from: data)
        
        
        // 如果 current_user存在,返回true
        if result.current_user != nil {
            return true
        } else {
            return false
        }
        
        
    } catch {
        // 抛出错误，以便外部处理
        throw error
    }
    
}


//取消关注接口
func unfollowUser(unfollow_user_id: String, access_token: String) async throws ->Bool {
    
    struct UnfollowUserResponse: Codable {
        let result: String
        let reason: String?
        let current_user: String?//发起取消关注操作的用户id
        let unfollow_user: Int?//被取消关注的用户id
    }
    
    // 构建取消关注用户接口的URL
    guard let url = URL(string: baseURL + "/api/unfollow_user/") else {
        return false
    }
    
    // 创建POST请求
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 设置请求体参数
    var bodyComponents = URLComponents()
    bodyComponents.queryItems = [
        URLQueryItem(name: "unfollow_user_id", value: unfollow_user_id),
        URLQueryItem(name: "access_token", value: access_token),
    ]
    
    //设置请求体
    if let bodyString = bodyComponents.query {
        request.httpBody = bodyString.data(using: .utf8)
    }
    
    do {
        // 发起网络请求，并等待异步任务完成
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // 解码JSON响应
        let decoder = JSONDecoder()
        let result = try decoder.decode(UnfollowUserResponse.self, from: data)
        
        // 如果 current_user存在,返回true
        if result.current_user != nil {
            return true
        } else {
            return false
        }
        
    } catch {
        // 抛出错误，以便外部处理
        throw error
    }
    
    
}
