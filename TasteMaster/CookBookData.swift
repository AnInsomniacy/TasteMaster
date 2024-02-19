//
//  CookBookData.swift
//  TasteMaster
//
//  Created by Sekiro on 25/10/2023.
//

import Foundation
import SwiftUI

//常用菜谱

// 总菜单
var DishMenuList = [
    // 早餐
    CardInfo(image: "🌅", text: "早餐", color: Color(.systemPink), destination: AnyView(Breakfast())),
    // 主食
    CardInfo(image: "🍞", text: "主食", color: Color(.systemOrange), destination: AnyView(Staple())),
    // 素菜
    CardInfo(image: "🥦", text: "素菜", color: Color(.systemGreen), destination: AnyView(Vegetarian())),
    // 荤菜
    CardInfo(image: "🍖", text: "荤菜", color: Color(.systemRed), destination: AnyView(Meat())),
    // 水产
    CardInfo(image: "🐟", text: "水产", color: Color(.systemBlue), destination: AnyView(Aquatic())),
    // 汤与粥
    CardInfo(image: "🍲", text: "汤与粥", color: Color(.systemIndigo), destination: AnyView(Soup())),
    // 半成品加工
    CardInfo(image: "⏲️", text: "半成品加工", color: Color(.systemPurple), destination: AnyView(SemiDish())),
    // 酱料和其它
    CardInfo(image: "🌶️", text: "酱料和其它", color: Color(.systemPink), destination: AnyView(Condiment())),
    // 饮料
    CardInfo(image: "🥤", text: "饮料", color: Color(.systemTeal), destination: AnyView(Drink())),
    // 甜品
    CardInfo(image: "🍰", text: "甜品", color: Color(.systemPurple), destination: AnyView(Dessert())),
]




//素菜
var VegetarianList = [
    CardInfo(image: "🥔", text: "拔丝土豆", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🥬", text: "白灼菜心", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥞", text: "包菜炒鸡蛋粉丝", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🥗", text: "菠菜炒鸡蛋", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍳", text: "炒滑蛋", color: Color(.systemBlue), destination: nil), // 更改为蓝色
    CardInfo(image: "🍆", text: "炒茄子", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥬", text: "炒青菜", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍳", text: "葱煎豆腐", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍳", text: "脆皮豆腐", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍲", text: "地三鲜", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🌶️", text: "干锅花菜", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍄", text: "蚝油三鲜菇", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🥗", text: "蚝油生菜", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍉", text: "红烧冬瓜", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍆", text: "红烧茄子", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🌶️", text: "虎皮青椒", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🥗", text: "话梅煮毛豆", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍳", text: "鸡蛋羹", color: Color(.systemBlue), destination: nil), // 更改为蓝色
    CardInfo(image: "🍳", text: "微波炉鸡蛋羹", color: Color(.systemBlue), destination: nil), // 更改为蓝色
    CardInfo(image: "🍳", text: "蒸箱鸡蛋羹", color: Color(.systemBlue), destination: nil), // 更改为蓝色
    CardInfo(image: "🍆", text: "鸡蛋火腿炒黄瓜", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍆", text: "茄子炖土豆", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🥗", text: "茭白炒肉", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🌽", text: "椒盐玉米", color: Color(.systemBlue), destination: nil), // 更改为蓝色
    CardInfo(image: "🍄", text: "金针菇日本豆腐煲", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🔥", text: "烤茄子", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥬", text: "榄菜肉末四季豆", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍳", text: "雷椒皮蛋", color: Color(.systemBlue), destination: nil), // 更改为蓝色
    CardInfo(image: "🥒", text: "凉拌黄瓜", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🥗", text: "凉拌木耳", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🥗", text: "凉拌莴笋", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🥗", text: "凉拌油麦菜", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🌶️", text: "麻婆豆腐", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍆", text: "蒲烧茄子", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🥬", text: "芹菜拌茶树菇", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🌰", text: "陕北熬豆角", color: Color(.systemBrown), destination: nil),
    CardInfo(image: "🥗", text: "上汤娃娃菜", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🥬", text: "手撕包菜", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥬", text: "水油焖蔬菜", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🌰", text: "素炒豆角", color: Color(.systemBrown), destination: nil),
    CardInfo(image: "🌶️", text: "酸辣土豆丝", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍅", text: "糖拌西红柿", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥞", text: "莴笋叶煎饼", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍅", text: "西红柿炒鸡蛋", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍲", text: "西红柿豆腐汤羹", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍆", text: "西葫芦炒鸡蛋", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🥗", text: "小炒藕丁", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🧅", text: "洋葱炒鸡蛋", color: Color(.systemOrange), destination: nil)
]

// 荤菜
var MeatList = [
    CardInfo(image: "🥬", text: "白菜猪肉炖粉条", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍖", text: "带把肘子", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥕", text: "冬瓜酿肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍅", text: "番茄红酱", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍗", text: "干煸仔鸡", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🌶️", text: "宫保鸡丁", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "咕噜肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🌭", text: "荷兰豆炒腊肠", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🥩", text: "黑椒牛柳", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍖", text: "简易红烧肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "南派红烧肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🐖", text: "红烧猪蹄", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍖", text: "湖南家常红烧肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "黄瓜炒肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍗", text: "黄焖鸡", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍖", text: "徽派红烧肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥓", text: "回锅肉", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🥩", text: "尖椒炒牛肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍗", text: "姜炒鸡", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍗", text: "姜葱捞鸡", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🥩", text: "酱牛肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "酱排骨", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🐟", text: "椒盐排条", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🥩", text: "咖喱肥牛", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍗", text: "烤鸡翅", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍗", text: "可乐鸡翅", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍗", text: "口水鸡", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍖", text: "辣椒炒肉", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍖", text: "老式锅包肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🐇", text: "冷吃兔", color: Color(.systemGray), destination: nil),
    CardInfo(image: "🍖", text: "荔枝肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍗", text: "凉拌鸡丝", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍖", text: "萝卜炖羊排", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥄", text: "麻辣香锅", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥟", text: "麻婆豆腐", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍖", text: "梅菜扣肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🦆", text: "啤酒鸭", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "黔式腊肠娃娃菜", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥩", text: "青椒土豆炒肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "肉饼炖蛋", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "杀猪菜", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "山西过油肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "商芝肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "瘦肉土豆片", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥩", text: "水煮牛肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🥩", text: "水煮肉片", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "蒜苔炒肉末", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍚", text: "台式卤肉饭", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🥓", text: "糖醋里脊", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍖", text: "糖醋排骨", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🥓", text: "土豆炖排骨", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍗", text: "无骨鸡爪", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🥩", text: "西红柿牛腩", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🥩", text: "西红柿土豆炖牛肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🦆", text: "乡村啤酒鸭", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "香干芹菜炒肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "香干肉丝", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍗", text: "香菇滑鸡", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🥓", text: "香煎五花肉", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🥩", text: "小炒黄牛肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍗", text: "小炒鸡肝", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍖", text: "小炒肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "新疆大盘鸡", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🦆", text: "血浆鸭", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🥩", text: "羊排焖面", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍖", text: "洋葱炒猪肉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍗", text: "意式烤鸡", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍆", text: "鱼香茄子", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍖", text: "鱼香肉丝", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "猪皮冻", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍖", text: "猪肉烩酸菜", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥩", text: "柱候牛腩", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🥩", text: "孜然牛肉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "醉排骨", color: Color(.systemGreen), destination: nil)
]

//水产
var AquaticList = [
    CardInfo(image: "🦐", text: "白灼虾", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🐟", text: "鳊鱼炖豆腐", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🐚", text: "蛏抱蛋", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍲", text: "葱烧海参", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🐟", text: "葱油桂鱼", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🦐", text: "干煎阿根廷红虾", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🐟", text: "红烧鲤鱼", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🐟", text: "红烧鱼", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🐟", text: "红烧鱼头", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🦐", text: "黄油煎虾", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🐟", text: "烤鱼", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🦀", text: "咖喱炒蟹", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🐟", text: "鲤鱼炖白菜", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🐟", text: "清蒸鲈鱼", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🐚", text: "清蒸生蚝", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🐟", text: "水煮鱼", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🦐", text: "蒜蓉虾", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🐟", text: "糖醋鲤鱼", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🐟", text: "微波葱姜黑鳕鱼", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🐟", text: "香煎翘嘴鱼", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🦞", text: "小龙虾", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🦐", text: "油焖大虾", color: Color(.systemRed), destination: nil)
]

//早餐
var BreakfastList = [
    CardInfo(image: "🍳", text: "茶叶蛋", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍳", text: "蛋煎糍粑", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍚", text: "桂圆红枣粥", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥪", text: "鸡蛋三明治", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥟", text: "煎饺", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🥪", text: "金枪鱼酱三明治", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍞", text: "空气炸锅面包片", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍳", text: "美式炒蛋", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🥛", text: "牛奶燕麦", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🌽", text: "水煮玉米", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍳", text: "苏格兰蛋", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍳", text: "太阳蛋", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍳", text: "溏心蛋", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍞", text: "吐司果酱", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍰", text: "微波炉蛋糕", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🥞", text: "燕麦鸡蛋饼", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍥", text: "蒸花卷", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍳", text: "蒸水蛋", color: Color(.systemIndigo), destination: nil)
]

//主食
var StapleList = [
    CardInfo(image: "🍜", text: "炒方便面", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍜", text: "炒河粉", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍜", text: "炒凉粉", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍜", text: "炒馍", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍜", text: "炒年糕", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍝", text: "炒意大利面", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍚", text: "蛋炒饭", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍜", text: "豆角焖面", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍚", text: "韩式拌饭", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍜", text: "河南蒸面条", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍚", text: "火腿饭团", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍞", text: "基础牛奶面包", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥞", text: "茄子肉煎饼", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍚", text: "鲣鱼海苔玉米饭", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍜", text: "酱拌荞麦面", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍚", text: "空气炸锅照烧鸡饭", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍮", text: "醪糟小汤圆", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍜", text: "老干妈拌面", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍜", text: "老友猪肉粉", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🥞", text: "烙饼", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍜", text: "凉粉", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍜", text: "麻辣减脂荞麦面", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍝", text: "麻油拌面", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍚", text: "电饭煲蒸米饭", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍚", text: "煮锅蒸米饭", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍕", text: "披萨饼皮", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍜", text: "热干面", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍚", text: "日式咖喱饭", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍞", text: "芝麻烧饼", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🥟", text: "手工水饺", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍜", text: "酸辣蕨根粉", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍜", text: "汤面", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍚", text: "微波炉腊肠煲仔饭", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍜", text: "西红柿鸡蛋挂面", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍚", text: "扬州炒饭", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍜", text: "炸酱面", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍜", text: "蒸卤面", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🥟", text: "中式馅饼", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍜", text: "煮泡面加蛋", color: Color(.systemRed), destination: nil)
]

//半成品加工
var SemiDishList = [
    CardInfo(image: "🍝", text: "半成品意面", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍗", text: "空气炸锅鸡翅中", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍖", text: "空气炸锅羊排", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥧", text: "懒人蛋挞", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍜", text: "凉皮", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍲", text: "牛油火锅底料", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🥟", text: "速冻馄饨", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🥟", text: "速冻水饺", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍡", text: "速冻汤圆", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍟", text: "炸薯条", color: Color(.systemYellow), destination: nil)
]

//汤与粥
var SoupList = [
    CardInfo(image: "🍲", text: "昂刺鱼豆腐汤", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍅", text: "番茄牛肉蛋花汤", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍄", text: "勾芡香菇汤", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥣", text: "金针菇汤", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🦆", text: "菌菇炖乳鸽", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🇫🇷", text: "罗宋汤", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🥣", text: "米粥", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🥩", text: "排骨苦瓜汤", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🥣", text: "皮蛋瘦肉粥", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍲", text: "生汆丸子汤", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍅", text: "西红柿鸡蛋汤", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🥣", text: "小米粥", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍄", text: "银耳莲子粥", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🌽", text: "玉米排骨汤", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🥣", text: "紫菜蛋花汤", color: Color(.systemPurple), destination: nil)
]

//饮料
var DrinkList = [
    CardInfo(image: "🥤", text: "耙耙柑茶", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍊", text: "百香果橙子特调", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍧", text: "冰粉", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🥂", text: "金菲士", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍸", text: "金汤力", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🥤", text: "可乐桶", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍵", text: "奶茶", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍹", text: "奇异果菠菜特调", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍹", text: "酸梅汤", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🥤", text: "酸梅汤（半成品加工）", color: Color(.systemYellow), destination: nil),
    CardInfo(image: "🍵", text: "泰国手标红茶", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🥂", text: "杨枝甘露", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍸", text: "长岛冰茶", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🍸", text: "B52轰炸机", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍸", text: "Mojito莫吉托", color: Color(.systemPurple), destination: nil)
]

//酱料和其它材料
var  CondimentList = [
    CardInfo(image: "🍓", text: "草莓酱", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🧄", text: "蒜香酱油", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍯", text: "糖醋汁", color: Color(.systemRed), destination: nil),
    CardInfo(image: "🍬", text: "糖色", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🌶️", text: "油泼辣子", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🍯", text: "油酥", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍢", text: "炸串酱料", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍯", text: "蔗糖糖浆", color: Color(.systemPink), destination: nil)
]

//甜品
var DessertList = [
    CardInfo(image: "🍨", text: "奥利奥冰淇淋", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍓", text: "草莓冰淇淋", color: Color(.systemOrange), destination: nil),
    CardInfo(image: "🍠", text: "反沙芋头", color: Color(.systemRed), destination: nil),
    CardInfo(image: "☕️", text: "咖啡椰奶冻", color: Color(.systemGreen), destination: nil),
    CardInfo(image: "🥮", text: "烤蛋挞", color: Color(.systemBlue), destination: nil),
    CardInfo(image: "🎂", text: "魔芋蛋糕", color: Color(.systemPurple), destination: nil),
    CardInfo(image: "🍰", text: "戚风蛋糕", color: Color(.systemTeal), destination: nil),
    CardInfo(image: "🍮", text: "提拉米苏", color: Color(.systemPink), destination: nil),
    CardInfo(image: "🍪", text: "雪花酥", color: Color(.systemIndigo), destination: nil),
    CardInfo(image: "🍠", text: "芋泥雪媚娘", color: Color(.systemYellow), destination: nil)
]


//菜谱控制器
var DishMenuCardsManager = CardManager(cardInfoList: DishMenuList)
var VegetarianCardsManager = CardManager(cardInfoList: VegetarianList)
var MeatCardsManager = CardManager(cardInfoList: MeatList)
var AquaticManager = CardManager(cardInfoList: AquaticList)
var BreakfastManager = CardManager(cardInfoList: BreakfastList)
var StapleManager = CardManager(cardInfoList: StapleList)
var SemiDishManager = CardManager(cardInfoList: SemiDishList)
var SoupManager = CardManager(cardInfoList: SoupList)
var DrinkManager = CardManager(cardInfoList: DrinkList)
var CondimentManager = CardManager(cardInfoList: CondimentList)
var DessertManager = CardManager(cardInfoList: DessertList)
