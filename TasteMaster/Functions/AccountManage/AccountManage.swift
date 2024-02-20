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
    
    @State var startLogin: Bool = false // 开始登录
    @State var isLogin: Bool = false // 是否登录
    
    let cardData = AccountCardData()//卡片规格信息
    
    var body: some View {
        ScrollView(){
            VStack(spacing: cardData.cardSpacing){
                RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                    .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                    .overlay(
                        
                        HStack(){
                            if let avatarURLString = AccountDataManager.shared.currentAccountData?.avatar_url,
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
                                Text(AccountDataManager.shared.currentAccountData?.username ?? "未登录")
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                    .lineLimit(1) // 没有行数限制，自动换行
                                    .fixedSize(horizontal: false, vertical: true).padding()
                                
                                //个人签名
                                Text(AccountDataManager.shared.currentAccountData?.self_introduction ?? "请先登录或注册")
                                
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
                    NavigationLink(destination: MyFollowers()) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    if let followerCount = AccountDataManager.shared.currentAccountData?.follower_num {
                                        Text("我的关注: \(followerCount) ->").foregroundColor(Color.primary)
                                    } else {
                                        Text("我的关注: ? ->").foregroundColor(Color.primary)
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
                    NavigationLink(destination: MyFans()) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    if let fansCount = AccountDataManager.shared.currentAccountData?.fans_num {
                                        Text("我的粉丝: \(fansCount) ->").foregroundColor(Color.primary)
                                    } else {
                                        Text("我的粉丝: ? ->").foregroundColor(Color.primary)
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
                    NavigationLink(destination: MyArticles()) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    if let articleCount = AccountDataManager.shared.currentAccountData?.article_num {
                                        Text("我的文章: \(articleCount) ->").foregroundColor(Color.primary)
                                    } else {
                                        Text("我的文章: ? ->").foregroundColor(Color.primary)
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
                    NavigationLink(destination: MyInfo()) {
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
                
                
                //立即登录或退出登录
                Button(action: {
                    if(isLogin == false){
                        startLogin = true
                    }
                    else{
                        AccountDataManager.shared.deleteAccountData()
                        isLogin = false
                    }
                }) {
                    RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                        .foregroundColor(colorScheme == .dark ? .pink : .pink) // 根据配色方案设置背景颜色
                        .overlay(
                            HStack {
                                if(isLogin == false){
                                    Text("立即登录  ->").foregroundColor(Color.primary)
                                }
                                else{
                                    Text("退出登录  ->").foregroundColor(Color.primary)
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
                        .sheet(isPresented: $startLogin) {
                            LoginPage(startLogin: $startLogin,isLogin: $isLogin)
                        }
                }
                
            }
        }
    }
}

//登录页面
struct LoginPage: View{
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @StateObject private var accountManager = AccountDataManager.shared

    @Binding var startLogin: Bool
    @Binding var isLogin: Bool
    
    var body: some View{
        ScrollView{
            Text("请先登录😁")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            //用户名输入框
            HStack{
                Image(systemName: "person")
                    .padding()
                    .scaleEffect(1.8)
                
                TextField("请输入用户名", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 260)
            }.padding()
            
            //密码输入框
            HStack{
                Image(systemName: "lock")
                    .padding()
                    .scaleEffect(1.8)
                
                SecureField("请输入密码", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 260)
            }.padding()
            
            //注册和登录
            HStack(spacing: 24){
                
                // 注册账户按钮
                Button(action: {
                    // 在这里添加跳转到注册页面的逻辑
                }) {
                    Text("注册账户")
                        .foregroundColor(.white) // 文本颜色
                        .font(.headline) // 字体大小和样式
                    
                }
                .frame(width: 114)
                .padding() // 内边距
                .background(Color.blue) // 背景颜色
                .cornerRadius(10) // 圆角
                
                // 立即登录按钮
                Button(action: {
                    
                    // 模拟登录成功后更新账户数据
                    let loggedInAccountData = AccountData(user_id: 1, username: username, follower_num: 0, followed_user_list: "", fans_num: 0, fans_user_list: "", article_num: 0, article_list: "", avatar_url: "https://qiniu.jingpin365.com/uploads/weibo/201912/9e16d1d636af8434d50e1241bb59163e.jpeg", self_introduction: "前途似海，来日方长", access_token: "your_access_token", is_login: true)
                    
                    // 更新全局的账户数据
                    AccountDataManager.shared.saveAccountData(loggedInAccountData)

                    
                    startLogin = false
                    isLogin = true
                    
                }) {
                    Text("立即登录")
                        .foregroundColor(.white) // 文本颜色
                        .font(.headline) // 字体大小和样式
                }                .frame(width: 114)
                    .padding() // 内边距
                    .background(Color.green) // 背景颜色
                    .cornerRadius(10) // 圆角
            }
            
            
        }
    }
}



//卡片颜色和深度信息
struct AccountCardData {
    //圆角半径
    var cornerRadius: CGFloat = 15
    //卡片间距
    var cardSpacing: CGFloat = -16
    //卡片高度
    var cardHeight: CGFloat = 100
    //卡片颜色（深色）
    var cardColorDark: Color = Color.blue
    //卡片颜色（浅色）
    var cardColorLight: Color = Color.orange
    //卡片边框颜色（深色）
    var cardBorderColorDark: Color = Color.yellow
    //卡片边框颜色（浅色）
    var cardBorderColorLight: Color = Color.white
    //卡片阴影颜色（深色）
    var cardShadowColorDark: Color = Color.cyan.opacity(0.4)
    //卡片阴影颜色（浅色）
    var cardShadowColorLight: Color = Color.black.opacity(0.4)
    
}

#Preview {
    NavigationStack{
        //LoginPage()
        //AccountManagePage()
        AccountManage()
    }
}
