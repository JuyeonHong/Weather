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
