//
//  SwiftUIView.swift
//  xunliao
//
//  Created by Zhuanz密码0000 on 2024/10/22.
//

import SwiftUI
import CommonCrypto

extension Color {
    static func hex(_ hex: String) -> Color {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString = String(cString.dropFirst())
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
}

struct LoginView: View {
    //    国际化语言
    @ObservedObject var L : Localization
    @ObservedObject var UserState: UserState
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var showPwd: Bool = false
    @State var prickerArea:String = "亚洲"
    @State var language = "中文简体"
    @State var loginTipsShow = false
    
    @State var showingAlert = false
    
    @State var alertMessage:String? = nil
    
    let languages = ["中文简体","English"]
    
    @State var areas:[String] = []
    
    //是否登录成功
    @State var isLogin = false
    
    var body : some View {
        NavigationView {
            VStack {
                Image("step")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .padding(.init(top: 10,leading: 0,bottom: 30,trailing: 0))
                Text("\(L.local(key: "login")) & \(L.local(key: "register"))")
                    .font(.system(size: 20))
                    .padding(.bottom,15)
                VStack {
                    HStack {
                        if loginTipsShow {
                            Text(L.local(key: "email"))
                                .frame(width: 90,alignment: .leading)
                            TextField(L.local(key: "inputEmail"), text: $email)
                        }else {
                            Text(L.local(key: "phone"))
                                .frame(width: 90,alignment: .leading)
                            TextField(L.local(key: "phone"), text: $phone)
                        }
                    }
                    .padding()
                    .background(Color.hex("#ffffff"))
                    .cornerRadius(8)
                    HStack {
                        Text(L.local(key: "password"))
                            .frame(width: 90,alignment: .leading)
                        if showPwd {
                            SecureField(L.local(key: "inputPassword"), text: $password)
                        }else {
                            TextField(L.local(key: "inputPassword"), text: $password)
                        }
                        Image(systemName:showPwd ? "eye.slash":"eye")
                            .onTapGesture{
                                showPwd.toggle()
                            }
                    }
                    .padding()
                    .background(Color.hex("#ffffff"))
                    .cornerRadius(8)
                    HStack {
                        Text(L.local(key: "language"))
                        Spacer()
                        Picker(L.local(key: "language"), selection: $language) {
                            ForEach(languages, id: \.self) { item in
                                Text(item)
                            }
                        }
                        .onChange(of: language) { newValue in
                            if newValue == "中文简体" {
                                L.changeLanguage(to: "zh-Hans")
                            }else if newValue == "English" {
                                L.changeLanguage(to: "en")
                            }
                            updateUi()
                        }
                        .pickerStyle(DefaultPickerStyle())
                    }
                    .padding(.init(top: 10,leading: 20,bottom: 10,trailing: 5))
                    .background(Color.hex("#ffffff"))
                    .cornerRadius(8)
                    HStack {
                        Text(L.local(key: "area"))
                        Spacer()
                        Picker(prickerArea, selection: $prickerArea) {
                            ForEach(Array(areas.enumerated()), id: \.element) {(index,item) in
                                Text(item)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                    }
                    .padding(.init(top: 10,leading: 20,bottom: 10,trailing: 5))
                    .background(Color.hex("#ffffff"))
                    .cornerRadius(8)
                    HStack {
                        Spacer()
                        Text(loginTipsShow ? L.local(key: "phoneLogin"):L.local(key: "emailLogin"))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                loginTipsShow.toggle()
                            }
                    }
                    .padding([.top,.bottom],10)
                    HStack {
                        Button(action: {
                            let valRes = validateInput()
                            if valRes != nil {
                                alertMessage = valRes
                                showingAlert = true
                            }else {
                                submitLogin()
                            }
                        }) {
                            Spacer()
                            Text(L.local(key: "login"))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding([.top,.bottom])
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding([.leading,.trailing])
                Spacer()
                HStack {
                    Text(L.local(key: "forgotPassword"))
                        .foregroundColor(.blue)
                    Text("|")
                        .foregroundColor(Color.hex("#808080"))
                    NavigationLink(destination: RegisterView(L: L)) {
                        Text(L.local(key: "accountRegister"))
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(L.local(key: "prompt")),
                    message: Text(alertMessage ?? ""),
                    dismissButton: .default(Text(L.local(key: "confirm"))) {
                        showingAlert = false
                        alertMessage = nil
                    }
                )
            }
            .background(Color.gray.opacity(0.1))
            .onAppear {
                updateUi()
            }
        }
    }
    
    //初始化数据
    private func updateUi() {
        //默认语言
        let defaultLanguage = UserDefaults.standard.string(forKey: "AppLanguageCode") ?? "zh-Hans"
        if defaultLanguage == "en" {
            language = "English"
        } else {
            language = "中文简体"
        }
        //地区
        areas = ["\(L.local(key: "asia"))","\(L.local(key: "europe"))","\(L.local(key: "americas"))"]
        //默认地区
        prickerArea = L.local(key: "asia")
    }
    
    // 验证输入的函数
    private func validateInput() -> String? {
        if loginTipsShow == true && email == "" {
            return L.local(key: "inputEmail")
        }
        if loginTipsShow == false && phone == "" {
            return L.local(key: "inputPhone")
        }
        if password == "" {
            return L.local(key: "inputPassword")
        }
        return nil // 如果没有错误，返回 nil
    }
    
    struct Token: Decodable {
        var out_time:Int
        var token:String
    }
    
    //登录
    private func submitLogin() {
        var formData:[String: Any] = [:]
        formData["login_type"] = loginTipsShow ? 1:0
        formData["email_number"] = email
        formData["account"] = phone
        formData["password"] = passwordMd5(pwd: password)
        formData["zone_id"] = areas.firstIndex(of: prickerArea)
        AFRequest()
            .url(Config.testApi+"/login")
            .requestType(.post)
            .params(formData)
            .headers(nil)
            .request(BaseModel<Token>.self) {result in
                switch result{
                case .success(let res):
                    if res.status == 0 {
                        alertMessage = res.msg
                        showingAlert = true
                    }else {
                        //登录
                        UserState.login(res.data.token)
                    }
                case .failure(let err):
                    print("请求失败：\(err.localizedDescription)")
                }
            }
    }
    
    //密码加密
    private func passwordMd5(pwd: String) -> Substring {
        //md5加密
        let md5Pwd = CommonFun.md5(pwd)
        // 获取第二个字符的索引（Swift中字符串索引从0开始，所以这里是offsetBy: 1）
        let startIndex = md5Pwd.index(md5Pwd.startIndex, offsetBy: 2)
          
        // 计算结束索引，这里我们要截取28个字符，所以offsetBy: 28
        // 但是，我们必须使用limitedBy来确保索引不会超出字符串的边界
        let proposedEndIndex = md5Pwd.index(startIndex, offsetBy: 28, limitedBy: md5Pwd.endIndex)
          
        // 因为proposedEndIndex可能是nil（如果字符串不够长），我们需要检查它
        if let endIndex = proposedEndIndex {
            // 现在我们可以安全地截取子字符串
            let substring = md5Pwd[startIndex..<endIndex]
            return substring // 输出从第二个字符开始的28个字符的子字符串（如果字符串足够长的话）
        } else {
            // 如果字符串不够长，输出一个错误消息
            return "字符串不够长，无法从第二个字符开始截取28个字符。"
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(L:Localization(),UserState: UserState())
    }
}
