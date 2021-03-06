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
        indicator.layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        indicator.layer.backgroundColor = UIColor(named: "backgroundColor")?.cgColor
        
        indicator.hidesWhenStopped = false
        indicator.style = .large
        indicator.startAnimating()
        return indicator
    }()
    
    var locationManager: CLLocationManager?
    let queryService = QueryService()
    var weather: Weather? // 현재 날씨
    var forecastArray: [Forecast]? = nil // 전체 날씨
    var weeklyForecastArray: [WeeklyForecast]? = nil // 주간 날씨
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        layout.headerSize = CGSize(width: width, height: 270)
        layout.cellTodayWeatherSize = CGSize(width: width, height: 100)
        layout.cellWeeklyWeatherSize = CGSize(width: width, height: 210)
        layout.cellSummaryWeatherSize = CGSize(width: width, height: 70)
        layout.cellDetailTodayWeatherSize = CGSize(width: width, height: 235)
    }
    
    private func requestLocationAuthorization() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
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
        
        let coor = locationManager?.location?.coordinate // 현재 위치 위도, 경도 가져오기
        if let latitude = coor?.latitude, let longitude = coor?.longitude {
            queryService.getSearchResults(latitude: latitude, longitude: longitude, searchData: .weather) { data in
                print("today weather data called \n \(data)")
                self.weather = Weather(dict: data)
                
                self.queryService.getSearchResults(latitude: latitude, longitude: longitude, searchData: .forecast) { data in
                    DispatchQueue.main.async {
                        print("total weather data called \n \(data)")
                        self.forecastArray = ForecastManager.loadForecastArray(dict: data)
                        self.weeklyForecastArray = WeeklyForecastManager.loadWeelyForecastArray(dict: data)
                        
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
            let array = get2DaysForecast()
            cell.forecastArray = array
            cell.collectionView.reloadData()
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyWeatherCell", for: indexPath) as! WeeklyWeatherCell
            let array = avg5DaysForecast()
            cell.forecastArray = array
            cell.collectionView.reloadData()
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCell", for: indexPath) as! SummaryTodayWeatherCell
            cell.weather = self.weather
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailTodayWeatherCell
            cell.weather = self.weather
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

extension ViewController {
    private func avg5DaysForecast() -> [WeeklyForecast] {
        var totAvgArray: [WeeklyForecast] = []
        
        if let arr = forecastArray {
            let days = arr.compactMap { $0.date }
            let dayArray = days.removeDuplicates()
            
            for day in dayArray {
                let result = arr.filter { $0.date == day }
                
                // tempMax 평균
                let tempMaxArray = result.compactMap { $0.temp_max }
                let sumTempMax = tempMaxArray.reduce(0) { acc, element in
                    return acc + Int(element)
                }
                let avgTempMax = sumTempMax / result.count
                
                // tempMin 평균
                let tempMinArray = result.compactMap { $0.temp_min }
                let sumTempMin = tempMinArray.reduce(0) { acc, element in
                    return acc + Int(element)
                }
                let avgTempMin = sumTempMin / result.count
                
                // 날씨
                var weatherIndex = 0
                let timeArray = result.compactMap {
                    (($0.time).components(separatedBy: ":")).first
                }
                let currentTime = (WeatherManager.getCurrentTime().components(separatedBy: ":")).first ?? ""
                let timeSubArray = timeArray.compactMap { abs((Int($0) ?? 0) - (Int(currentTime) ?? 0)) }
                for i in 0..<timeSubArray.count {
                    let item = timeSubArray[i]
                    if item == timeSubArray.min() {
                        weatherIndex = i
                    }
                }
                
                let weatherArray = result.compactMap { $0.weatherId }
                let weatherId = weatherArray[weatherIndex]
                
                let weeklyForecast = WeeklyForecast(date: day,
                                                    weatherId: weatherId,
                                                    temp_max: Double(avgTempMax),
                                                    temp_min: Double(avgTempMin))
                totAvgArray.append(weeklyForecast)
            }
        }
        
        return totAvgArray
    }
    
    private func getTodayForecast() -> [Forecast] {
        var todayArr: [Forecast] = []
        if let arr = forecastArray {
            let todayDate = WeatherManager.getTodayDate(dateFormat: "yyyy-MM-dd")
            todayArr = arr.filter { $0.date == todayDate }
        }
        return todayArr
    }
    
    // today ~ tomorrow
    private func get2DaysForecast() -> [Forecast] {
        var twoDaysArr: [Forecast] = []
        if let arr = forecastArray {
            for i in 0..<12 {
                let data = arr[i]
                twoDaysArr.append(data)
            }
        }
        return twoDaysArr
    }
}
