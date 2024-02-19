//
//  AccountData.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation

//用户信息结构体
struct AccountData: Identifiable {
    var id = UUID()
    var user_id: Int
    var username: String
    var follower_num: Int
    var followed_user_list: String
    var fans_num: Int
    var fans_user_list: String
    var article_num: Int
    var article_list: String
    var avatar_url: String
    var self_introduction: String
}
