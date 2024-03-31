//
//  CardData.swift
//  TasteMaster
//
//  Created by Sekiro on 13/10/2023.
//

import Foundation
import SwiftUI

// 更新BasicSkills卡片数据，使颜色和图标更加符合功能主题
var BasicSkillsCardList = [
    CardInfo(image: "🔥", text: "学习煎炒", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥗", text: "学习凉拌", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "💧", text: "学习去腥", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🌊", text: "学习焯水", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍲", text: "学习蒸", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "⏲️", text: "学习腌", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🥘", text: "学习煮", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍳", text: "常用器材", color: Color(.systemGreen), destination: AnyView(CommonEquipments())),
    CardInfo(image: "💹", text: "食材规划", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "📝", text: "厨房准备", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "✨", text: "辅料技巧", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "📚", text: "专业术语", color: Color(.systemBrown), destination: nil),
    CardInfo(image: "🌡️", text: "油温判断", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🔰", text: "食品安全", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "⏳", text: "延寿指南", color: Color(.systemPink), destination: nil),
]

// 更新ExtraFunctions卡片数据，美化图标，使其更加直观和具有吸引力
var ExtraFunctionsCardList = [
    CardInfo(image: "⭐", text: "我的收藏", color: Color(.systemPink), destination: AnyView(MyFavorite())),
    CardInfo(image: "🔍", text: "全局搜索", color: Color(.systemIndigo), destination: AnyView(GlobalSearch())),
    CardInfo(image: "👩‍🍳", text: "AI 问答", color: Color(.systemRed), destination: AnyView(AIAnalyst())),
    CardInfo(image: "🧐", text: "物品识别", color: Color(.systemGreen), destination: AnyView(ItemRecognizationUI())),
    CardInfo(image: "✨", text: "作出贡献", color: Color(.systemPurple), destination: AnyView(ContributeCards())),
    CardInfo(image: "🤵", text: "关于作者", color: Color(.systemBlue), destination: AnyView(AboutMe())),
]

//常用器材
var CommonEquipmentsCardList = [
    CardInfo(image: "🔥", text: "高压力锅", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🌊", text: "微波炉", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍞", text: "烤箱", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🌡️", text: "温度计", color: Color(.systemPink), destination: nil),
    CardInfo(image: "⏲️", text: "计时器", color: Color(.systemOrange), destination: nil),
]

//作出贡献
var ContributeCardList = [
    CardInfo(image: "📖", text: "菜谱模版", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "👨‍🏭", text: "审核要求", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "⚖️", text: "行为准则", color: Color(.systemRed), destination: nil),
]

// 物品识别
var ItemRecognizationCardList = [
    CardInfo(image: "🔍", text: "通用物品识别", color: Color(.systemIndigo), destination: AnyView(advanced_general())),
    CardInfo(image: "🍲", text: "菜品识别", color: Color(.systemOrange), destination: AnyView(dish_recognization())),
    CardInfo(image: "🐾", text: "动物识别", color: Color(.systemTeal), destination: AnyView(animal_recognization())),
    CardInfo(image: "🌿", text: "植物识别", color: Color(.systemGreen), destination: AnyView(plant_recognization())),
    CardInfo(image: "🥕", text: "食材识别", color: Color(.systemPink), destination: AnyView(ingredient_recognization())),
]



//总卡片数据
var AllCardList = BasicSkillsCardList + ExtraFunctionsCardList + CommonEquipmentsCardList + VegetarianList + MeatList + AquaticList + BreakfastList + StapleList + SemiDishList + SoupList + DrinkList + CondimentList + DessertList + ContributeCardList + ItemRecognizationCardList

// 卡片大小信息
var card = CardModel(width: 160, height: 110, radius: 30, fontSize: .system(size: 20), imageWidth: 30, imageHeight: 30, cardHSpaceMin: 160, cardHSpaceMax: 170, cardVSpace: 16, cardTextImageSpace: 14)

// 三个选项界面的卡片信息
var BasicSkillsCardsManager = CardManager(cardInfoList: BasicSkillsCardList)
var ExtraFunctionsCardsManager = CardManager(cardInfoList: ExtraFunctionsCardList)
var CommonEquipmentsCardsManager = CardManager(cardInfoList: CommonEquipmentsCardList)
var ContributeCardsManager = CardManager(cardInfoList: ContributeCardList)
var ItemRecognizationCardsManager = CardManager(cardInfoList: ItemRecognizationCardList)

//总卡片信息
var AllCardsManager = CardManager(cardInfoList: AllCardList)

// 创建一个数组，专门存放单个的CardInfo,指示用户收藏的CardInfo,这部分数组要求持久化存储
var FavoriteCardsInfoManager = FavoriteCardsManager()
