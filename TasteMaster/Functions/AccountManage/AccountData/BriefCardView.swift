//
//  BriefCardView.swift
//  TasteMaster
//
//  Created by Sekiro on 3/3/2024.
//

import Foundation
import SwiftUI
import URLImage

//用户简要卡片信息
struct UserBriefInfo: View{
    
    @State var avatarUrl_input:String?
    @State var currentUsername_input:String
    @State var user_id:String
    @State var followButtonText:String = "立即关注"
    @State var followButtonColor:Color = .indigo
    
    @State var isFollowed:Bool = false
    
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
                            
                            //查看主页按钮
                            NavigationLink(destination:UserMainPage(user_id: user_id)
                                .navigationTitle("用户主页")
                            ){
                                Text("查看主页")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }.padding()
                            
                            //关注判定按钮
                            Button(action: {
                                
                                if isFollowed {
                                    Task{
                                        do{
                                            
                                            let result = try await unfollowUser(unfollow_user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                                            
                                            isFollowed.toggle()
                                            followButtonText = isFollowed ? "取消关注" : "立即关注"
                                            followButtonColor = isFollowed ? .red : .indigo
                                            
                                            print(result)
                                            
                                        }catch{
                                            print("关注失败")
                                        }
                                    }
                                } else {
                                    
                                    Task{
                                        do{
                                            
                                            let result = try await followUser(follow_user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                                            
                                            isFollowed.toggle()
                                            followButtonText = isFollowed ? "取消关注" : "立即关注"
                                            followButtonColor = isFollowed ? .red : .indigo
                                            
                                            print(result)
                                            
                                        }catch{
                                            print("取消关注失败")
                                        }
                                    }
                                    
                                }
                                
                                
                            }) {
                                Text(followButtonText)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(followButtonColor)
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
            ).onAppear{
                //界面一出现就判定是否关注
                Task{
                    do{
                        isFollowed = try await getFollowStatus(user_id: user_id, access_token: AccountDataManager.shared.currentAccountData?.access_token ?? "")
                        
                        followButtonText = isFollowed ? "取消关注" : "立即关注"
                        
                        followButtonColor = isFollowed ? .red : .indigo
                        
                    }
                }
            }
    }
}


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
                                
                                //文章内容
                                Text(article_list.content)
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
    
    // 创建文章视图模型
    @StateObject private var articleDetailVM = ArticleDetailViewModel()
    
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
                                        
                                        VStack(spacing: -20){

                                            //修改文章
                                            NavigationLink(destination: ArticleModification().navigationTitle("修改文章")){
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
                                                print("删除文章")
                                            }){
                                                Text("删除文章")                            .foregroundColor(.white)
                                                    .font(.headline)
                                            }
                                            .padding()
                                            .background(.pink)
                                            .cornerRadius(10)
                                            
                                            //向上抬升一点点
                                            Spacer().frame(height: 54)
                                            
                                        }.padding()
                                        
                                    }.padding()
                                    
                                    
                                    //文章标题
                                    Text(article_list.title)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                
                                //文章内容
                                Text(article_list.content)
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
