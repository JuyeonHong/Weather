//
//  ViewController.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/10.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = self.view.center
        
        indicator.hidesWhenStopped = false
        indicator.style = .large
        indicator.startAnimating()
        return indicator
    }()
    
    var locationManager: CLLocationManager?
    let weatherManager = WeatherManager()
    var weather: Weather? // 현재 날씨
    var forecastArray: [Forecast]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(indicatorView)
        
        setupCollectionViewLayout()
        // 위치권한요청
        requestLocationAuthorization()
    }
    
    private func setupCollectionViewLayout() {
        guard
            let collectionView = collectionView,
            let layout = collectionView.collectionViewLayout as? WeatherLayout else {
                return
        }
        
        collectionView.register(UINib(nibName: "WeatherHeaderView", bundle: nil),
                                forSupplementaryViewOfKind: WeatherLayout.Element.WeatherHeaderView.kind,
                                withReuseIdentifier: WeatherLayout.Element.WeatherHeaderView.id)
        
        let width = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width, height: 100)
        layout.headerSize = CGSize(width: width, height: 300)
        layout.cellTodayWeatherSize = CGSize(width: width, height: 125)
        layout.cellWeeklyWeatherSize = CGSize(width: width, height: 330)
        layout.cellSummaryWeatherSize = CGSize(width: width, height: 90)
        layout.cellDetailTodayWeatherSize = CGSize(width: width, height: 300)
    }
    
    private func requestLocationAuthorization() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            // 위치 허용상태
            print("위치 허용상태")
        } else {
            let message = "현재 날씨를 알기 위해 위치 정보에 접근할 수 있도록 허용되어 있어야 합니다."
            let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func getCurrentLocation() {
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        
        // 현재 위치 위도, 경도 가져오기
        let coor = locationManager?.location?.coordinate
        if let latitude = coor?.latitude, let longitude = coor?.longitude {
            weatherManager.getWeatherData(data: .weather, latitude: latitude, longitude: longitude) { data in
                print(data)
                self.weather = Weather(dict: data)
                
                self.weatherManager.getWeatherData(data: .forecast, latitude: latitude, longitude: longitude) { data in
                    DispatchQueue.main.async {
                        print(data)
                        self.forecastArray = ForecastManager.loadForecastArray(dict: data)
                        
                        self.collectionView.reloadData()
                        self.indicatorView.stopAnimating()
                        self.indicatorView.isHidden = true
                    }
                }
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    // method triggered when new location change
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("did get latest location")
//
//        guard let latestLocation = locations.first else {return}
//
//        if currentCoordinate == nil {
//            zoomToLatestLocation(with: latestLocation.coordinate)
//        }
//
//        currentCoordinate = latestLocation.coordinate
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            getCurrentLocation()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayWeatherCell", for: indexPath) as! TodayWeatherCell
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyWeatherCell", for: indexPath) as! WeeklyWeatherCell
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCell", for: indexPath) as! SummaryTodayWeatherCell
            cell.weather = weather
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailTodayWeatherCell
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case WeatherLayout.Element.WeatherHeaderView.kind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherLayout.Element.WeatherHeaderView.id, for: indexPath) as! WeatherHeaderView
            header.weather = self.weather
            return header
        default:
            fatalError("Unexpected Element Kind")
        }
    }
}
