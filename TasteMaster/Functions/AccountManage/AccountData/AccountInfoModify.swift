//
//  AccountInfoModify.swift
//  TasteMaster
//
//  Created by Sekiro on 2/3/2024.
//

import Foundation
import SwiftUI

struct AccountInfoModify: View {
    
    @ObservedObject var request = AccountInfoModifyRequest()
    
    @State private var newSignature: String = ""
    @State private var newAvatarURL: String = ""
    @State private var buttonText: String = "确认修改"
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("修改个性签名")
                    .font(.title)
                    .padding(.top, 20)
                
                Text("个性签名是您展示自己的最好方式")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    TextField("请输入新的个性签名", text: $newSignature)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading) {
                    Text("修改头像")
                        .font(.title)
                        .padding(.top, 20)
                    
                    Text("输入头像的 URL 地址")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "camera.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        TextField("请输入新的头像 URL 地址", text: $newAvatarURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .padding()
            
            // 水平排列的按钮
            HStack {
                
                // 取消修改按钮，通过 presentationMode 关闭当前视图
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("取消修改")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                // 确认修改按钮
                Button(action: {
                    
                    if newSignature == "" {
                        request.newSignature = AccountDataManager.shared.currentAccountData?.self_introduction ?? ""
                    }else{
                        request.newSignature = newSignature
                    }
                    
                    if newAvatarURL == "" {
                        request.newAvatarURL = AccountDataManager.shared.currentAccountData?.avatar_url ?? ""
                    }else{
                            print("newAvatarURL is not empty")
                            print(newAvatarURL)
                            print("")
                            request.newAvatarURL = newAvatarURL
                        }
                    
                    Task{
                        do{
                            try await request.request()
                            //如果reason不存在
                            if request.response?.reason == nil {
                                buttonText = "修改成功"
                                //延迟1秒后关闭页面
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }else{
                                buttonText = "修改失败,\(request.response?.reason ?? "未知错误"))"
                            }
                        }catch{
                            print(error)
                        }
                    }
                    
                    
                }) {
                    Text(buttonText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
        }
        .navigationBarTitle("账户信息修改")
    }
}

//API适配
//json返回结构体
struct AccountInfoModifyResponse: Codable {
    var result: String
    var reason: String?
}

//API请求
class AccountInfoModifyRequest: ObservableObject {
    @Published var newSignature: String = ""
    @Published var newAvatarURL: String = ""
    @Published var response: AccountInfoModifyResponse?
    
    func request() async throws{
        // 构建获取关注用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/modify_user_info/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "avatar_url", value: newAvatarURL),
            URLQueryItem(name: "self_introduction", value: newSignature),
            URLQueryItem(name: "access_token", value: AccountDataManager.shared.currentAccountData?.access_token ?? "")
        ]

        if let query = bodyComponents.percentEncodedQuery {
            request.httpBody = Data(query.utf8)
        }

        
        do {
            // 发起网络请求，并等待异步任务完成
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解码JSON响应
            let decoder = JSONDecoder()
            let result = try decoder.decode(AccountInfoModifyResponse.self, from: data)
            
            // 在主线程更新关注用户列表信息
            DispatchQueue.main.async {
                self.response = result
            }
        } catch {
            // 抛出错误，以便外部处理
            throw error
        }
    }
}



#Preview {
    NavigationStack{
        AccountInfoModify().navigationTitle("资料修改")
    }
}
