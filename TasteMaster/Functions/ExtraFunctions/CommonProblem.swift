//
//  CommonProblem.swift
//  TasteMaster
//
//  Created by Sekiro on 3/12/2023.
//

import Foundation
import SwiftUI

struct CommonProblem:View {
    var body: some View {
        VStack{
            Text("待开发")                        
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding()
        }.navigationTitle("常见问题")
    }
}

#Preview {
    NavigationStack{
        CommonProblem()
    }
}
