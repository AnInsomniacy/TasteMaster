//
//  CardModel.swift
//  TasteMaster
//
//  Created by Sekiro on 13/10/2023.
//

import Foundation
import SwiftUI

//卡片信息结构体
struct CardModel{
    //基本信息
    var width:CGFloat
    var height:CGFloat
    var radius:CGFloat
    var fontSize:Font
    
    //图片信息
    var imageWidth:CGFloat
    var imageHeight:CGFloat
    
    //卡片水平和垂直间隔
    var cardHSpaceMin: CGFloat// 水平间隔
    var cardHSpaceMax: CGFloat// 水平间隔
    var cardVSpace: CGFloat// 垂直间隔
    
    //卡片里文字和图片的距离
    var cardTextImageSpace: CGFloat
    
    //构造函数
    init(width:CGFloat,height:CGFloat,radius:CGFloat,fontSize:Font,imageWidth:CGFloat,imageHeight:CGFloat,cardHSpaceMin:CGFloat,cardHSpaceMax:CGFloat,cardVSpace:CGFloat,cardTextImageSpace:CGFloat){
        self.width = width
        self.height = height
        self.radius = radius
        self.fontSize = fontSize
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.cardHSpaceMin = cardHSpaceMin
        self.cardHSpaceMax = cardHSpaceMax
        self.cardVSpace = cardVSpace
        self.cardTextImageSpace = cardTextImageSpace
    }
    
    
}

struct CardInfo:Identifiable{
    
    var id = UUID()
    var image:String
    var text:String
    var color:Color
    var destination:AnyView?
    
    init(image:String,text:String,color:Color,destination:AnyView?){
        self.image = image
        self.text = text
        self.color = color
        self.destination = destination
    }
    
    func getContent()->AnyView{
        //判断destination类型
        if destination == nil{
            return AnyView(CardReader(cardInfo: CardInfo(image: image, text: text, color: color, destination: nil)))
        }
        return destination!
    }
}

class CardManager{
    
    //构建一个数组存放CardInfo
    var cardInfoList:[CardInfo] = []
    
    //构造函数,循环写入卡片信息
    init(cardInfoList:[CardInfo]){
        self.cardInfoList = cardInfoList
    }
    
    
    //清空数组
    func clear(){
        cardInfoList = []
    }
    
    //压入一个CardInfo
    func addCardInfo(card:CardInfo){
        cardInfoList.append(card)
    }
    
    //弹出一个CardInfo
    func popCardInfo()->CardInfo{
        return cardInfoList.popLast()!
    }
    
    //获取数组长度
    func getLength()->Int{
        return cardInfoList.count
    }
    
    //获取指定位置的CardInfo
    func getCardInfo(index:Int)->CardInfo{
        return cardInfoList[index]
    }
    
    //获取数组
    func getCardInfoArray()->[CardInfo]{
        return cardInfoList
    }
    
    //搜索数组，搜索text部分，把结果作为一个列表返回
    func searchCardInfo(text:String)->[CardInfo]{
        var result:[CardInfo] = []
        for card in cardInfoList{
            if card.text.contains(text){
                result.append(card)
            }
        }
        return result
    }
    
    //搜索数组，严格匹配text内容，不能多也不能少
    func searchCardInfoStrict(text:String)->[CardInfo]{
        var result:[CardInfo] = []
        for card in cardInfoList{
            if card.text == text{
                result.append(card)
            }
        }
        return result
    }
    
    //搜索数组，执行缺省搜索,输入搜索内容，返回搜索结果
    func searchCardInfoUnStrict(text:String)->[CardInfo]{
        var result:[CardInfo] = []
        for card in cardInfoList{
            if card.text.contains(text){
                result.append(card)
            }
        }
        return result
    }
    
    func searchCardInfoUnStrictAsync(text:String) async throws -> [CardInfo]{
        var result:[CardInfo] = []
        for card in cardInfoList{
            if card.text.contains(text){
                result.append(card)
            }
        }
        return result
    }
    
    
}

class FavoriteCardsManager: ObservableObject{
    // 存储收藏内容的数组,存的是cardinfo的text
    @Published var favoriteCards: [String]
    
    // UserDefaults 的键
    private let favoritesKey = "FavoriteCards"
    
    init() {
        // 从 UserDefaults 加载已保存的收藏内容
        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            favoriteCards = savedFavorites
        } else {
            favoriteCards = []
        }
    }
    
    // 添加收藏内容,只添加text部分
    func addFavorite(text:String) {
        favoriteCards.append(text)
        saveFavorites()
    }
    
    
    // 移除收藏内容,根据text
    func removeFavorite(text:String) {
        if let index = favoriteCards.firstIndex(of: text) {
            favoriteCards.remove(at: index)
            saveFavorites()
        }
    }
    
    //判断是否已经收藏，用text判断
    func isFavorite(text:String)->Bool{
        if favoriteCards.contains(text){
            return true
        }else{
            return false
        }
    }
    
    //把收藏内容转为Cardinfo数组
    func getFavoriteCards()->[CardInfo]{
        
        var result:[CardInfo] = []
        
        for cardText in favoriteCards{
            //根据text搜索cardinfo
            for card in AllCardsManager.searchCardInfoStrict(text: cardText){
                result.append(card)
            }
        }
        return result
    }
    
    //清空收藏内容
    func clear(){
        favoriteCards = []
        saveFavorites()
    }
    
    // 保存收藏内容到 UserDefaults
    private func saveFavorites() {
        UserDefaults.standard.set(favoriteCards, forKey: favoritesKey)
    }
}

//卡片排版器,输入的是getCardInfoArray()返回的数组，返回一个View
func CardPlacer(cardInfoList:[CardInfo],color: ColorScheme)->some View{
    //返回一个View
    return ScrollView{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: card.cardHSpaceMin, maximum: card.cardHSpaceMax))], spacing: card.cardVSpace) {
            
            ForEach(cardInfoList){ CookingCard in
                
                NavigationLink(destination: CookingCard.getContent) {
                    VStack(spacing: card.cardTextImageSpace){
                        
                        Text(CookingCard.image)           
                            .font(.title)
                            .frame(width: card.imageWidth, height: card.imageHeight)
                        
                        Text(CookingCard.text)
                    }
                    .frame(width: card.width, height: card.height)
                    .background(CookingCard.color)
                    .cornerRadius(card.radius)
                    .shadow(color: color == .dark ? Color.cyan.opacity(0.4) : Color.black.opacity(0.4), radius: 10, x: 10, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: card.radius)
                            .stroke(color == .dark ? Color.yellow : Color.white, lineWidth: 2)
                    )
                    .foregroundColor(.white)
                    .font(card.fontSize)
                }
                
            }
            
            
        }.padding()
    }
}
