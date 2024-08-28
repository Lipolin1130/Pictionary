//
//  TransData.swift
//  Pictionary
//
//  Created by 李柏霖 on 2024/8/21.
//

import Foundation

struct TransData: Codable {
    enum DataType: String, Codable {
        case draw
        case guess
        case gameStart
        case gameOver
    }
    var type: DataType
    var payload: Data
    var sender: String
}

extension TransData {
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    static func decodePayload<T: Codable>(from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func decodedPayload<T: Codable>() throws -> T {
        return try TransData.decodePayload(from: self.payload)
    }
}

/**
 // 假設已接收到一個 TransData 的 JSON 資料並解碼成 transData
 let receivedTransData: TransData = // 這是你接收後解碼的 TransData

 switch receivedTransData.type {
 case .draw:
     let drawData: DrawData = try receivedTransData.decodedPayload()
     let drawing = PKDrawing(data: drawData.drawing)
     // 使用 drawing 更新畫面
 case .response:
     let guessData: GuessData = try receivedTransData.decodedPayload()
     if let isCorrect = guessData.isCorrect {
         // 處理正確或錯誤的回應
     } else {
         // 處理猜測單字
     }
 case .start, .gameOver:
     // 處理其他類型的事件
     break
 }
 */
