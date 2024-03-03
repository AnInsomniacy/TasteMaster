//
//  DetailDataConnector.swift
//  TasteMaster
//
//  Created by Sekiro on 21/2/2024.
//

import Foundation
import SwiftUI
import URLImage

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
