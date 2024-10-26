//
//  xunliaoApp.swift
//  xunliao
//
//  Created by  mac on 2024/10/21.
//

import SwiftUI

@main
struct xunliaoApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
    }
}

struct Main: View {
    //用户状态
    @EnvironmentObject var UserState : UserState
    //本地化字符串
    @EnvironmentObject var Localization: Localization
    var body: some View {
        VStack {
            if UserState.isLogin == false {
                LoginView(L: Localization,UserState: UserState)
            }else {
                ContentView()
            }
        }
    }
}

struct xunliaoApp_Previews: PreviewProvider {
    static var previews: some View {
        Main().environmentObject(UserState())
    }
}
