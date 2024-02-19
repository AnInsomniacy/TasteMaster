import Foundation
import SwiftUI

// API密钥和私钥
var API_Key_Image = "97s8YfWBND83KivDTCo4Y8FS"
var Secret_Key_Image = "QiGlInACY2amhUbpLK450CgocQkmuvjB"

enum NetworkError_image: Error {
    case invalidURL // 无效的URL
    case dataLoadingError(String) // 数据加载错误
    case imageProcessingError // 图片处理错误
}

func recognizeImage(image: UIImage,itemType: String) async throws -> String {
    let accessToken = try await requestAccessToken(API_Key: API_Key_Image, Secret_Key: Secret_Key_Image)
    
    var urlString: String
    
    switch itemType {
    case "advanced_general":
        urlString = "https://aip.baidubce.com/rest/2.0/image-classify/v2/advanced_general?access_token=\(accessToken)"
    case "animal":
        urlString = "https://aip.baidubce.com/rest/2.0/image-classify/v1/animal?access_token=\(accessToken)"
    case "plant":
        urlString = "https://aip.baidubce.com/rest/2.0/image-classify/v1/plant?access_token=\(accessToken)"
    case "ingredient":
        urlString = "https://aip.baidubce.com/rest/2.0/image-classify/v1/classify/ingredient?access_token=\(accessToken)"
    case "dish":
        urlString = "https://aip.baidubce.com/rest/2.0/image-classify/v2/dish?access_token=\(accessToken)"
    default:
        urlString = "https://aip.baidubce.com/rest/2.0/image-classify/v2/advanced_general?access_token=\(accessToken)"
    }
    
    guard let url = URL(string: urlString) else {
        throw NetworkError_image.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 将UIImage转为Base64
    guard let imageData = image.jpegData(compressionQuality: 0.5) else {
        throw NetworkError_image.dataLoadingError("无法将图片转换为数据")
    }
    var base64Image = imageData.base64EncodedString()
    
    // 移除base64头部
    base64Image = base64Image.replacingOccurrences(of: "data:image/jpg;base64,", with: "")
    
    // 对图片数据进行URL编码
    guard let encodedImageString = base64Image.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
        throw NetworkError_image.imageProcessingError
    }
    
    let parameters: [String: Any] = [
        "image": encodedImageString,
    ]
    
    let bodyString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    request.httpBody = bodyString.data(using: .utf8)
    
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NetworkError_image.dataLoadingError("服务器的响应无效")
    }
    
    // 返回JSON字符串
    if let jsonString = String(data: data, encoding: .utf8) {
        print(jsonString)
        switch itemType {
        case "advanced_general":
            let formattedString = advanced_general_json(jsonData: jsonString.data(using: .utf8)!)
            return formattedString
        case "animal":
            let formattedText = animal_json(jsonString: jsonString)
            return formattedText
        case "plant":
            let formattedText = plant_json(jsonString: jsonString)
            return formattedText
        case "ingredient":
            let formattedText = ingredient_json(jsonString: jsonString)
            return formattedText
        case "dish":
            let formattedText = dish_json(jsonString: jsonString)
            return formattedText
        default:
            return jsonString
        }
        
    } else {
        throw NetworkError_image.dataLoadingError("无法将接收到的数据转换为字符串")
    }
}

//通用物品识别
func advanced_general_json(jsonData: Data) -> String {
    // 定义数据结构
    struct Response: Codable {
        var log_id: UInt64
        var result_num: UInt32
        var result: [ResultItem]
    }
    
    struct ResultItem: Codable {
        var score: Float
        var root: String
        var keyword: String
        var baike_info: BaikeInfo?
    }
    
    struct BaikeInfo: Codable {
        var baike_url: String?
        var image_url: String?
        var description: String?
    }
    
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(Response.self, from: jsonData)
        
        var output = "总共有 \(response.result_num) 个结果:\n\n"
        for item in response.result {
            output += "物体/场景: \(item.keyword)\n"
            output += "分类: \(item.root)\n"
            output += "置信度: \(item.score)\n"
            
            if let baike = item.baike_info {
                output += "百度百科链接: \(baike.baike_url ?? "无")\n"
                output += "图片链接: \(baike.image_url ?? "无")\n"
                output += "描述: \(baike.description ?? "无")\n"
            }
            
            output += "\n"  // 为了更好的可读性，在条目之间添加新行
        }
        return output
    } catch {
        return "解析错误: \(error)"
    }
}


func animal_json(jsonString: String) -> String {
    
    // 数据模型
    struct ApiResponse: Codable {
        let log_id: UInt64
        let result: [Animal]
    }
    
    struct Animal: Codable {
        let score: String
        let name: String
        let baike_info: BaikeInfo?
    }
    
    struct BaikeInfo: Codable {
        let baike_url: String?
        let image_url: String?
        let description: String?
    }
    
    guard let jsonData = jsonString.data(using: .utf8) else {
        return "无法转换为Data格式"
    }
    
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(ApiResponse.self, from: jsonData)
        
        // 开始格式化为用户友好的字符串
        var output = ""
        
        for animal in response.result {
            output += "\n名称: \(animal.name)"
            output += "\n置信度: \(animal.score)"
            if let baike = animal.baike_info {
                output += "\n百科链接: \(baike.baike_url ?? "无")"
                output += "\n描述: \(baike.description ?? "无描述")"
            }
            output += "\n--------------------"
        }
        
        return output
    } catch {
        return "解析JSON时出错: \(error)"
    }
}

func plant_json(jsonString: String) -> String {
    
    // 数据模型
    struct ApiResponse: Codable {
        let log_id: UInt64
        let result: [Plant]
    }
    
    struct Plant: Codable {
        let score: Float
        let name: String
        let baike_info: BaikeInfo?
    }
    
    struct BaikeInfo: Codable {
        let baike_url: String?
        let image_url: String?
        let description: String?
    }
    
    guard let jsonData = jsonString.data(using: .utf8) else {
        return "无法转换为Data格式"
    }
    
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(ApiResponse.self, from: jsonData)
        
        // 开始格式化为用户友好的字符串
        var output = ""
        
        for animal in response.result {
            output += "\n名称: \(animal.name)"
            output += "\n置信度: \(animal.score)"
            if let baike = animal.baike_info {
                output += "\n百科链接: \(baike.baike_url ?? "无")"
                output += "\n描述: \(baike.description ?? "无描述")"
            }
            output += "\n--------------------"
        }
        
        return output
    } catch {
        return "解析JSON时出错: \(error)"
    }
}

func ingredient_json(jsonString: String) -> String {
    
    // 数据模型
    struct ApiResponse: Codable {
        let log_id: UInt64
        let result: [Plant]
    }
    
    struct Plant: Codable {
        let score: Float
        let name: String
        let baike_info: BaikeInfo?
    }
    
    struct BaikeInfo: Codable {
        let baike_url: String?
        let image_url: String?
        let description: String?
    }
    
    guard let jsonData = jsonString.data(using: .utf8) else {
        return "无法转换为Data格式"
    }
    
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(ApiResponse.self, from: jsonData)
        
        // 开始格式化为用户友好的字符串
        var output = ""
        
        for animal in response.result {
            output += "\n名称: \(animal.name)"
            output += "\n置信度: \(animal.score)"
            if let baike = animal.baike_info {
                output += "\n百科链接: \(baike.baike_url ?? "无")"
                output += "\n描述: \(baike.description ?? "无描述")"
            }
            output += "\n--------------------"
        }
        
        return output
    } catch {
        return "解析JSON时出错: \(error)"
    }
}

func dish_json(jsonString: String) -> String {
    
    // 数据模型
    struct ApiResponse: Codable {
        let log_id: UInt64
        let result: [Plant]
    }
    
    struct Plant: Codable {
        let name: String
        let baike_info: BaikeInfo?
        let probability: String
        let has_calorie: Bool
        let calorie: String?
    }
    
    struct BaikeInfo: Codable {
        let baike_url: String?
        let image_url: String?
        let description: String?
    }
    
    guard let jsonData = jsonString.data(using: .utf8) else {
        return "无法转换为Data格式"
    }
    
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(ApiResponse.self, from: jsonData)
        
        // 开始格式化为用户友好的字符串
        var output = ""
        
        for animal in response.result {
            output += "\n名称: \(animal.name)"
            if let baike = animal.baike_info {
                output += "\n百科链接: \(baike.baike_url ?? "无")"
                output += "\n描述: \(baike.description ?? "无描述")"
            }
            output += "\n置信度: \(animal.probability)"
            //卡路里结果写成"有"或"无"
            output += "\n是否有卡路里: \(animal.has_calorie ? "有" : "无")"
            if animal.has_calorie {
                output += "\n卡路里: \(animal.calorie ?? "无")"
            }
            output += "\n--------------------"
        }
        
        return output
    } catch {
        return "解析JSON时出错: \(error)"
    }
}

