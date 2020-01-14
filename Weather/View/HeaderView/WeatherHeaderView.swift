//
//  WeatherHeaderView.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/11.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class WeatherHeaderView: UICollectionReusableView {
    @IBOutlet weak var districtLabel: UILabel! // 이름
    @IBOutlet weak var weatherLabel: UILabel! // 날씨
    @IBOutlet weak var tempLabel: UILabel! // 온도
    
    @IBOutlet weak var dayOfWeekLabel: UILabel! // 요일
    @IBOutlet weak var dayLabel: UILabel! // 오늘
    @IBOutlet weak var maxTempLabel: UILabel! // 최고온도
    @IBOutlet weak var minTempLabel: UILabel! // 최저온도
    
    var weather: Weather? {
        didSet {
            if let data = weather {
                districtLabel.text = data.name
                weatherLabel.text = data.description
                dayLabel.text = "TODAY"
                tempLabel.text = WeatherManager.convertTemp(temp: data.temp, from: .kelvin, to: .celsius)
                dayOfWeekLabel.text = WeatherManager.getDayOfWeek(date: Date())
                maxTempLabel.text = WeatherManager.convertTemp(temp: data.temp_max, from: .kelvin, to: .celsius)
                minTempLabel.text = WeatherManager.convertTemp(temp: data.temp_min, from: .kelvin, to: .celsius)
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let weatherLayoutAttributes = layoutAttributes as? WeatherLayoutAttributes else {
            return
        }
        
        tempLabel.alpha = weatherLayoutAttributes.headerAlpha
        dayOfWeekLabel.alpha = weatherLayoutAttributes.headerAlpha
        dayLabel.alpha = weatherLayoutAttributes.headerAlpha
        maxTempLabel.alpha = weatherLayoutAttributes.headerAlpha
        minTempLabel.alpha = weatherLayoutAttributes.headerAlpha
    }
}
