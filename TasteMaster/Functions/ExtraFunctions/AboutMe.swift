//
//  AboutMe.swift
//  TasteMaster
//
//  Created by Sekiro on 3/12/2023.
//

import SwiftUI

struct AboutMe: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                Group {
                    Text("姓名：AnInsomniac")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("本程序为毕业设计项目")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("学校：\n\n华南师范大学2020级网络工程专业")
                        .font(.headline)
                }
                .padding(.bottom, 10) // 调整组之间的间距
                
                Group {
                    Text("GitHub：")
                        .font(.headline)
                    Link("https://github.com/AnInsomniacy", destination: URL(string: "https://github.com/AnInsomniacy")!)
                    
                    Text("技能：")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("编程语言： C++, Python, Java, JavaScript, Swift")
                        Text("Web开发： HTML, CSS, React")
                        Text("数据库： SQL, MongoDB")
                        Text("操作系统： Linux, Windows, macOS")
                    }
                }
                .padding(.bottom, 10)
                
                Group {
                    Text("当前项目：")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("[项目 1]: 使用 React 和 Node.js 构建的 Web 应用")
                        Text("[项目 2]: 使用 Python 和 TensorFlow 的机器学习项目")
                    }
                }
            }
            .padding()
            .navigationTitle("关于作者")
        }
    }
}

#Preview {
    AboutMe()
}
