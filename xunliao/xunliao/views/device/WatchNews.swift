//
//  WatchNews.swift
//  xunliao
//
//  Created by  mac on 2024/10/22.
//

import SwiftUI

struct WatchNews: View {
    var body: some View {
        ScrollView{
            ForEach(newsList){ item in
                VStack(spacing:20){
                    HStack(spacing:20){
                        Image(systemName: item.icon)
                        Text(item.title).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Text(item.create_date)
                    }
                    .padding([.top,.leading,.trailing])
                    
                    Divider()
                    
                    HStack(spacing:20){
                        Image("step")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        VStack(spacing:20){
                            Text(item.content)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding([.leading,.trailing,.bottom])
                }
                .background(Color.white)
                .cornerRadius(8)
                .padding(.top)
            
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .onAppear{
            //页面显示的时候触发
            //测试发送网络请求
//            AFRequest()
//                .url("https://adm.api.sz90.cn/index.php/android/getCurrentDeviceUserinfo")
//                .requestType(.post)
//                .headers(nil)
//                .request{result in
//                    switch result{
//                        case .success(let data):
//                            print("status:\(res.status)")
//                        case .failure(let err):
//                            print("请求失败：\(err.localizedDescription)")
//                        
//                    }
//                }
        }
    }
}

struct newsOption: Identifiable{
    var id = UUID()
    var title:String
    var icon:String
    var content:String
    var create_date:String
}

let newsList = [
    newsOption(title: "设备已离线", icon: "swift", content: "报警一", create_date: "2024-10-22 10:23"),
    newsOption(title: "sos报警", icon: "swift", content: "报警2", create_date: "2024-10-22 11:33"),
    newsOption(title: "设备心率超标", icon: "swift", content: "报警3", create_date: "2024-10-22 12:29")
]

struct WatchNews_Previews: PreviewProvider {
    static var previews: some View {
        WatchNews()
    }
}
