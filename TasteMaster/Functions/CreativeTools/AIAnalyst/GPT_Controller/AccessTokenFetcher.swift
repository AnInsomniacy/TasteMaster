//
//  GPT_Controller.swift
//  TasteMaster
//
//  Created by Sekiro on 29/10/2023.
//

import Foundation

// 错误类型，用于处理无法从响应中获取token的情况
enum AccessTokenRequestError: Error {
    case invalidResponse
    case noData
}

// 函数：异步请求Access Token
func requestAccessToken(API_Key clientId: String, Secret_Key clientSecret: String) async throws -> String {
    // URL构建
    guard var urlComponents = URLComponents(string: "https://aip.baidubce.com/oauth/2.0/token") else {
        throw AccessTokenRequestError.invalidResponse
    }

    // 查询参数
    urlComponents.queryItems = [
        URLQueryItem(name: "grant_type", value: "client_credentials"),
        URLQueryItem(name: "client_id", value: clientId),
        URLQueryItem(name: "client_secret", value: clientSecret)
    ]

    guard let url = urlComponents.url else {
        throw AccessTokenRequestError.invalidResponse
    }

    // 请求构建
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    // 发起请求
    let (data, _) = try await URLSession.shared.data(for: request)

    // 此处不需要检查data是否为nil，因为它总是返回一个非Optional的Data对象。
    // 如果没有数据或发生网络错误，它会抛出错误。

    do {
        // 解析JSON
        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let accessToken = jsonResponse["access_token"] as? String {
            // 返回Access Token
            return accessToken
        } else {
            // JSON格式不符合预期
            throw AccessTokenRequestError.invalidResponse
        }
    } catch {
        // JSON解析失败
        throw error
    }

}
