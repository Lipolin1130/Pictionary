//
//  Data.swift
//  Pictionary
//

import Foundation

var everydayObjects: [String] = [
    "桌子", "椅子", "筆電", "原子筆", "筆記本", "手機", "杯子", "水瓶", "湯匙", "叉子",
    "刀子", "盤子", "碗", "玻璃杯", "時鐘", "檯燈", "電風扇", "書", "包包", "鞋子",
    "襯衫", "褲子", "帽子", "手套", "襪子", "外套", "圍巾", "手錶", "錢包", "鑰匙",
    "牙刷", "牙膏", "肥皂", "毛巾", "梳子", "鏡子", "床", "枕頭", "棉被", "窗簾",
    "窗戶", "門", "電視", "遙控器", "收音機", "耳機", "喇叭", "充電器", "電線", "滑鼠",
    "鍵盤", "螢幕", "印表機", "文件夾", "紙張", "釘書機", "螢光筆", "橡皮擦", "尺", "計算機",
    "書包", "便當盒", "雨傘", "太陽眼鏡", "皮帶", "領帶", "洋裝", "裙子", "牛仔褲", "毛衣",
    "夾克", "靴子", "涼鞋", "拖鞋", "吸塵器", "掃把", "畚箕", "拖把", "水桶", "洗衣籃",
    "洗衣機", "烘衣機", "洗碗機", "烤箱", "微波爐", "瓦斯爐", "冰箱", "冷凍庫", "果汁機", "吐司機",
    "咖啡機", "熱水壺", "垃圾桶", "回收桶"
]

let maxTimeRemaing = 100 // 一局的時間

var coutdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

var customFont: String = "THEREN Trial"

enum Audio: String {
    case backgroundMusic = "BackgroundMusic"
    case correctSound = "CorrectSound"
}
