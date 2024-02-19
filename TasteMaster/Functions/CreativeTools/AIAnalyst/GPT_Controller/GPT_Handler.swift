//
//  GPT_Handler.swift
//  TasteMaster
//
//  Created by Sekiro on 29/10/2023.
//

import Foundation

// 您之前定义的API密钥和错误类型
var API_Key_Chat = "6pmb5XAlP0QMNnXTNe9wKc7Z"
var Secret_Key_Chat = "kiytuEwGG6FlQAZrYBhk4YFHK9hZ1HVC"

enum NetworkError_Chat: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case noData
}

class SSEHandler: NSObject, URLSessionDataDelegate {
    var streamContinuation: AsyncStream<String>.Continuation?

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataString = String(data: data, encoding: .utf8) {
            // 处理可能存在的多个SSE消息
            let messages = dataString.components(separatedBy: "\n\n")
            for message in messages {
                if message.hasPrefix("data: ") {
                    let startIndex = message.index(message.startIndex, offsetBy: 6)
                    let eventData = String(message[startIndex...])

                    // 解析JSON并获取结果字段
                    if let data = eventData.data(using: .utf8),
                       let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = jsonObject as? [String: Any],
                       let result = dictionary["result"] as? String {  // 提取“result”字段
                        //打印整个json
                        print(dictionary)

                        // 为stream提供新数据
                        streamContinuation?.yield(result)
                    }
                }
            }
        }
    }

}

func sendRequestToAIEndpoint(content: String, onUpdate: @escaping (String) -> Void) async throws {
    let accessToken = try await requestAccessToken(API_Key: API_Key_Chat, Secret_Key: Secret_Key_Chat)

    let urlString = "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/eb-instant?access_token=\(accessToken)"
    guard let url = URL(string: urlString) else {
        throw NetworkError_Chat.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let payload: [String: Any] = [
        "messages": [["role": "user", "content": content]],
        "stream": true,
    ]
    request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])

    let sseHandler = SSEHandler()

    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration, delegate: sseHandler, delegateQueue: nil)

    // 创建 AsyncStream 以处理接收到的事件流
    let stream = AsyncStream<String> { continuation in
        sseHandler.streamContinuation = continuation

        // 使用URLSession和自定义代理开始数据任务
        let dataTask = session.dataTask(with: request)
        dataTask.resume()

        continuation.onTermination = { @Sendable termination in
            // 根据需要处理终止，例如，您可能需要取消数据任务
            dataTask.cancel()
        }
    }

    for try await result in stream {
        // 现在，“result”是一个字符串，代表从服务器接收的“result”字段。
        // 回调函数用于更新UI，我们需要确保它在主线程上运行
        DispatchQueue.main.async {
            onUpdate(result)  // 直接传递结果字符串
            //print(result)
        }
    }

}
