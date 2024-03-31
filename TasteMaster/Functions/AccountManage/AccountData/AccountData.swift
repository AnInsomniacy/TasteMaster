//
//  AccountData.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation
import SwiftUI

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

// 帐户数据结构体，遵循 Identifiable 和 Codable 协议
struct AccountData: Identifiable, Codable {
    var id = UUID()
    var user_id: Int = 0                    // 用户ID
    var username: String = "请先登录"         // 用户名
    var password: String = ""               // 密码
    var follower_num: Int = 0               // 粉丝数量
    var followed_user_list: String = ""     // 关注的用户列表（以逗号分隔的字符串）
    var fans_num: Int = 0                   // 粉丝数量
    var fans_user_list: String = ""         // 粉丝列表（以逗号分隔的字符串）
    var article_num: Int = 0                // 文章数量
    var article_list: String = ""           // 文章列表（以逗号分隔的字符串）
    var avatar_url: String = ""             // 头像 URL
    var self_introduction: String = ""      // 个人介绍
    var access_token: String = ""           // 访问令牌
    var is_login: Bool = false              // 登录状态，默认为未登录
}


class AccountDataManager: ObservableObject { // 继承 ObservableObject 协议
    static let shared = AccountDataManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "accountData"
    
    @Published var currentAccountData: AccountData? // 使用 @Published 属性包装器
    
    init(){
        loadAccountData()
    }
    
    // 保存帐户数据到 UserDefaults
    func saveAccountData(_ accountData: AccountData) {
        do {
            let encodedData = try JSONEncoder().encode(accountData)
            userDefaults.set(encodedData, forKey: key)
            currentAccountData = accountData
            NotificationCenter.default.post(name: Notification.Name("AccountDataUpdated"), object: nil)
        } catch {
            print("编码帐户数据时出错: \(error)")
        }
    }
    
    // 从 UserDefaults 中加载帐户数据
    func loadAccountData() {
        if let encodedData = userDefaults.data(forKey: key) {
            do {
                let accountData = try JSONDecoder().decode(AccountData.self, from: encodedData)
                currentAccountData = accountData
            } catch {
                print("解码帐户数据时出错: \(error)")
            }
        }
    }
    
    // 更新单个数据字段
    func updateAccountDataField<T>(_ keyPath: WritableKeyPath<AccountData, T>, value: T) {
        // 如果当前无用户，建立一个新的用户
        if currentAccountData == nil {
            currentAccountData = AccountData()
        }
        
        if var accountData = currentAccountData {
            accountData[keyPath: keyPath] = value
            saveAccountData(accountData)
            
        }
    }
    
    // 从 UserDefaults 中删除帐户数据
    func deleteAccountData() {
        userDefaults.removeObject(forKey: key)
        currentAccountData = nil
        NotificationCenter.default.post(name: Notification.Name("AccountDataDeleted"), object: nil)
    }
    
    //更新用户数据
    func updateAccountData() async throws -> Bool{
        
        let currentUserInfoViewModel = CurrentUserInfoViewModel()
        
        print(AccountDataManager.shared.currentAccountData?.access_token ?? "无令牌")

        do {
            try await currentUserInfoViewModel.getCurrentUserInfo(access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
            
            print("获取成功")
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
                
                DispatchQueue.main.async {
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
                    
                }
                
                return true
            } else {
                print("获取用户信息失败")
                return false
            }
        } catch {
            print("获取用户信息时发生错误: \(error)")
        }
        return false
    }
    
}

// 登录响应模型
struct LoginResponse: Codable {
    let result: Bool
    let access_token: String?
    let refresh_token: String?

    // 根据响应的result字段判断是否成功
    var isSuccess: Bool {
        return result
    }
}

// 登录视图模型
class LoginViewModel: ObservableObject {
    // 发布访问令牌和刷新令牌的变量
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var loginResult: Bool = false

    // 修改登录函数为异步函数，并允许抛出错误
    func login(username: String, password: String) async throws {
        // 构建登录接口的URL
        guard let url = URL(string: baseURL + "/api/login/") else {
            return
        }

        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]

        if let bodyString = bodyComponents.query {
            request.httpBody = bodyString.data(using: .utf8)
        }

        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)


            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(LoginResponse.self, from: data)
            
            // 判断登录是否成功
            if result.isSuccess {
                // 在主线程更新访问令牌和刷新令牌
                DispatchQueue.main.async {
                    self.accessToken = result.access_token
                    self.refreshToken = result.refresh_token
                    self.loginResult = true
                }
            } else {
                // 登录失败，可以在这里进行相应的处理
                
                // 在主线程清空访问令牌和刷新令牌
                DispatchQueue.main.async {
                    self.accessToken = nil
                    self.refreshToken = nil
                    self.loginResult = false
                }
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}

// 注册响应模型
struct RegisterResponse: Codable {
    let result: String // Change the type to String

    // 根据响应的result字段判断是否成功
    var isSuccess: Bool {
        return result.lowercased() == "注册成功"
    }
}

// 注册视图模型
class RegisterViewModel: ObservableObject {
    // 发布注册结果的变量
    @Published var registerResult: Bool = false
    @Published var registerMessage: String = ""

    // 修改注册函数为异步函数，并允许抛出错误
    func register(username: String, password: String, confirmPassword: String) async throws {
        // 构建注册接口的URL
        guard let url = URL(string: baseURL + "/api/register/") else {
            return
        }

        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password),
            URLQueryItem(name: "password_confirm", value: confirmPassword)
        ]

        if let bodyString = bodyComponents.query {
            request.httpBody = bodyString.data(using: .utf8)
        }

        // 修改 register 函数中的处理
        do {
            // 构建注册接口的URL
            guard let url = URL(string: baseURL + "/api/register/") else {
                return
            }

            // 创建POST请求
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            // 设置请求体参数
            var bodyComponents = URLComponents()
            bodyComponents.queryItems = [
                URLQueryItem(name: "username", value: username),
                URLQueryItem(name: "password", value: password),
                URLQueryItem(name: "password_confirm", value: confirmPassword)
            ]

            if let bodyString = bodyComponents.query {
                request.httpBody = bodyString.data(using: .utf8)
            }

            // 设置超时时间（以秒为单位）
            request.timeoutInterval = 5 // 设置为适当的值

            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)

            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(RegisterResponse.self, from: data)

            // 判断注册是否成功
            if result.isSuccess {
                // 在主线程更新注册结果
                DispatchQueue.main.async {
                    self.registerResult = true
                }
            } else {
                // 注册失败，可以在这里进行相应的处理
                        
                // 在主线程清空注册结果
                DispatchQueue.main.async {
                    self.registerResult = false
                    self.registerMessage = result.result
                }
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }

        
    }
}

// 获取当前用户信息响应模型
struct CurrentUserInfoResponse: Codable {
    let result: String
    let user_id: Int
    let username: String
    let avatarUrl: String
    let selfIntroduction: String
    let followerNum: Int
    let fanNum: Int
    let articleNum: Int
}

// 获取当前用户信息视图模型
class CurrentUserInfoViewModel: ObservableObject {
    // 发布当前用户信息的变量
    @Published var userInfo: CurrentUserInfoResponse?

    // 修改获取用户信息函数为异步函数，并允许抛出错误
    func getCurrentUserInfo(access_token: String) async throws {
        // 构建获取用户信息接口的URL
        guard let url = URL(string: baseURL + "/api/get_current_user_info/") else {
            return
        }

        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
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
            let result = try decoder.decode(CurrentUserInfoResponse.self, from: data)
            
            self.userInfo = result

            // 在主线程更新当前用户信息
            DispatchQueue.main.async {
                print("已执行获取用户信息")
                self.userInfo = result
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}
