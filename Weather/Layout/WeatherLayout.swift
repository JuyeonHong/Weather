//
//  WeatherLayout.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/11.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class WeatherLayout: UICollectionViewFlowLayout {
    enum Element: String {
        case WeatherHeaderView
        case TodayWeatherCell
        case WeeklyWeatherCell
        case SummaryTodayWeatherCell
        case DetailTodayWeatherCell
        
        var id: String {
            return self.rawValue
        }
        
        var kind: String {
            return "Kind\(self.rawValue.capitalized)"
        }
    }
    
    private var collectionViewWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let inset = collectionView.contentInset
        return collectionView.frame.width - (inset.left + inset.right)
    }
    
    private var collectionViewHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.frame.height
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }
    
    private var cache = [Element: [IndexPath: UICollectionViewLayoutAttributes]]()
    private var visibleAttributes = [UICollectionViewLayoutAttributes]()
    private var contentHeight = CGFloat()
    
    private var cellWidth: CGFloat {
        return itemSize.width
    }
    
    private var cellHeight: CGFloat {
        return itemSize.height
    }
    
    var headerSize: CGSize = .zero
    var cellTodayWeatherHeight: CGSize = .zero
    var cellWeeklyWeatherHeight: CGSize = .zero
    var cellSummaryWeatherHeight: CGSize = .zero
    var cellDetailTodayWeatheHeight: CGSize = .zero
    
    private var contentOffset: CGPoint {
        guard let collectionView = collectionView else {
            return CGPoint.zero
        }
        return collectionView.contentOffset
    }
}

// MARK: - LAYOUT CORE PROCESS
extension WeatherLayout {
    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else { return }
        prepareCache()
        contentHeight = 0
        
        let itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: Element.WeatherHeaderView.kind, with: IndexPath(item: 0, section: 0))
        prepareElement(size: headerSize, type: .WeatherHeaderView, attributes: headerAttributes)
        
        let todayWeatherAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        prepareElement(size: cellTodayWeatherHeight, type: .TodayWeatherCell, attributes: todayWeatherAttributes)
        
        let weeklyWeatherAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 1))
        prepareElement(size: cellWeeklyWeatherHeight, type: .WeeklyWeatherCell, attributes: weeklyWeatherAttributes)
        
        let summaryAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 2))
        prepareElement(size: cellSummaryWeatherHeight, type: .SummaryTodayWeatherCell, attributes: summaryAttributes)
        
        let detailAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 3))
        prepareElement(size: cellDetailTodayWeatheHeight, type: .DetailTodayWeatherCell, attributes: detailAttributes)
    }
    
    func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.WeatherHeaderView] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.TodayWeatherCell] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.WeeklyWeatherCell] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.SummaryTodayWeatherCell] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.DetailTodayWeatherCell] = [IndexPath: UICollectionViewLayoutAttributes]()
    }
    
    func prepareElement(size: CGSize, type: Element, attributes: UICollectionViewLayoutAttributes) {
        guard size != .zero else { return }
        
        attributes.frame = CGRect(origin: CGPoint(x: 0, y: contentHeight), size: size)
        
        contentHeight  = attributes.frame.maxY
        
        cache[type]?[attributes.indexPath] = attributes
    }
}

extension WeatherLayout {
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case Element.WeatherHeaderView.kind:
            return cache[.WeatherHeaderView]?[indexPath]
            
        default:
            return UICollectionViewLayoutAttributes()
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        visibleAttributes.removeAll(keepingCapacity: true)
        
        for (_, elementInfo) in cache {
            for (_, attributes) in elementInfo {
                if attributes.frame.intersects(rect) {
                    visibleAttributes.append(attributes)
                }
            }
        }
        return visibleAttributes
    }
}
