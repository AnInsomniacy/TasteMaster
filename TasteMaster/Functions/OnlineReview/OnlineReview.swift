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
            Text("开发中").font(.title).padding()
        }
    }
}

#Preview {
    NavigationStack{
        OnlineReview().navigationTitle("味评共鉴")
    }
}
