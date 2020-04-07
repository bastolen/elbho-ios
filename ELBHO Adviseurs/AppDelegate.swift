//
//  AppDelegate.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let disposeBag = DisposeBag()
    let locManager = CLLocationManager()
    private var intervalFunction = Timer()
    private var callSend: Bool = false
    

    /**
     Send the location for the last time and stop the tracker
     */
    func stopTracking() -> Void {
        updateLocation()
        self.intervalFunction.invalidate()
        self.intervalFunction = Timer();
    }
    /**
     If there is authorization start the track timer otherwise ask for authorization
     */
    func startTracking() -> Void {
        if(CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse ){
            self.locManager.requestAlwaysAuthorization()
        } else {
            updateLocation()
            self.intervalFunction = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(AppDelegate.updateLocation), userInfo: nil, repeats: true)
        }
    }
    
    /**
     Update the location using the current location
     */
    @objc func updateLocation() {
        if(!callSend && (CLLocationManager.authorizationStatus() ==  .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse)){
            callSend = true
            guard let currentLocation = locManager.location else {
                return
            }
            APIService.updateLocation(lon: "\(currentLocation.coordinate.longitude)", lat: "\(currentLocation.coordinate.latitude)").subscribe(onNext: {
                self.callSend = false
            }, onError: { error in
                self.callSend = false
            }).disposed(by: self.disposeBag)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locManager.delegate = self
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    /**
     On changing of permission, start the tracker
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (KeychainWrapper.standard.hasValue(forKey: "trackingId") && (status == .authorizedAlways || status == .authorizedWhenInUse)) {
            self.startTracking()
        }
    }
}
