//
//  AccountManage.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation
import SwiftUI
import URLImage

struct AccountManage: View{
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    let avatar_url: URL = URL(string: "https://qiniu.jingpin365.com/uploads/weibo/201912/9e16d1d636af8434d50e1241bb59163e.jpeg")!
    let self_introduction: String = "前途似海，来日方长。"
    
    
    var body: some View{
        AccountManagePage()
    }
}

struct AccountManagePage: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）

    let username: String = "Sekiro"
    let self_introduction: String = "前途似海，来日方长。"
    let avatar_url: URL = URL(string: "https://qiniu.jingpin365.com/uploads/weibo/201912/9e16d1d636af8434d50e1241bb59163e.jpeg")!
    let follower_num: Int = 26
    let fans_num: Int = 19
    let article_num: Int = 5
    
    var body: some View {
        ScrollView(){
            VStack(spacing: -16){
                RoundedRectangle(cornerRadius: 15) // 设置圆角半径
                    .foregroundColor(colorScheme == .dark ? Color.blue.opacity(0.4) : Color.orange.opacity(0.8))
                    .overlay(
                        
                        HStack(){
                            
                            URLImage(avatar_url) {
                                // This view is displayed before download starts
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100).clipShape(RoundedRectangle(cornerRadius: 10))
                            } inProgress: { progress in
                                // Display progress
                                Image(systemName: "cloud")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } failure: { error, retry in
                                // Display error and retry button
                                VStack {
                                    Text(error.localizedDescription)
                                    Button("Retry", action: retry)
                                }
                            } content: { image in
                                // Downloaded image
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }.padding()
                            
                            VStack(spacing: -20){
                                Text(username)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                    .lineLimit(1) // 没有行数限制，自动换行
                                    .fixedSize(horizontal: false, vertical: true).padding()
                                
                                Text(self_introduction)
                                    .font(.subheadline)
                                
                                    .lineLimit(2) // 没有行数限制，自动换行
                                    .fixedSize(horizontal: false, vertical: true).padding()
                                
                            }
                            
                        }.padding()
                    ).padding().frame(height: 180) // 设置 HStack 的固定宽度
                
                HStack(spacing: -16){
                    
                    //我的关注
                    RoundedRectangle(cornerRadius: 15) // 设置圆角半径
                        .foregroundColor(colorScheme == .dark ? Color.blue.opacity(0.4) : Color.orange.opacity(0.8))
                        .overlay(
                            
                            NavigationLink(destination: MyFollowers()) {
                                
                                Text("我的关注: \(follower_num)  ->").foregroundColor(Color.primary)
                            }
                            
                        ).padding().frame(height: 100) // 设置 HStack 的固定宽度
                        .shadow(color: colorScheme == .dark ? Color.cyan.opacity(0.2) : Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    
                    
                    //我的粉丝
                    RoundedRectangle(cornerRadius: 15) // 设置圆角半径
                        .foregroundColor(colorScheme == .dark ? Color.blue.opacity(0.4) : Color.orange.opacity(0.8))
                        .overlay(
                            
                            NavigationLink(destination: MyFans()) {
                                
                                Text("我的粉丝: \(fans_num)  ->").foregroundColor(Color.primary)
                            }
                            
                        ).padding().frame(height: 100) // 设置 HStack 的固定宽度
                        .shadow(color: colorScheme == .dark ? Color.cyan.opacity(0.2) : Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    
                }
                
                HStack(spacing: -16){
                    //我的文章
                    RoundedRectangle(cornerRadius: 15) // 设置圆角半径
                        .foregroundColor(colorScheme == .dark ? Color.blue.opacity(0.4) : Color.orange.opacity(0.8))
                        .overlay(
                            
                            NavigationLink(destination: MyArticles()) {
                                
                                Text("我的文章: \(article_num)  ->").foregroundColor(Color.primary)
                            }
                            
                        ).padding().frame(height: 100) // 设置 HStack 的固定宽度
                        .shadow(color: colorScheme == .dark ? Color.cyan.opacity(0.2) : Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    
                    //个人信息
                    RoundedRectangle(cornerRadius: 15) // 设置圆角半径
                        .foregroundColor(colorScheme == .dark ? Color.blue.opacity(0.4) : Color.orange.opacity(0.8))
                        .overlay(
                            
                            NavigationLink(destination: MyInfo()) {
                                
                                Text("个人信息  ->").foregroundColor(Color.primary)
                            }
                            
                        ).padding().frame(height: 100) // 设置 HStack 的固定宽度
                        .shadow(color: colorScheme == .dark ? Color.cyan.opacity(0.2) : Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                }
                
                //退出登录
                RoundedRectangle(cornerRadius: 15) // 设置圆角半径
                    .foregroundColor(colorScheme == .dark ? Color.red.opacity(0.4) : Color.red.opacity(0.8))
                    .overlay(
                        
                        Text("退出登录")
                    ).padding().frame(height: 100) // 设置 HStack 的固定宽度
                
            }
        }
    }
}

//我的关注
struct MyFollowers: View {
    var body: some View {
        Text("我的关注")
    }
}

//我的粉丝
struct MyFans: View {
    var body: some View {
        Text("我的粉丝")
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
        AccountManage().navigationTitle("私厨空间")
    }
}
