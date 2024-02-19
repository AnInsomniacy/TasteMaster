//
//  plant_recognization.swift
//  TasteMaster
//
//  Created by Sekiro on 3/12/2023.
//

import Foundation
import SwiftUI
import Photos

struct plant_recognization: View{
    
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var answerText: String = ""
    @State private var isProcessing = false
    @State private var currentTask: Task<Void, Never>?
    
    var body: some View {
        ScrollView {
            HStack{
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Text("未选择照片")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                    
                }
                VStack{Button(action: {
                    //请求相册访问权限
                    PHPhotoLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized:
                            // 如果用户已授权访问照片库，显示图像选择器
                            showingImagePicker = true
                            answerText = ""
                        case .denied, .restricted:
                            // 如果访问被拒绝或受限，显示一个提示给用户
                            answerText = "无法访问照片，请在设置中授权权限"
                        default:
                            break
                        }
                    }
                }) {
                    Text("选择照片")
                        .font(.headline)
                        .padding()
                        .background(isProcessing ? Color.gray : Color.blue) // 检查是否在处理
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(isProcessing) // 如果正在处理则禁用按钮
                }
                .padding()
                    
                    //开始识别
                    Button(action: {
                        // Step 2: If there's an ongoing task, cancel it
                        currentTask?.cancel()
                        
                        answerText = ""
                        isProcessing = true
                        if let img = image {
                            currentTask = Task {
                                do {
                                    let jsonString = try await recognizeImage(image: img,itemType: "plant")
                                    answerText += jsonString
                                } catch {
                                    print("Error: \(error)")
                                }
                                isProcessing = false
                            }
                        } else {
                            answerText = "请先选择照片"
                            isProcessing = false
                        }
                    }) {
                        Text(isProcessing ? "处理中" : "开始识别")
                            .font(.headline)
                            .padding()
                            .background(isProcessing ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disabled(isProcessing)
                    }
                }
            }
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text("识别结果:")
                    .font(.headline) // 可选的，增加字体大小使其更加突出。
                    .padding(.bottom, 2) // 如果需要，可以在“应答区”标题和答案文本之间添加一些空间。
                
                ScrollView {
                    ScrollViewReader { scrollView in
                        // Text被包裹在VStack中，以便我们可以在其下方添加一个隐藏的Rectangle（作为锚点）。
                        VStack(alignment: .leading) {
                            Text(answerText)
                                .padding(1) // 根据您的设计需求调整填充。
                                .id("endOfScrollView") // 给文本视图一个ID，我们稍后会引用它来进行滚动。
                                .frame(maxWidth: .infinity, minHeight:360, maxHeight: 360, alignment: .topLeading)
                            
                            // 这是一个透明的视图，用作滚动视图的锚点。
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 1, height: 1)
                        }
                    }
                }
            }
            .padding() // 这个内边距是针对文本的，给文本和边框之间提供空间。
            .frame(maxWidth: .infinity, minHeight:380, maxHeight: 380, alignment: .topLeading) // 宽度尽可能大，设置最小高度，并使内容顶部左对齐。
            .overlay(
                RoundedRectangle(cornerRadius: 10) // 您可以根据需要调整圆角值。
                    .stroke(lineWidth: 1) // 您可以设置边框的颜色和线宽。
            )
            .padding() // 这个外边距是针对整个视图的，可以根据需要调整。
            
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $image)
            
        }.navigationTitle("植物识别")
    }
    
    func loadImage() {
        // 这里可以添加处理图片的代码，如果需要
    }
}

#Preview {
    NavigationStack{
        plant_recognization()
    }
}
