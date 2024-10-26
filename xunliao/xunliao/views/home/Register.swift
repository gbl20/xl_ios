//
//  Register.swift
//  xunliao
//
//  Created by Zhuanz密码0000 on 2024/10/24.
//

import SwiftUI

struct RegisterView: View {
    //    国际化语言
    @ObservedObject var L : Localization
    
    @State var email = ""
    @State var phone = ""
    @State var registerType = false
    @State var isChecked = false
    var body: some View {
        VStack {
            HStack {
                if registerType {
                    Text(L.local(key: "email"))
                        .frame(width: 90,alignment: .leading)
                    TextField(L.local(key: "inputEmail"), text: $email)
                }else {
                    Text(L.local(key: "phone"))
                        .frame(width: 90,alignment: .leading)
                    TextField(L.local(key: "inputPhone"), text: $phone)
                }
            }
            .padding()
            .background(Color.hex("#ffffff"))
            .cornerRadius(8)
            HStack {
                Spacer()
                Text(registerType ? L.local(key: "phoneRegister"):L.local(key: "emailRegister"))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        registerType.toggle()
                    }
            }
            .padding([.top,.bottom],10)
            HStack {
                Button(action: {
                    
                }) {
                    Spacer()
                    Text(L.local(key: "register"))
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding([.top,.bottom])
            .background(Color.blue)
            .cornerRadius(8)
            HStack {
                CustomCheckbox(isChecked: $isChecked)
                Text(L.local(key: "iAgree"))
                    .foregroundColor(Color.hex("#808080"))
                HStack {
                    Text(L.local(key: "privacyPolicy"))
                    Text(L.local(key: "and"))
                    Text(L.local(key: "userAgreement"))
                }.foregroundColor(.blue)
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .navigationTitle(L.local(key: "register"))
    }
}

//自定义复选框
struct CustomCheckbox: View {
    @Binding var isChecked:Bool
    
    var body: some View {
        
        Button(action: {
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(.blue)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding([.leading,.trailing],-5)
    }
}
//复选框按钮样式
struct PlainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.gray.opacity(0.2) : Color.clear)
            .cornerRadius(8)
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(L: Localization())
    }
}
