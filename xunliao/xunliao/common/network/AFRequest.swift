//
//  AFRequest.swift
//  xunliao
//
//  Created by  mac on 2024/10/22.
//
import Foundation
import Alamofire
import UIKit

class AFRequest{
    
    typealias SuccessHandlerType = ((NSDictionary)->Void)
    typealias FailureHandlerType = ((Any?,String)->Void)
    
    private var requestType: HTTPMethod = .post //请求类型
    private var url: String? //请求地址
    private var params: [String: Any] = [:] //请求参数
    private var headers: HTTPHeaders? //请求头
    private var success: SuccessHandlerType? //请求成功回调
    private var failure: FailureHandlerType? //请求失败回调
}

//扩展AFRequest
extension AFRequest {
    func url(_ url:String?) -> Self {
        self.url = url ?? ""
        return self
    }
    
    func requestType(_ type:HTTPMethod) -> Self {
        self.requestType = type
        return self
    }
    
    func params(_ params:[String: Any]) -> Self {
        self.params = params
        return self
    }
    
    func headers(_ headers: HTTPHeaders?) -> Self {
        self.headers = headers
        return self
    }
    
    func success(_ handler: @escaping SuccessHandlerType) -> Self {
        self.success = handler
        return self
    }
    
    func failure(handler: @escaping FailureHandlerType) -> Self {
        self.failure = handler
        return self
    }
    
}

//扩展请求方法
extension AFRequest{
    func request<T: Decodable>(_ of: T.Type,completion: @escaping(Result<T,Error>)->Void) {
        guard let URLString  = url else {
            //请求地址不为空
            print("请求地址不能为空")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey:"请求地址不能为空"])))
            return
        }
        
        var requestHasders = headers ?? HTTPHeaders()
        if requestHasders.count == 0 {
            let languageCode = UserDefaults.standard.string(forKey: "AppLanguageCode") == "en" ? "1":"0"
            //请求头为空则重新设置
            requestHasders.add(name: "Content-Type", value: "application/json;charset=utf-8")
            requestHasders.add(name: "language", value: languageCode)
            requestHasders.add(name: "token", value: "")
        }
        //固定参数
        params["store_id"] = Config.storeId
        //发起网络请求
        AF.sessionConfiguration.timeoutIntervalForRequest = 60
        AF.request(
             URLString,
             method: requestType,
             parameters: params,
             encoding: JSONEncoding.default,
             headers: requestHasders,
             interceptor: nil,
             requestModifier: nil
        )
        .validate()
        .responseDecodable(of: T.self){ response in
            //处理返回数据
            switch response.result {
                case .success(let res):
                    completion(.success(res))
                case .failure(let errot):
                    completion(.failure(errot))
            }
        }
        
    }
    
    //登录弹窗 - 弹出是否需要登录的窗口
    func alertLogin(_ title: String) {
        print(title)
    }
}
