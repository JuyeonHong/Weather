//
//  ViewController.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/10.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout()
        
        let weatherManager = WeatherManager()
        weatherManager.getWeather(where: "Tampa")
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
            return header
        default:
            fatalError("Unexpected Element Kind")
        }
    }
}
