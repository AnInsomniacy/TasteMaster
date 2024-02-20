//
//  AccountData.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation

// 帐户数据结构体，遵循 Identifiable 和 Codable 协议
struct AccountData: Identifiable, Codable {
    var id = UUID()
    var user_id: Int = 0                    // 用户ID
    var username: String = "请先登录"         // 用户名
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

