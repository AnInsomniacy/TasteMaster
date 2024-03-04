//
//  ArticleViews.swift
//  TasteMaster
//
//  Created by Sekiro on 4/3/2024.
//

import Foundation
import SwiftUI
import URLImage
import MarkdownUI


//文章列表展示卡片
struct ArticleCard: View {
    
    @State var avatarUrl_input:String?
    @State var author_name:String
    @State var article_title:String
    @State var article_id:Int
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View{
        
        let cardData = AccountCardData()//卡片规格信息
        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
            .overlay(
                VStack{
                    
                    HStack(spacing:-36){
                        
                        VStack(spacing :-40){
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
                                        .frame(width: 130, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }.padding()
                            } else {
                                // 处理当 avatar_url 为 nil 或无法转换为 URL 的情况
                                // 可以显示默认的占位图像或采取其他处理方式
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 130, height: 130)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                            }
                            
                            
                            Text("By: \(author_name)")
                                .font(.title)
                                .fontWeight(.bold)
                                .lineLimit(1) // 没有行数限制，自动换行
                                .fixedSize(horizontal: false, vertical: true).padding()
                        }.padding()
                        
                        VStack(spacing: -16){
                            Text(article_title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .lineLimit(2) // 最多显示3行
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                            
                            NavigationLink(destination: ArticleDetailView(article_id: article_id).navigationTitle("文章详情")){
                                RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                                    .foregroundColor(.indigo) // 根据配色方案设置背景颜色
                                    .overlay(
                                        HStack {
                                            Text("查看文章  ->").foregroundColor(Color.white)
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
                        }.padding()
                        
                    }
                    
                    
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

//文章卡片管理
struct ArticleCardManagement: View {
    
    @State var avatarUrl_input:String?
    @State var author_name:String
    @State var article_title:String
    @State var article_id:Int
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View{
        
        let cardData = AccountCardData()//卡片规格信息
        RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
            .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
            .overlay(
                VStack{
                    
                    HStack(spacing:-36){
                        
                        VStack(spacing :-40){
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
                                        .frame(width: 130, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }.padding()
                            } else {
                                // 处理当 avatar_url 为 nil 或无法转换为 URL 的情况
                                // 可以显示默认的占位图像或采取其他处理方式
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 130, height: 130)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                            }
                            
                            
                            Text("By: \(author_name)")
                                .font(.title)
                                .fontWeight(.bold)
                                .lineLimit(1) // 没有行数限制，自动换行
                                .fixedSize(horizontal: false, vertical: true).padding()
                        }.padding()
                        
                        VStack(spacing: -16){
                            Text(article_title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .lineLimit(2) // 最多显示3行
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                            
                            NavigationLink(destination: ArticleDetailManagementView(article_id: article_id).navigationTitle("文章管理")){
                                RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                                    .foregroundColor(.indigo) // 根据配色方案设置背景颜色
                                    .overlay(
                                        HStack {
                                            Text("管理文章  ->").foregroundColor(Color.white)
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
                        }.padding()
                        
                    }
                    
                    
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


//查看文章详情页面
struct ArticleDetailView: View {
    // 传入的文章ID
    var article_id: Int
    
    let cardData = AccountCardData()//卡片规格信息
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    // 创建文章视图模型
    @StateObject private var articleDetailVM = ArticleDetailViewModel()
    
    var body: some View{
        NavigationStack{
            ScrollView{
                VStack(spacing: -16){
                    Text("")//移除顶部空白
                    if let articleDetailData = articleDetailVM.ArticleDetailData {
                        if articleDetailData.result == "success" {
                            if let article_list = articleDetailData.article_list {
                                
                                VStack(spacing: -60){
                                    VStack(spacing: -70){
                                        Text("")//移除顶部空白
                                        if let avatarURLString = articleDetailVM.ArticleDetailData?.article_list?.article_img_url,
                                           let avatarURL = URL(string: avatarURLString) {
                                            URLImage(avatarURL) {
                                                // 如果图像不可用，则占位符或其他视图
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 200, height: 200)
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
                                                    .frame(width: 200, height: 200)
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
                                        
                                        HStack(spacing: -50){
                                            // 作者信息
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundColor(.indigo) // 根据配色方案设置背景颜色
                                                .padding()
                                                .overlay(
                                                    Text("作者: \(article_list.author)")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white) // 文本颜色
                                                ).padding().frame(height: 120)
                                            
                                            //进入作者主页
                                            NavigationLink(destination: UserMainPage(user_id: String(article_list.author_id)).navigationTitle("用户主页")){
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.indigo) // 根据配色方案设置背景颜色
                                                    .overlay(
                                                        HStack {
                                                            Text("查看主页 ->").foregroundColor(Color.white)
                                                        }
                                                    )
                                                    .padding()// 设置 HStack 的固定宽度
                                                    .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                                            .padding()
                                                        
                                                    )
                                            }.padding()
                                            
                                            
                                        }.padding()
                                    }.padding()
                                    
                                    
                                    //文章标题
                                    Text(article_list.title)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                
                                    //修改日期，用小字体标注
                                    Text("更新日期: \(article_list.updated_time)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding()
                                
                                //文章内容
                                Markdown(article_list.content)
                                    .padding()
                                
                                
                                
                            }
                        }
                    }
                    
                    //                    Button("debug"){
                    //                        Task {
                    //                            do {
                    //                                try await articleDetailVM.getArticleDetail(article_id: String(article_id))
                    //                                if let articleDetailData = articleDetailVM.ArticleDetailData {
                    //                                    print(articleDetailData)
                    //                                }
                    //                            } catch {
                    //                                print(error)
                    //                            }
                    //                        }
                    //                    }
                    
                }.onAppear{
                        Task {
                            do {
                                try await articleDetailVM.getArticleDetail(article_id: String(article_id))
                                if let articleDetailData = articleDetailVM.ArticleDetailData {
                                    print(articleDetailData)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
            }
        }
    }
}

//文章管理视图模型
struct ArticleDetailManagementView: View {
    // 传入的文章ID
    var article_id: Int
    let cardData = AccountCardData()//卡片规格信息
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowDeleteAlert = false
    @State private var isDeleting = false
    @State private var deleteButtonLabel = "删除文章"
    @State private var deleteButtonColor = Color.pink
    
    // 创建文章视图模型
    @StateObject private var articleDetailVM = ArticleDetailViewModel()
    @StateObject private var deleteArticleVM = DeleteArticleViewModel()
    
    var body: some View{
            ScrollView{
                VStack(spacing: -16){
                    if let articleDetailData = articleDetailVM.ArticleDetailData {
                        if articleDetailData.result == "success" {
                            if let article_list = articleDetailData.article_list {
                                
                                VStack(spacing: -60){
                                        Text("")//移除顶部空白
                                    HStack(spacing: -40){
                                        if let avatarURLString = articleDetailVM.ArticleDetailData?.article_list?.article_img_url,
                                           let avatarURL = URL(string: avatarURLString) {
                                            URLImage(avatarURL) {
                                                // 如果图像不可用，则占位符或其他视图
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 200, height: 200)
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
                                                    .frame(width: 200, height: 200)
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
                                        
                                        VStack(spacing: -50){

                                            //修改文章
                                            NavigationLink(destination: ArticleModification(article_id: String(article_list.article_id),articleTitle: article_list.title,imageURLString: article_list.article_img_url,articleContent: article_list.content).navigationTitle("修改文章")){
                                                RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                                                    .foregroundColor(colorScheme == .dark ? cardData.cardColorDark : cardData.cardColorLight) // 根据配色方案设置背景颜色
                                                    .overlay(
                                                        HStack {
                                                            
                                                            Text("修改文章").foregroundColor(Color.primary)
                                                            
                                                        }
                                                    )
                                                    .padding()
                                                    .frame(height: 86) // 设置 HStack 的固定宽度
                                                    .frame(width: 136) // 设置 HStack 的固定宽度
                                                    .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                                            .padding()
                                                        
                                                    )
                                            }.padding()
                                            
                                            //删除文章
                                            Button(action: {
                                                
                                                isShowDeleteAlert.toggle()
                                                
                                                
                                                print("删除文章")
                                            }){
                                                RoundedRectangle(cornerRadius: cardData.cornerRadius) // 设置圆角半径
                                                    .foregroundColor(deleteButtonColor) // 根据配色方案设置背景颜色
                                                    .overlay(
                                                        HStack {
                                                            
                                                            Text(deleteButtonLabel).foregroundColor(Color.primary)
                                                            
                                                        }
                                                    )
                                                    .padding()
                                                    .frame(height: 86) // 设置 HStack 的固定宽度
                                                    .frame(width: 136) // 设置 HStack 的固定宽度
                                                    .shadow(color: colorScheme == .dark ? cardData.cardShadowColorDark : cardData.cardShadowColorLight, radius: 10, x: 10, y: 10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(colorScheme == .dark ? cardData.cardBorderColorDark : cardData.cardBorderColorLight, lineWidth: 2)
                                                            .padding()
                                                        
                                                    )
                                            }
                                            .padding()
                                            .cornerRadius(10)
                                            .alert(isPresented: $isShowDeleteAlert) {
                                                Alert(
                                                    title: Text("确认删除"),
                                                    message: Text("您确定要删除这篇文章吗？"),
                                                    primaryButton: .default(Text("取消")),
                                                    secondaryButton: .destructive(Text("确认"), action: {
                                                        // 在此处添加发布文章的逻辑
                                                        Task {
                                                            isDeleting = true
                                                            do {
                                                                deleteArticleVM.article_id = String(article_id)
                                                                
                                                                try await deleteArticleVM.request()
                                                                
                                                                //如果article_id存在
                                                                if let article_id = deleteArticleVM.response?.article_id {
                                                                    print("删除文章成功, article_id: \(article_id)")
                                                                    
                                                                    deleteButtonLabel = "删除成功"
                                                                    
                                                                    deleteButtonColor = .green
                                                                    
                                                                    //延迟1秒后关闭页面
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                        presentationMode.wrappedValue.dismiss()
                                                                    }
                                                                    
                                                                }else{
                                                                    print("删除文章失败")
                                                                    deleteButtonLabel = "删除失败"
                                                                    deleteButtonColor = .gray
                                                                    
                                                                    //延迟一秒
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                        deleteButtonLabel = "删除文章"
                                                                        deleteButtonColor = .pink
                                                                    }
                                                                    
                                                                }
                                                            }
                                                            isDeleting = false
                                                        }
                                                    })
                                                )
                                            }
                                            
                                        }.padding()
                                        
                                    }.padding()
                                    
                                    
                                    //文章标题
                                    Text(article_list.title)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                
                                    
                                    //修改日期，用小字体标注
                                    Text("更新日期: \(article_list.updated_time)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding()
                                
                                //文章内容
                                Markdown(article_list.content)
                                    .padding()
                                
                                
                                
                                
                            }
                        }
                    }
                    
                }.onAppear{
                        Task {
                            do {
                                try await articleDetailVM.getArticleDetail(article_id: String(article_id))
                                if let articleDetailData = articleDetailVM.ArticleDetailData {
                                    print(articleDetailData)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
            }
    }
}

//删除文章API
//返回结构体
struct DeleteArticleData: Codable {
    let result: String
    let article_id: String?
}

//删除文章视图模型
class DeleteArticleViewModel: ObservableObject {
    @Published var response: DeleteArticleData?
    @Published var article_id: String = ""
    
    func request() async throws{
        // 构建获取关注用户列表接口的URL
        guard let url = URL(string: baseURL + "/api/delete_article_by_id/") else {
            return
        }
        
        // 创建POST请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "article_id", value: article_id),
            //access_token
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
            let result = try decoder.decode(DeleteArticleData.self, from: data)
            
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


#Preview{
    NavigationStack{
        ArticleDetailManagementView(article_id: 9).navigationTitle("文章管理")
    }
}
