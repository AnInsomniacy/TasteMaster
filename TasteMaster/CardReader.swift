import SwiftUI
import MarkdownUI
import Foundation

struct CardReader: View {
    var cardInfo: CardInfo
    @State private var markdownString: String = ""
    @State private var isLoading: Bool = true  // 用于追踪是否正在加载内容
    @State var isFavorited: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    init(cardInfo: CardInfo) {
        self.cardInfo = cardInfo
    }
    
    var body: some View {
        VStack {
            
            if isLoading {
                // 正在加载时显示加载指示器
                ProgressView("正在加载...")
            } else {
                // 加载完成时显示内容
                ScrollView {
                    HStack {
                        Button(action: {
                            if self.isFavorited {
                                // 如果当前已收藏，那么取消收藏
                                FavoriteCardsInfoManager.removeFavorite(text: cardInfo.text)
                            } else {
                                // 如果当前未收藏，那么添加收藏
                                FavoriteCardsInfoManager.addFavorite(text: cardInfo.text)
                            }
                            
                            // 更新收藏状态
                            self.isFavorited = FavoriteCardsInfoManager.isFavorite(text: cardInfo.text)
                            
                        }, label: {
                            HStack {
                                // 单独为图像添加阴影，而不影响文本
                                Image(systemName: isFavorited ? "star.fill" : "star")
                                    .foregroundColor(isFavorited ? .yellow : (colorScheme == .dark ? .white : .black))
                                    .font(.system(size: 25))
                                
                                // 根据当前的收藏状态，显示对应的文本
                                Text(isFavorited ? "已经收藏" : "未收藏")
                                    .foregroundColor(colorScheme == .dark ? .white : .black) // 深色模式下的文字颜色适配
                                // 不为文字添加阴影
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundColor(colorScheme == .dark ? .black : .white) // 深色模式背景色
                            ).overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(lineWidth: 2) // 控制边框线宽
                                    .foregroundColor(.gray) // 这里是边框的颜色
                            )
                        })
                        
                        Spacer()  // 这会将按钮推到左侧
                    }  // 注意这里的 HStack 结束
                    .padding(.horizontal)
                    Markdown(markdownString)
                        .padding(.horizontal)
                    //添加空行
                    Spacer()
                    //添加空行
                    Spacer()
                    //添加空行
                    Spacer()
                }
            }
        }
        .navigationTitle("收藏状态")
        .onAppear {
            // 视图即将出现时，重新检查收藏状态
            self.isFavorited = FavoriteCardsInfoManager.isFavorite(text: cardInfo.text)
        }
        .task {
            // 异步加载内容
            await loadMarkdownContent()
        }
    }
    
    private func loadMarkdownContent() async {
        self.isLoading = true
        defer { self.isLoading = false }  // 确保在函数退出时更改加载状态
        
        let fileName = cardInfo.text + ".md"
        
        // 递归查找Markdown文件并加载内容
        if let path = await findMarkdownPath(for: fileName, in: "Materials"),
           let content = try? String(contentsOfFile: path, encoding: .utf8) {
            markdownString = content
        } else {
            markdownString = "文件读取错误，请重试"
        }
    }
    
    private func findMarkdownPath(for fileName: String, in directory: String) async -> String? {
        let fileManager = FileManager.default
        
        // 获取资源路径
        guard let resourcePath = Bundle.main.resourcePath else {
            return nil
        }
        
        let folderPath = resourcePath.appending("/\(directory)")
        
        if let enumerator = fileManager.enumerator(atPath: folderPath) {
            for case let filePath as String in enumerator {
                if filePath.hasSuffix(fileName) {
                    // 构建完整的文件路径并返回
                    return folderPath.appending("/\(filePath)")
                }
            }
        }
        // 如果找不到文件，返回nil
        return nil
    }
}

// 预览部分
struct CardReader_Previews: PreviewProvider {
    static var previews: some View {
        @State var cardInfo = CardInfo(image: "list.number", text: "厨房准备", color: .purple, destination: AnyView(Text("厨房准备")))
        NavigationStack {
            CardReader(cardInfo: cardInfo)
        }
    }
}
