//
//  AIAnalyst.swift
//  TasteMaster
//
//  Created by Sekiro on 29/10/2023.
//

import Foundation
import SwiftUI

struct AIAnalyst: View{
    
    @State private var questionText: String = ""
    @State private var answerText: String = ""
    @State private var currentTask: Task<Void, Error>? = nil
    @State private var isRunning: Bool = false  // 用于追踪是否有任务正在运行
    @State private var interactionDisabled: Bool = false // 用于控制按钮的交互能力
    
    
    var body: some View{
        ScrollView{
            HStack {
                Text("请在下方输入您的问题:")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)  // 使文本在可用空间内靠左对齐
                
                Spacer()  // 这将推动文本保持在左侧
            }
            
            TextEditor(text: $questionText)
                .frame(minHeight: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                    
                )
                .overlay(
                    Text("请输入您的问题")
                        .foregroundColor(.gray)
                        .padding(.leading, 4) // 调整灰色提示文本的位置
                        .opacity(questionText.isEmpty ? 1.0 : 0) // 根据用户输入是否为空来控制提示文本的可见性
                        .onTapGesture {
                            // 用户点击文本编辑框时，自动将焦点移到文本编辑框
                            withAnimation {
                                questionText = ""
                            }
                        }
                    //启用触摸穿透
                        .allowsHitTesting(false)
                )
                .padding()
            
            
            HStack {
                // 清空/取消按钮
                Button(action: {
                    // 如果任务正在运行，则取消任务
                    currentTask?.cancel()
                    //关闭键盘
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if isRunning {
                        // 如果任务正在运行，则取消任务
                        currentTask?.cancel()
                        isRunning = false
                    } else {
                        // 如果没有任务运行，清空文本
                        questionText = ""
                        answerText = ""
                    }
                }, label: {
                    Text(isRunning ? "取消" : "清空")
                        .fontWeight(.semibold)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 60)
                        .background(Color(.systemGray5))
                        .foregroundColor(isRunning ? .gray : .blue)
                        .cornerRadius(12)
                        .disabled(interactionDisabled)  // 禁用交互（基于状态）
                })
                
                // 提问/运行中按钮
                Button(action: {
                    // 如果任务正在运行，则取消任务
                    currentTask?.cancel()
                    if !isRunning {
                        print("提问")
                        isRunning = true
                        interactionDisabled = true  // 开始任务时禁用交互
                        
                        answerText = ""  // 重置答案文本
                        
                        //关闭键盘
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        // 启动一个新的Task来处理可能的长时间运行请求
                        currentTask = Task {
                            do {
                                // 保持原有的调用不变
                                try await sendRequestToAIEndpoint(content: questionText) { data in
                                    DispatchQueue.main.async {
                                        answerText += data
                                        isRunning = false
                                        
                                    }
                                }
                            } catch {
                                // 处理错误和任务取消
                                DispatchQueue.main.async {
                                    if error is CancellationError {
                                        print("Task was cancelled")
                                    } else {
                                        print("An error occurred: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Text(isRunning ? "运行中..." : "提问")
                        .fontWeight(.semibold)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 60)
                        .background(Color(.systemGray5))
                        .foregroundColor(isRunning ? .gray : .blue)
                        .cornerRadius(12)
                        .disabled(interactionDisabled)  // 禁用交互（基于状态）
                })
            }.padding(2)
            
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text("应答区:")
                    .font(.headline) // 可选的，增加字体大小使其更加突出。
                    .padding(.bottom, 2) // 如果需要，可以在“应答区”标题和答案文本之间添加一些空间。
                
                ScrollView {
                    ScrollViewReader { scrollView in
                        // Text被包裹在VStack中，以便我们可以在其下方添加一个隐藏的Rectangle（作为锚点）。
                        VStack(alignment: .leading) {
                            Text(answerText)
                                .padding(1) // 根据您的设计需求调整填充。
                                .id("endOfScrollView") // 给文本视图一个ID，我们稍后会引用它来进行滚动。
                            
                            // 这是一个透明的视图，用作滚动视图的锚点。
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 1, height: 1)
                        }
                        .onChange(of: answerText) { _ in  // 当answerText发生变化时触发。
                            withAnimation {
                                scrollView.scrollTo("endOfScrollView", anchor: .bottom) // 自动滚动到Text视图。
                            }
                        }
                    }
                }
            }
            .padding() // 这个内边距是针对文本的，给文本和边框之间提供空间。
            .frame(maxWidth: .infinity, minHeight:300, maxHeight: 300, alignment: .topLeading) // 宽度尽可能大，设置最小高度，并使内容顶部左对齐。
            .overlay(
                RoundedRectangle(cornerRadius: 10) // 您可以根据需要调整圆角值。
                    .stroke(lineWidth: 1) // 您可以设置边框的颜色和线宽。
            )
            .padding() // 这个外边距是针对整个视图的，可以根据需要调整。
            
            
            
            
        }.navigationTitle("AI 问答")
    }
}

#Preview {
    NavigationStack{
        AIAnalyst()
    }
}
