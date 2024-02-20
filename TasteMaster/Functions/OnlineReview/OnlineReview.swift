//
//  CloudStore.swift
//  TasteMaster
//
//  Created by Sekiro on 18/2/2024.
//

import Foundation
import SwiftUI

struct OnlineReview: View{
    var body: some View{
        ScrollView{
            //加粗字体
            Text("开发中").font(.title).bold().padding()
        }
    }
}

#Preview {
    NavigationStack{
        OnlineReview().navigationTitle("味评共鉴")
    }
}
