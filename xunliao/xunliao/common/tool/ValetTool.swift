//
//  ValetTool.swift
//  xunliao
//
//  Created by  mac on 2024/10/23.
//

import Valet
let identfier = Identifier(nonEmpty: "xunliao")!
//设备解锁时
let valet = Valet.valet(with: identfier, accessibility: .whenUnlocked)

//存储token
func storeValet(_ token: String) {
    do{
        try valet.setString(token, forKey: "token")
        print("保存token成功")
    } catch {
        print("Failed to store token: \(error.localizedDescription)")
    }
}

//获取token
func getToken(_ key: String) -> String? {
    do {
        return try valet.string(forKey: key)
    }catch {
        print("\(error.localizedDescription)")
        return nil
    }
}

//删除token
func deleteToken(_ key:String){
    do {
        try valet.removeObject(forKey: key)
    } catch {
        print("删除失败")
    }
}

