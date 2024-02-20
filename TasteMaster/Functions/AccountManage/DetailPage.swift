//
//  DetailPage.swift
//  TasteMaster
//
//  Created by Sekiro on 20/2/2024.
//

import Foundation
import SwiftUI

//我的关注
struct MyFollowers: View {
    var body: some View {
        Text("我的关注")
    }
}

//我的粉丝
struct MyFans: View {
    var body: some View {
        Text("我的粉丝")
    }
}

//我的文章
struct MyArticles: View {
    var body: some View {
        Text("我的文章")
    }
}

//个人信息
struct MyInfo: View {
    var body: some View {
        Text("个人信息")
    }
}

#Preview {
    NavigationStack{
        MyFollowers()
    }
}
