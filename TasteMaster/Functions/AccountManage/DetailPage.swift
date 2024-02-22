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
                        
                        UserBriefInfo(avatarUrl_input: userInfo.avatarUrl, currentUsername_input: userInfo.currentUsername)
                        
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
                        
                        UserBriefInfo(avatarUrl_input: userInfo.avatarUrl, currentUsername_input: userInfo.currentUsername)
                        
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

#Preview {
    NavigationStack{
        //MyFollowers().navigationTitle("我的关注")
        MyFans().navigationTitle("我的粉丝")
    }
}
