//
//  AccountData.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation

var baseURL = "http://192.168.3.203:8000"

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

            // 在主线程更新当前用户信息
            DispatchQueue.main.async {
                self.userInfo = result
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}
