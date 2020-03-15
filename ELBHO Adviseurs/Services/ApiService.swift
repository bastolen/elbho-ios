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
    private static let APIBASEURL: String = "https://bt-elbho-api.herokuapp.com"
    
    static func login(email: String, password: String) -> Observable<Bool> {
        return Observable<String>.create { (observer) -> Disposable in
            Alamofire.request(self.APIBASEURL + "/login", method: .post, parameters: [
                "email": email,
                "password": password
            ], encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    let decoder = JSONDecoder()
                    
                    let apiResult = try? decoder.decode(ApiLogin.self, from: jsonData)
                    return observer.onNext(apiResult!.token)
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
            Alamofire.request(self.APIBASEURL + "/auth/advisor/me", method: .get, headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
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
    
    static func getAppointmentRequests() -> Observable<[Appointment?]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/request/me", method: .get, headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                    let apiResult = try? decoder.decode([Appointment?].self, from: jsonData)
                    return observer.onNext(apiResult!)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func getAppointments(parameters: Parameters = [:]) -> Observable<[Appointment?]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/appointment/me", method: .get, parameters: parameters,  encoding: URLEncoding.queryString,headers: self.getAuthHeader() ).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                    let apiResult = try? decoder.decode([Appointment?].self, from: jsonData)
                    return observer.onNext(apiResult!)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func respondToRequest(requestId: String, accept: Bool) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/request/\(requestId)", method: .put, parameters: [
                "accept": accept
            ], encoding: JSONEncoding.default, headers: self.getAuthHeader() ).validate().responseString(completionHandler: {response in
                if (response.result.isSuccess) {
                    return observer.onNext(Void())
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func getInvoices() -> Observable<[Invoice?]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/invoice/me", method: .get, headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                    let apiResult = try? decoder.decode([Invoice?].self, from: jsonData)
                    return observer.onNext(apiResult!)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func getCarReservation(after: Date) -> Observable<[CarReservation?]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/reservation/me", method: .get, parameters: [
                "after" : after
            ], headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        return observer.onError(CustomError.api)
                    }

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                    let apiResult = try? decoder.decode([CarReservation?].self, from: jsonData)
                    return observer.onNext(apiResult!)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func getCarsAvailability(date: String) -> Observable<[CarAvailability?]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/reservation", method: .get, parameters: [
                "date" : date
            ], headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        return observer.onError(CustomError.api)
                    }

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                    let apiResult = try? decoder.decode([CarAvailability?].self, from: jsonData)
                    return observer.onNext(apiResult!)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func postCarReservation(vehicle : String, date : String, start: String, end: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/reservation", method: .post, parameters: [
                "vehicle": vehicle,
                "date" : date,
                "start" : start,
                "end" : end
            ], encoding: JSONEncoding.default, headers: self.getAuthHeader()).validate().responseString(completionHandler: {response in
                if (response.result.isSuccess) {
                    return observer.onNext(Void())
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func deleteCarReservation(_id : String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/reservation/"+_id, method: .delete, parameters: [:], encoding: JSONEncoding.default, headers: self.getAuthHeader()).validate().responseString(completionHandler: {response in
                if (response.result.isSuccess) {
                    return observer.onNext(Void())
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func getAvailability(after: String, before: String) -> Observable<[Availability?]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/availability/me", method: .get, parameters: [
                "before": before,
                "after" : after
            ], headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    guard let jsonData = response.data else {
                        
                        return observer.onError(CustomError.api)
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                    let apiResult = try? decoder.decode([Availability?].self, from: jsonData)
                    return observer.onNext(apiResult!)
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func postAvailability(availabilities : [Availability2]) -> Observable<Void> {
        var data: [String] = []
        let jsonEncoder = JSONEncoder()
        availabilities.forEach({ availability in
            data.append(String(data: try! jsonEncoder.encode(availability), encoding: String.Encoding.utf8)!)
        })
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/availability", method: .post, parameters: [
                "availabilities": data
            ], encoding: JSONEncoding.default, headers: self.getAuthHeader()).validate().responseString(completionHandler: {response in
                if (response.result.isSuccess) {
                    return observer.onNext(Void())
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    static func updateLocation(lon: String, lat: String) -> Observable<Void> {
        return Observable<Void>.create { (observer) -> Disposable in
            Alamofire.request(self.APIBASEURL + "/auth/location", method: .put, parameters: [
                "lon": lon,
                "lat": lat
            ], encoding: JSONEncoding.default, headers: self.getAuthHeader()).validate().responseJSON(completionHandler: {response in
                if (response.result.isSuccess) {
                    return observer.onNext(Void())
                } else {
                    return self.returnError(response: response, observer: observer)
                }
            })
            
            return Disposables.create()
        }
    }
    
    // TODO: Function doesn't work when the file is in the cloud...
    static func createInvoice(fileURL: URL, date: Date) -> Observable<Invoice> {
        return Observable<Invoice>.create { observer -> Disposable in
            let formatter = DateFormatter.apiDateResult
            var fileData: Data
            do {
                fileURL.startAccessingSecurityScopedResource()
                fileData = try Data(contentsOf: fileURL)
                fileURL.stopAccessingSecurityScopedResource()
                Alamofire.upload(multipartFormData: { multipart in
                    multipart.append(fileData, withName: "file", fileName: fileURL.lastPathComponent, mimeType: fileURL.mimeType())
                    multipart.append((formatter.string(from: date).data(using: .utf8))!, withName: "date")
                }, to: self.APIBASEURL + "/auth/invoice", method: .post, headers: self.getAuthHeader()) { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            guard let jsonData = response.data else {
                                return observer.onError(CustomError.api)
                            }
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.apiDateResult)
                            let apiResult = try? decoder.decode(Invoice.self, from: jsonData)
                            return observer.onNext(apiResult!)
                        }
                    case .failure(let error):
                        print("Error in upload: \(error.localizedDescription)")
                        return observer.onError(CustomError.api)
                    }
                }
            } catch {
                observer.onError(CustomError.fileInvalid)
            }
            
            return Disposables.create()
        }
    }
    
    private static func getAuthHeader() -> [String:String] {
        guard let authToken =  KeychainWrapper.standard.string(forKey: "authToken") else {
            return [:]
        }
        return ["Authorization": "Bearer \(authToken)"]
    }
    
    private static func returnError<X, Y>(response: DataResponse<X>, observer: AnyObserver<Y>) -> Void {
        var error: CustomError
        switch response.response?.statusCode {
        case 400:
            error = .bodyInvalid
        case 401:
            error = .api
        case 403:
            error = .unauthorized
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
