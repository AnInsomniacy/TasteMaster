//
//  DetailDataConnector.swift
//  TasteMaster
//
//  Created by Sekiro on 21/2/2024.
//

import Foundation
import SwiftUI
import URLImage

//用户简要卡片信息
struct UserBriefInfo: View{
    
    @State var avatarUrl_input:String?
    @State var currentUsername_input:String
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    
    var body: some View{
        let cardData = AccountCardData()//卡片规格信息
        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
            .overlay(
                VStack{
                    
                    HStack{
                        VStack(spacing: -26){
                        if let avatarURLString = avatarUrl_input,
                           let avatarURL = URL(string: avatarURLString) {
                            URLImage(avatarURL) {
                                // 显示加载中的占位图像
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
                        
                        
                        Text(currentUsername_input)
                            .font(.title)
                            .fontWeight(.bold)
                        
                            .lineLimit(1) // 没有行数限制，自动换行
                            .fixedSize(horizontal: false, vertical: true).padding()
                    }
                        
                        VStack(spacing: -12){
                            
                            //查看主页
                            Button(action: {
                                print("查看主页")
                            }) {
                                Text("查看主页")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }.padding()
                            
                            //取消关注按钮
                            Button(action: {
                                print("取消关注")
                            }) {
                                Text("取消关注")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }.padding()
                            
                        }
                        
                    }.padding()
                    

                }
            ).padding().frame(height: 200).frame(maxWidth: 540)
            .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                    .padding()
            )
    }
    }

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

