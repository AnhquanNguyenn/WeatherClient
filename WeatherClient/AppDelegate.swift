//
//  AppDelegate.swift
//  WeatherClient
//
//  Created by Anhquan Nguyen on 8/10/19.
//  Copyright © 2019 Anhquan Nguyen. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationService = LocationService()
    let forecastProvider = MoyaProvider<ForecastProvider>()
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "DARKSKY_API_KEY") as! String


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        // Location service callback
        locationService.newestLocation = { [weak self] coordinate in
            guard let self = self, let coordinate = coordinate else { return }
            print("Location is: \(coordinate)")
            self.getForecast(for: coordinate)
        }
        
        // we dont want to have location service to have a strong reference to self -> weak self
        locationService.statusUpdated = { [weak self] status in
            if status == .authorizedWhenInUse {
                self?.locationService.getLocation()
            }
        }
        
        switch locationService.status {
        case .notDetermined:
            locationService.getPermission()
        case .authorizedWhenInUse:
            locationService.getLocation()
        default: assertionFailure("Location is: \(locationService.status)")
        }
        
        return true
    }
    
    func getForecast(for coordinates: CLLocationCoordinate2D) {
        // Forecast request
        forecastProvider.request(.forecast(AppDelegate.apiKey, coordinates.latitude, coordinates.longitude)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let forecast = try Forecast(data: response.data)
                    
                    // If fails just output an empty array. We are pulling out our view models from our weather API
                    let viewModels = forecast.daily.data.compactMap(DailyForecastViewModel.init)
                    
                    // Look into the rootviewcontroller and cast it to a navigation view controller
                    let forecastViewController = AppDelegate.viewControllerInNav(ofType: ForecastTableViewController.self, in: self.window)
                    forecastViewController?.viewModels = viewModels
                } catch {
                    print("Failed to get forecast: \(error)")
                }
                //print("Forecast: \n\n", forecast)
            case .failure(let error):
                print("Network request failed: \(error)")
                
            }
        }
    }
    
    static func viewControllerInNav<T>(ofType: T.Type, in window: UIWindow?) -> T? {
        return window?.rootViewController
            .flatMap { $0 as? UINavigationController }?
            .viewControllers
            .first(where: { $0 is T}) as? T
    }
}

