//
//  api.service.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//
import Alamofire
import RxSwift
import SwiftKeychainWrapper

final class APIService {
    private static let APIBASEURL: String = "https://elbho-function.azurewebsites.net/api"
    
    static func login(email: String, password: String) -> Observable<Bool> {
        return Observable<String>.create { (observer) -> Disposable in
            Alamofire.request(self.APIBASEURL + "/advisor/login", method: .post, parameters: [
                "email": email,
                "password": password
            ], encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    let decoder = JSONDecoder()
                    
                    let apiResult = try? decoder.decode(ApiLogin.self, from: jsonData)
                    return observer.onNext(apiResult!.jwt)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }.map{token in
            return KeychainWrapper.standard.set(token, forKey: "authToken")
        }
    }
    
    static func getLoggedInAdvisor() -> Observable<Advisor> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/advisors/me", method: .get, headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                    
                    let apiResult = try? decoder.decode(Advisor.self, from: jsonData)
                    return observer.onNext(apiResult!)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    private static func getAuthHeader() -> [String:String] {
        guard let authToken =  KeychainWrapper.standard.string(forKey: "authToken") else {
            return [:]
        }
        return ["x-jwt": authToken]
    }
    
    private static func returnError<X, Y>(response: DataResponse<X>, observer: AnyObserver<Y>) -> Void {
        var error: CustomError
        switch response.response?.statusCode {
        case 400:
            error = .passwordMatch
        case 401:
            error = .api
        case 409:
            error = .conflict
        case 500:
            error = .api
        
        default:
            error = .api
        }
        return observer.onError(error)
    }
}
