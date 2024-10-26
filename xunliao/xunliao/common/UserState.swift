//
//  UserState.swift
//  xunliao
//
//  Created by Zhuanz密码0000 on 2024/10/26.
//

import Foundation
import SwiftUI
  
class UserState: ObservableObject {
    @Published var isLogin = false
    init() {
        if getToken("token") != nil {
            isLogin = true
        }
    }
    
    func login(_ token:String) {
        storeValet(token)
        isLogin = true
    }
    
    func exitLogin() {
        deleteToken("token")
        isLogin = false
    }
}
