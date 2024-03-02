//
//  DetailPage.swift
//  TasteMaster
//
//  Created by Sekiro on 20/2/2024.
//

import Foundation
import SwiftUI
import URLImage

//我的关注
struct MyFollowers: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    let url = URL(string: "https://qiniu.jingpin365.com/uploads/weibo/201912/9e16d1d636af8434d50e1241bb59163e.jpeg")
    
    @StateObject private var followedUserInfoViewModel = FollowedUserInfoViewModel()
    
    @State var user_id: String//要查询的用户ID
    
    var body: some View {
        ScrollView{
            VStack(spacing: -16){
                
                if let followedUserInfoList = followedUserInfoViewModel.followedUserInfoList {
                    ForEach(followedUserInfoList, id: \.currentUserId) { userInfo in
                        
                        UserBriefInfo(avatarUrl_input: userInfo.avatarUrl, currentUsername_input: userInfo.currentUsername, user_id: String(userInfo.currentUserId))
                        
                    }
                } else {
                    Text("获取关注列表失败")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding()
                }
                
            }.onAppear {
                // 在界面显示时自动获取关注用户列表信息
                Task {
                    do {
                        
                        try await followedUserInfoViewModel.getFollowedUserInfo(user_id: user_id)
                        
                    } catch {
                        print("获取关注用户列表发生错误: \(error)")
                    }
                }
                
            }
            
            
            
        }
    }
}

//我的粉丝
struct MyFans: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    let url = URL(string: "https://qiniu.jingpin365.com/uploads/weibo/201912/9e16d1d636af8434d50e1241bb59163e.jpeg")
    
    @StateObject private var fanUserInfoViewModel = FanUserInfoViewModel()
    
    @State var user_id: String//要查询的用户ID
    
    var body: some View {
        ScrollView{
            VStack(spacing: -16){
                
                if let fanUserInfoList = fanUserInfoViewModel.fanUserInfoList {
                    ForEach(fanUserInfoList, id: \.currentUserId) { userInfo in
                        
                        UserBriefInfo(avatarUrl_input: userInfo.avatarUrl, currentUsername_input: userInfo.currentUsername, user_id: String(userInfo.currentUserId))
                        
                    }
                } else {
                    Text("获取粉丝列表失败")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding()
                }
                
            }.onAppear {
                            // 在界面显示时自动获取关注用户列表信息
                            Task {
                                do {
            
                                    try await fanUserInfoViewModel.getFanUserInfo(user_id: user_id)
            
                                } catch {
                                    print("获取粉丝用户列表发生错误: \(error)")
                                }
                            }
            
                        }
              
        }
    }
}

//我的文章
struct MyArticles: View {
    
    @ObservedObject var articleViewModel = ArticleViewModel()
    @State var user_id: String//要查询的用户ID
    
    var body: some View {
        
        
        ScrollView{
            VStack(spacing: -16){
                if let articleList = articleViewModel.ArticleData?.articleList {
                    ForEach(articleList, id: \.article_id) { article in
                        ArticleCard(avatarUrl_input: article.image_url, author_name: article.article_author,article_title: article.article_title, article_id: article.article_id)
                    }
                } else {
                    Text("获取文章列表失败")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding()
                }
            }.onAppear{
                Task{
                    do{
                        try await articleViewModel.getArticleList(user_id: user_id)
                        if let articleList = articleViewModel.ArticleData?.articleList {
                            for article in articleList {
                                print(article.article_title)
                                print(article.article_author)
                                print(article.article_id)
                                print(article.create_time)
                                print(article.update_time)
                                print(article.image_url)
                                print(" ")
                                
                            }
                        }else{
                            print("articleList is nil")
                        }
                    }
                }
            }
        }
        
        
        
//        Button("debug"){
//            Task{
//                do{
//                    try await articleViewModel.getArticleList(user_id: "2")
//                    if let articleList = articleViewModel.ArticleData?.articleList {
//                        for article in articleList {
//                            print(article.article_title)
//                            print(article.article_author)
//                            print(article.article_content)
//                            print(article.article_id)
//                            print(article.create_time)
//                            print(article.update_time)
//                            print(article.image_url)
//                            print(" ")
//                            
//                        }
//                    }else{
//                        print("articleList is nil")
//                    }
//                }
//            }
//        }
        
        
    }
}

//文章管理
struct ArticleManagement: View {
    
    @ObservedObject var articleViewModel = ArticleViewModel()
    @State var user_id: String//要查询的用户ID
    
    var body: some View {
        
        
        ScrollView{
            VStack(spacing: -16){
                if let articleList = articleViewModel.ArticleData?.articleList {
                    ForEach(articleList, id: \.article_id) { article in
                        ArticleCardManagement(avatarUrl_input: article.image_url, author_name: article.article_author,article_title: article.article_title, article_id: article.article_id)
                    }
                } else {
                    Text("获取文章列表失败")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding()
                }
            }.onAppear{
                Task{
                    do{
                        try await articleViewModel.getArticleList(user_id: user_id)
                        if let articleList = articleViewModel.ArticleData?.articleList {
                            for article in articleList {
                                print(article.article_title)
                                print(article.article_author)
                                print(article.article_id)
                                print(article.create_time)
                                print(article.update_time)
                                print(article.image_url)
                                print(" ")
                                
                            }
                        }else{
                            print("articleList is nil")
                        }
                    }
                }
            }
        }
        
        
        
//        Button("debug"){
//            Task{
//                do{
//                    try await articleViewModel.getArticleList(user_id: "2")
//                    if let articleList = articleViewModel.ArticleData?.articleList {
//                        for article in articleList {
//                            print(article.article_title)
//                            print(article.article_author)
//                            print(article.article_content)
//                            print(article.article_id)
//                            print(article.create_time)
//                            print(article.update_time)
//                            print(article.image_url)
//                            print(" ")
//
//                        }
//                    }else{
//                        print("articleList is nil")
//                    }
//                }
//            }
//        }
        
        
    }
}

//他人用户主页
struct UserMainPage: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    let cardData = AccountCardData()//卡片规格信息
    
    @StateObject private var basicUserInfoViewModel = BasicUserInfoViewModel()
    @ObservedObject var accountDataManager = AccountDataManager.shared
    
    @State var user_id: String//要查询的用户ID
    @State var followButtonText = "立即关注"
    @State var followButtonColor = Color.green
    @State var isFollowed = false//是否已关注
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: cardData.cardSpacing){
                RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                    .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                    .overlay(
                        
                        HStack(){
                            if let avatarURLString = basicUserInfoViewModel.BasicUserInfo?.avatarUrl,
                               let avatarURL = URL(string: avatarURLString) {
                                URLImage(avatarURL) {
                                    // Placeholder or other view if the image is not available
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
                            
                            
                            VStack(spacing: -20){
                                Text(basicUserInfoViewModel.BasicUserInfo?.currentUsername ?? "获取失败")
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                    .lineLimit(1) // 没有行数限制，自动换行
                                    .fixedSize(horizontal: false, vertical: true).padding()
                                
                                //个人签名
                                Text(basicUserInfoViewModel.BasicUserInfo?.selfIntroduction ?? "获取失败")
                                
                                    .lineLimit(2) // 没有行数限制，自动换行
                                    .fixedSize(horizontal: false, vertical: true).padding()
                                
                            }
                            
                        }.padding()
                    ).padding().frame(height: 180) // 设置 HStack 的固定宽度
                    .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                            .padding()
                    )
                
                HStack(spacing: -16){
                    
                    // 我的关注
                    NavigationLink(destination: MyFollowers(user_id: user_id).navigationBarTitle("关注列表")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    
                                    Text("TA 的关注: \(basicUserInfoViewModel.BasicUserInfo?.followerNum ?? 0) ->").foregroundColor(Color.primary)
                                    
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
                    
                    
                    
                    //我的粉丝
                    NavigationLink(destination: MyFans(user_id: user_id).navigationBarTitle("粉丝列表")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    
                                    Text("TA 的粉丝: \(basicUserInfoViewModel.BasicUserInfo?.fanNum ?? 0) ->").foregroundColor(Color.primary)
                                    
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
                
                HStack(spacing: -16){
                    //我的文章
                    NavigationLink(destination: MyArticles(user_id: String(basicUserInfoViewModel.BasicUserInfo?.currentUserId ?? 0)).navigationBarTitle("TA 的文章")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    
                                    Text("TA 的文章: \(basicUserInfoViewModel.BasicUserInfo?.articleNum ?? 0) ->").foregroundColor(Color.primary)
                                    
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
                    
                    //关注判定按钮
                    Button(action: {
                        // 在支持并发性的上下文中调用异步函数
                        print("关注按钮被点击了")
                        
                        //判定关注状态，执行立即关注或取消关注
                        if isFollowed {
                            Task{
                                do{
                                    
                                    let result = try await unfollowUser(unfollow_user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                                    
                                    isFollowed.toggle()
                                    followButtonText = isFollowed ? "取消关注" : "立即关注"
                                    followButtonColor = isFollowed ? .red : .green
                                    
                                    print(result)
                                    
                                }catch{
                                    print("关注失败")
                                }
                            }
                        } else{
                            
                            Task{
                                do{
                                    
                                    let result = try await followUser(follow_user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                                    
                                    isFollowed.toggle()
                                    followButtonText = isFollowed ? "取消关注" : "立即关注"
                                    
                                    followButtonColor = isFollowed ? .red : .green
                                    
                                    print(result)
                                    
                                }catch{
                                    print("取消关注失败")
                                }
                            }
                            
                        }
                        
                        
                    }){
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(followButtonColor) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    Text(followButtonText).foregroundColor(Color.primary)
                                    
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
                
            }.onAppear{
                
                Task{
                    do{
                        try await basicUserInfoViewModel.getBasicUserInfo(user_id: user_id)
                        
                        if let accessToken = AccountDataManager.shared.currentAccountData?.access_token {
                            
                            do {
                                isFollowed = try await getFollowStatus(user_id: String(user_id), access_token: accessToken)
                                // 在这里处理关注状态
                                followButtonText = isFollowed ? "取消关注" : "立即关注"
                                followButtonColor = isFollowed ? .red : .green
                                print("关注状态: \(isFollowed)")
                            } catch {
                                // 处理错误
                                print("发生错误: \(error)")
                            }
                            
                            let result = try await AccountDataManager.shared.updateAccountData()
                            if result {
                                print("用户信息更新成功")
                            } else {
                                print("用户信息更新失败")
                            }
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    NavigationStack{
        //MyFollowers(user_id: "1").navigationTitle("我的关注")
        //MyFans().navigationTitle("我的粉丝")
        MyArticles(user_id: "2")
        //UserMainPage(user_id:"1")
    }
}
