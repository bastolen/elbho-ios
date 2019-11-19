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
    private static let APIBASEURL: String = "elbho-function.azurewebsites.net/api"
    
    static func login(username: String, password: String) -> Observable<String> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request(self.APIBASEURL + "/advisor/login", method: .post, parameters: [
                "email": username,
                "password": password
            ]).validate().responseJSON(completionHandler: {response in
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
        }
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
