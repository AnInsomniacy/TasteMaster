//
//  BriefCardView.swift
//  TasteMaster
//
//  Created by Sekiro on 3/3/2024.
//

import Foundation
import SwiftUI
import URLImage
import MarkdownUI

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

