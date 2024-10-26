//
//  BaseModel.swift
//  xunliao
//
//  Created by  mac on 2024/10/22.
//

struct BaseModel<T:Decodable>:Decodable {
    var status:Int
    var msg:String
    var data: T
}
