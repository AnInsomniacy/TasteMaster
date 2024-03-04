//
//  ArticleModification.swift
//  TasteMaster
//
//  Created by Sekiro on 2/3/2024.
//

import Foundation
import SwiftUI

struct ArticleModification: View{
    
    @State var article_id:String
    @State var articleTitle = ""
    @State var imageURLString = ""
    @State var articleContent = ""
    @State private var isConfirmationAlertPresented = false
    @State private var isPublishing = false
    @State private var publishButtonLabel = "确认修改"
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("修改文章标题")
                        .font(.title)
                        .padding(.top, 20)
                    
                    Text("标题是您吸引读者的最好方式")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        TextField("请输入文章标题", text: $articleTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // 图片url
                    Text("修改文章图片 URL 地址")
                        .font(.title)
                        .padding(.top, 20)
                    
                    Text("这将展示在文章封面上")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "camera.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        TextField("请输入图片 URL 地址", text: $imageURLString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // 文章内容
                    Text("修改文章内容")
                        .font(.title)
                        .padding(.top, 20)
                    
                    HStack {
                        
                        Image(systemName: "pencil.line")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Text("文章支持MarkDown格式")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // 文章本体内容，多行输入，最小高度为200，然后随着文章内容的增加而增加,添加边框
                    TextEditor(text: $articleContent)
                        .frame(minHeight: 180)
                        .border(Color.gray, width: 1)
                        .cornerRadius(5)
                    
                }
                
                
                HStack {
                    
                    //取消发布
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("取消发布")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    
                    // 收起键盘
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("收起键盘")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    
                    
                    Button(action: {
                        // 确认发布
                        isConfirmationAlertPresented.toggle()
                    }) {
                        Text(publishButtonLabel)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(isPublishing ? Color.gray : Color.blue)
                            .cornerRadius(10)
                            .disabled(isPublishing)
                    }
                }
                
            }.padding()
            .alert(isPresented: $isConfirmationAlertPresented) {
                Alert(
                    title: Text("确认修改"),
                    message: Text("您确定要修改这篇文章吗？"),
                    primaryButton: .default(Text("取消")),
                    secondaryButton: .destructive(Text("确认"), action: {
                        // 在此处添加发布文章的逻辑
                        Task {
                            isPublishing = true
                            do {
                                let request = ArticleModificationRequest()
                                request.article_title = articleTitle
                                request.image_url = imageURLString
                                request.article_content = articleContent
                                request.article_id = article_id
                                try await request.request()
                                
                                if request.response?.article_id != nil {
                                    publishButtonLabel = "修改成功"
                                    //延迟1秒后关闭页面
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                } else {
                                    publishButtonLabel = "修改失败，原因：\(request.response?.result ?? "未知原因")"
                                }
                            } catch {
                                publishButtonLabel = "修改失败，原因：\(error.localizedDescription)"
                            }
                            isPublishing = false
                        }
                    })
                )
            }
            
            .onAppear{
                //预载入文章数据
                
                
            }
        }
    }
}


//文章修改接口
// 返回结构体JSON适配
struct ArticleModificationResponse: Codable {
    var result: String
    var article_id: String?
    var article_title: String?
}

//文章发布接口
class ArticleModificationRequest: ObservableObject {
    
    @Published var response: ArticleModificationResponse?
    @Published var article_title = ""
    @Published var image_url = ""
    @Published var article_content = ""
    @Published var article_id = ""
    
    func request() async throws{
        // 构建获取关注用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/update_article_by_id/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "article_content", value: article_content),
            URLQueryItem(name: "image_url", value: image_url),
            URLQueryItem(name: "article_title", value: article_title),
            URLQueryItem(name: "article_id", value: article_id),
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
            let result = try decoder.decode(ArticleModificationResponse.self, from: data)
            
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
    ArticleModification(article_id: "9")
}
