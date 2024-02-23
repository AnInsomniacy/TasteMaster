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
    @State var followerCount: Int = 0 // 关注数
    @State var fansCount: Int? // 粉丝数
    
    //登录和注销按钮颜色
    @State var loginButtonColor: Color = .green
    
    @State var user_id: Int = 0//用户id
    
    @ObservedObject var accountDataManager = AccountDataManager.shared

    
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
                                    // 如果图像不可用，则占位符或其他视图
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
                    NavigationLink(destination: MyFollowers(user_id: String(user_id)).navigationBarTitle("关注列表")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    
                                    Text("我的关注: \(accountDataManager.currentAccountData?.follower_num ?? 0) ->").foregroundColor(Color.primary)
                                    
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
                                    
                                    Text("我的粉丝: \(accountDataManager.currentAccountData?.fans_num ?? 0) ->").foregroundColor(Color.primary)
                                    
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
                    NavigationLink(destination: MyArticles().navigationBarTitle("我的文章")) {
                        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                            .overlay(
                                HStack {
                                    
                                    Text("我的文章: \(accountDataManager.currentAccountData?.article_num ?? 0) ->").foregroundColor(Color.primary)
                                    
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
                        .foregroundColor(loginButtonColor) // 根据配色方案设置背景颜色
                        .overlay(
                            HStack {
                                if(isLogin == false){
                                    Text("立即登录").foregroundColor(Color.primary)
                                }
                                else{
                                    Text("退出登录").foregroundColor(Color.primary)
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
                .onChange(of: isLogin) { newValue in
                    // Change button color based on login state
                    self.loginButtonColor = newValue ? .pink : .green
                }
                
                Button("debug"){
                    //在视图出现时，将AccountDataManager.shared.currentAccountData?.is_login的值赋给isLogin
                    Task{
                        do{
                            let result = try await AccountDataManager.shared.updateAccountData()
                            print(result)
                        }
                    }
                    self.isLogin = AccountDataManager.shared.currentAccountData?.is_login ?? false
                    user_id = AccountDataManager.shared.currentAccountData?.user_id ?? 0
                    followerCount = AccountDataManager.shared.currentAccountData?.follower_num ?? 0
                }
                
            }
        } .onAppear {
            //在视图出现时，将AccountDataManager.shared.currentAccountData?.is_login的值赋给isLogin
            Task{
                do{
                    let result = try await AccountDataManager.shared.updateAccountData()
                    if result {
                        print("用户信息更新成功")
                    } else {
                        print("用户信息更新失败")
                    }
                }
            }
            self.isLogin = AccountDataManager.shared.currentAccountData?.is_login ?? false
            user_id = AccountDataManager.shared.currentAccountData?.user_id ?? 0
            followerCount = AccountDataManager.shared.currentAccountData?.follower_num ?? 0
        }
    }
}

//登录页面
struct LoginPage: View{
    
    var loginViewModel = LoginViewModel()
    var currentUserInfoViewModel = CurrentUserInfoViewModel()
    
    // 用于存储输入的用户名和密码
    @State private var username = ""
    @State private var password = ""
    
    @StateObject private var accountManager = AccountDataManager.shared
    
    @Binding var startLogin: Bool
    @Binding var isLogin: Bool
    
    @State private var buttonText = "立即登录"
    @State private var buttonColor = Color.green
    
    var body: some View{
        NavigationStack{
            ScrollView(){
                VStack(spacing: -20){
                    Text("请先登录😁")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    VStack(spacing: -10){
                        //用户名输入框
                        HStack{
                            Image(systemName: "person")
                                .padding()
                                .scaleEffect(1.8)
                            
                            TextField("请输入用户名", text: $username)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            
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
                            
                        }.padding()
                    }.padding()
                    
                    //注册和登录
                    HStack(spacing: 24){
                        
                        NavigationLink(destination:RegisterAccount()){
                            
                            Text("注册账户")
                                .foregroundColor(.white) // 文本颜色
                                .font(.headline) // 字体大小和样式
                            
                        }   .frame(width: 114)
                            .padding() // 内边距
                            .background(Color.blue) // 背景颜色
                            .cornerRadius(10) // 圆角
                        
                        
                        // 立即登录按钮
                        Button(action: {
                            Task {
                                do {
                                    // 更新按钮状态为“正在登录”
                                    buttonText = "正在登录"
                                    buttonColor = Color.gray
                                    
                                    // 调用异步登录函数
                                    try await loginViewModel.login(username: username, password: password)
                                    
                                    // 根据登录结果执行相应操作
                                    if loginViewModel.loginResult {
                                        print("登录成功，访问令牌：\(loginViewModel.accessToken ?? "")")
                                        // 在这里可以进行导航、显示成功提示等操作
                                        buttonText = "登录成功"
                                        buttonColor = Color.green
                                        
                                        //使用access token获取详细信息
                                        // 调用获取用户信息函数
                                        do {
                                            try await currentUserInfoViewModel.getCurrentUserInfo(access_token: loginViewModel.accessToken ?? "")
                                            
                                            // 检查是否成功获取用户信息
                                            if let userInfo = currentUserInfoViewModel.userInfo {
                                                // 输出用户信息
                                                print("用户ID: \(userInfo.user_id)")
                                                print("用户名: \(userInfo.username)")
                                                print("头像URL: \(userInfo.avatarUrl)")
                                                print("个人简介: \(userInfo.selfIntroduction)")
                                                print("粉丝数: \(userInfo.fanNum)")
                                                print("关注数: \(userInfo.followerNum)")
                                                print("文章数: \(userInfo.articleNum)")
                                                
                                                // 保存状态，持久化存储
                                                // 用户ID
                                                AccountDataManager.shared.updateAccountDataField(\.user_id, value: userInfo.user_id)
                                                // 头像URL
                                                AccountDataManager.shared.updateAccountDataField(\.avatar_url, value: userInfo.avatarUrl)
                                                // 个人简介
                                                AccountDataManager.shared.updateAccountDataField(\.self_introduction, value: userInfo.selfIntroduction)
                                                // 粉丝数
                                                AccountDataManager.shared.updateAccountDataField(\.fans_num, value: userInfo.fanNum)
                                                // 关注数
                                                AccountDataManager.shared.updateAccountDataField(\.follower_num, value: userInfo.followerNum)
                                                // 文章数
                                                AccountDataManager.shared.updateAccountDataField(\.article_num, value: userInfo.articleNum)
                                                // 登录状态
                                                AccountDataManager.shared.updateAccountDataField(\.is_login, value: true)
                                                // 访问令牌
                                                AccountDataManager.shared.updateAccountDataField(\.access_token, value: loginViewModel.accessToken ?? "N/A")
                                                
                                                
                                            } else {
                                                print("获取用户信息失败")
                                            }
                                        } catch {
                                            print("获取用户信息时发生错误: \(error)")
                                        }
                                        
                                        //保存状态，持久化存储
                                        //用户名
                                        AccountDataManager.shared.updateAccountDataField(\.username, value: username)
                                        //密码
                                        AccountDataManager.shared.updateAccountDataField(\.password, value: password)
                                        //登录状态
                                        AccountDataManager.shared.updateAccountDataField(\.is_login, value: true)
                                        //访问令牌
                                        AccountDataManager.shared.updateAccountDataField(\.access_token, value: loginViewModel.accessToken ?? "N/A")
                                        
                                        
                                        try await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1秒 = 1,000,000,000纳秒
                                        isLogin = true
                                        startLogin = false
                                        
                                    } else {
                                        print("登录失败")
                                        // 在这里可以显示失败提示等操作
                                        buttonText = "登录失败"
                                        buttonColor = Color.red
                                        // 1秒后还原按钮状态
                                        try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 1秒 = 1,000,000,000纳秒
                                        buttonText = "立即登录"
                                        buttonColor = Color.green
                                    }
                                } catch {
                                    // 处理登录错误
                                    print("登录出错: \(error)")
                                    // 在这里可以显示错误提示等操作
                                    buttonText = "登录出错"
                                    buttonColor = Color.red
                                    // 1秒后还原按钮状态
                                    try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 1秒 = 1,000,000,000纳秒
                                    buttonText = "立即登录"
                                    buttonColor = Color.green
                                }
                            }
                        }) {
                            Text(buttonText)
                                .foregroundColor(.white) // 文本颜色
                                .font(.headline) // 字体大小和样式
                        }
                        .frame(width: 114)
                        .padding() // 内边距
                        .background(buttonColor) // 背景颜色
                        .cornerRadius(10) // 圆角
                    }
                    .padding() // 其他视图的外边距
                    
                }.navigationTitle("账户管理")
            }
        }
    }
}

// 注册账户View
struct RegisterAccount: View {
    
    // 用于存储输入的用户名、密码和确认密码
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var buttonText = "立即注册"
    @State private var buttonColor = Color.blue
    
    var registerViewModel = RegisterViewModel() // 你可能需要根据需要修改这里
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("创建新账户 😊")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    // 用户名输入框
                    HStack {
                        Image(systemName: "person")
                            .padding()
                            .scaleEffect(1.8)
                        
                        TextField("请输入用户名", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    // 密码输入框
                    HStack {
                        Image(systemName: "lock")
                            .padding()
                            .scaleEffect(1.8)
                        
                        SecureField("请输入密码", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    // 确认密码输入框
                    HStack {
                        Image(systemName: "lock")
                            .padding()
                            .scaleEffect(1.8)
                        
                        SecureField("确认密码", text: $confirmPassword)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    // 注册按钮
                    Button(action: {
                        Task {
                            do {
                                // 更新按钮状态为“正在注册”
                                buttonText = "正在注册"
                                buttonColor = Color.gray
                                
                                // 调用异步注册函数
                                try await registerViewModel.register(username: username, password: password, confirmPassword: confirmPassword)
                                
                                // 根据注册结果执行相应操作
                                if registerViewModel.registerResult {
                                    print("注册成功")
                                    // 在这里可以进行导航、显示成功提示等操作
                                    buttonText = "注册成功"
                                    buttonColor = Color.blue
                                    
                                    // 这里可以根据注册后的需求执行其他操作
                                    try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 1秒 = 1,000,000,000纳秒
                                    buttonText = "立即注册"
                                    buttonColor = Color.green
                                } else {
                                    print("注册失败")
                                    // 在这里可以显示失败提示等操作
                                    buttonText = registerViewModel.registerMessage
                                    buttonColor = Color.red
                                    try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 1秒 = 1,000,000,000纳秒
                                    buttonText = "立即注册"
                                    buttonColor = Color.green
                                }
                            } catch {
                                // 处理注册错误
                                print("注册出错: \(error)")
                                // 在这里可以显示错误提示等操作
                                buttonText = "注册出错"
                                buttonColor = Color.red
                                try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 1秒 = 1,000,000,000纳秒
                                buttonText = "立即注册"
                                buttonColor = Color.green
                            }
                        }
                    }) {
                        Text(buttonText)
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                    .background(buttonColor)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("注册账户")
        }
    }
}



#Preview {
    NavigationStack{
        AccountManage().navigationTitle("私厨空间")
    }
}
