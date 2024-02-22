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
                
            }
            .onAppear {
                // 在界面显示时自动获取关注用户列表信息
                Task {
                    do {
                        if let user_id = AccountDataManager.shared.currentAccountData?.user_id {
                            try await followedUserInfoViewModel.getFollowedUserInfo(user_id: String(user_id))
                        } else {
                            print("当前账户数据的用户ID为空")
                            // 在这里处理user_id为nil的情况，如果需要的话
                        }
                    } catch {
                        print("获取关注用户列表发生错误: \(error)")
                    }
                }
                
            }
            
            //            .onAppear {
            //                // 在界面显示时自动获取关注用户列表信息
            //                Task {
            //                    do {
            //
            //                        try await followedUserInfoViewModel.getFollowedUserInfo(user_id: String(2))
            //
            //                    } catch {
            //                        print("获取关注用户列表发生错误: \(error)")
            //                    }
            //                }
            //
            //            }
            
            
            
        }
    }
}

//我的粉丝
struct MyFans: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    let url = URL(string: "https://qiniu.jingpin365.com/uploads/weibo/201912/9e16d1d636af8434d50e1241bb59163e.jpeg")
    
    @StateObject private var fanUserInfoViewModel = FanUserInfoViewModel()
    
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
                
            }
            
            .onAppear {
                // 在界面显示时自动获取关注用户列表信息
                Task {
                    do {
                        if let user_id = AccountDataManager.shared.currentAccountData?.user_id {
                            try await fanUserInfoViewModel.getFanUserInfo(user_id: String(user_id))
                        } else {
                            print("当前账户数据的用户ID为空")
                            // 在这里处理user_id为nil的情况，如果需要的话
                        }
                    } catch {
                        print("获取关注用户列表发生错误: \(error)")
                    }
                }
                
            }
            
            
            
            //            .onAppear {
            //                // 在界面显示时自动获取关注用户列表信息
            //                Task {
            //                    do {
            //
            //                        try await fanUserInfoViewModel.getFanUserInfo(user_id: String(2))
            //
            //                    } catch {
            //                        print("获取粉丝用户列表发生错误: \(error)")
            //                    }
            //                }
            //
            //            }
            
            
            
        }
    }
}

//我的文章
struct MyArticles: View {
    var body: some View {
        Text("我的文章")
    }
}

//个人信息
struct MyInfo: View {
    var body: some View {
        Text("个人信息")
    }
}

//用户主页
struct UserMainPage: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    let cardData = AccountCardData()//卡片规格信息
    
    @StateObject private var basicUserInfoViewModel = BasicUserInfoViewModel()
    
    @State var user_id: String//要查询的用户ID
    
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
                    NavigationLink(destination: MyFollowers().navigationBarTitle("关注列表")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    if let followerCount = basicUserInfoViewModel.BasicUserInfo?.followerNum {
                                        Text("TA 的关注: \(followerCount) ->").foregroundColor(Color.primary)
                                    } else {
                                        Text("TA 的关注: ? ->").foregroundColor(Color.primary)
                                    }
                                    
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
                    NavigationLink(destination: MyFans().navigationBarTitle("粉丝列表")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    if let fansCount = basicUserInfoViewModel.BasicUserInfo?.fanNum {
                                        Text("TA 的粉丝: \(fansCount) ->").foregroundColor(Color.primary)
                                    } else {
                                        Text("TA 的粉丝: ? ->").foregroundColor(Color.primary)
                                    }
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
                    NavigationLink(destination: MyArticles().navigationBarTitle("TA 的文章")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    if let articleCount = basicUserInfoViewModel.BasicUserInfo?.articleNum {
                                        Text("TA 的文章: \(articleCount) ->").foregroundColor(Color.primary)
                                    } else {
                                        Text("TA 的文章: ? ->").foregroundColor(Color.primary)
                                    }
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
                    
                    //个人信息
                    NavigationLink(destination: MyInfo().navigationBarTitle("个人信息")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    Text("个人信息  ->").foregroundColor(Color.primary)
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
                        
                        if let result = basicUserInfoViewModel.BasicUserInfo{
                            //循环输出数组
                            print(result)
                            
                        }
                        
                    }catch{
                        print(error)
                        
                    }
                }
            }
            
        }
    }
}

#Preview {
    NavigationStack{
        MyFollowers().navigationTitle("我的关注")
        //MyFans().navigationTitle("我的粉丝")
        //UserMainPage(user_id:"1")
    }
}
