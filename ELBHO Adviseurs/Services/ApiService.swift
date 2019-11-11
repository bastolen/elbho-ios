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
    private static let APIBASEURL: String = "https://inhollandbackend.azurewebsites.net/api/"
    
    static func login(username: String, password: String) -> Observable<String> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request(self.APIBASEURL + "Users/Login", method: .post, parameters: [
                "UserName": username,
                "Password": password
            ]).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    let decoder = JSONDecoder()
                    
                    let apiResult = try? decoder.decode(ApiLogin.self, from: jsonData)
                    return observer.onNext(apiResult!.authToken)
                } else {
                    return self.returnError(response: response, observer: observer, loginError: true)
                }
            })
            
            return Disposables.create()
        }
    }
    
    private static func returnError<X, Y>(response: DataResponse<X>, observer: AnyObserver<Y>, loginError: Bool = false) -> Void {
        if response.response?.statusCode == 401 {
            // TODO: Implement more error types
            let error: CustomError = .api
            
            return observer.onError(error)
        } else {
            return observer.onError(CustomError.api)
        }
    }
}
