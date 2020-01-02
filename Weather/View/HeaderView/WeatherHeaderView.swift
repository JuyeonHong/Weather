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
                weatherLabel.text = data.main
                tempLabel.text = String(data.temp)
                dayOfWeekLabel.text = getTodayDayOfWeek()
                maxTempLabel.text = String(data.temp_max)
                minTempLabel.text = String(data.temp_min)
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
    
    private func getTodayDayOfWeek() -> String {
        var dow = ""
        
        let calender = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = calender.dateComponents([.weekday], from: now)
        dow = String(format: "%d%@", comps.weekday!, "요일")
        
        return dow
    }
}
