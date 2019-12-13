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
    
    override class var layoutAttributesClass: AnyClass {
        return WeatherLayoutAttributes.self
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
    
    private var oldBounds = CGRect.zero
    private var cache = [Element: [IndexPath: WeatherLayoutAttributes]]()
    private var visibleAttributes = [WeatherLayoutAttributes]()
    private var contentHeight = CGFloat()
    private var zIndex = 0 // 뷰가 겹치는 경우에 속성값을 할당해 겹치는 뷰의 일관성 보장
    
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
        oldBounds = collectionView.bounds
        
        let itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let headerAttributes = WeatherLayoutAttributes(forSupplementaryViewOfKind: Element.WeatherHeaderView.kind, with: IndexPath(item: 0, section: 0))
        prepareElement(size: headerSize, type: .WeatherHeaderView, attributes: headerAttributes)
        
        let todayWeatherAttributes = WeatherLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        prepareElement(size: cellTodayWeatherHeight, type: .TodayWeatherCell, attributes: todayWeatherAttributes)
        
        let weeklyWeatherAttributes = WeatherLayoutAttributes(forCellWith: IndexPath(item: 0, section: 1))
        prepareElement(size: cellWeeklyWeatherHeight, type: .WeeklyWeatherCell, attributes: weeklyWeatherAttributes)
        
        let summaryAttributes = WeatherLayoutAttributes(forCellWith: IndexPath(item: 0, section: 2))
        prepareElement(size: cellSummaryWeatherHeight, type: .SummaryTodayWeatherCell, attributes: summaryAttributes)
        
        let detailAttributes = WeatherLayoutAttributes(forCellWith: IndexPath(item: 0, section: 3))
        prepareElement(size: cellDetailTodayWeatheHeight, type: .DetailTodayWeatherCell, attributes: detailAttributes)
        
        // update zIndex (TodayWeatherCell이 최상단에 오기 위해서)
        cache[.TodayWeatherCell]?.first?.value.zIndex = zIndex + 1
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if oldBounds.size != newBounds.size {
            cache.removeAll(keepingCapacity: true)
        }
        return true // if the collection view requires a layout update
    }
    
    func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.WeatherHeaderView] = [IndexPath: WeatherLayoutAttributes]()
        cache[.TodayWeatherCell] = [IndexPath: WeatherLayoutAttributes]()
        cache[.WeeklyWeatherCell] = [IndexPath: WeatherLayoutAttributes]()
        cache[.SummaryTodayWeatherCell] = [IndexPath: WeatherLayoutAttributes]()
        cache[.DetailTodayWeatherCell] = [IndexPath: WeatherLayoutAttributes]()
    }
    
    func prepareElement(size: CGSize, type: Element, attributes: WeatherLayoutAttributes) {
        guard size != .zero else { return }
        
        attributes.initialOrigin = CGPoint(x: 0, y: contentHeight)
        attributes.frame = CGRect(origin: CGPoint(x: 0, y: contentHeight), size: size)
        attributes.zIndex = zIndex
        zIndex += 1
        
        contentHeight  = attributes.frame.maxY
        
        cache[type]?[attributes.indexPath] = attributes
    }
}

// MARK: - PROVIDING ATTRIBUTES TO THE COLLECTIONVIEW
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
        guard let collectionView = collectionView else { return nil }
        visibleAttributes.removeAll(keepingCapacity: true)
        
        for (type, elementInfo) in cache {
            for (indexPath, attributes) in elementInfo {
                attributes.transform = .identity
                updateStickyViews(type, attributes: attributes, collectionView: collectionView, indexPath: indexPath)
                if attributes.frame.intersects(rect) {
                    visibleAttributes.append(attributes)
                }
            }
        }
        return visibleAttributes
    }
    
    private func updateStickyViews(_ type: Element, attributes: WeatherLayoutAttributes, collectionView: UICollectionView, indexPath: IndexPath) {
        if type == .WeatherHeaderView {
            let updatedHeight = max(headerSize.height, headerSize.height - contentOffset.y)
            let delta = (updatedHeight - headerSize.height)
            if contentOffset.y > 0 {
                attributes.transform = CGAffineTransform(translationX: 0, y: max(attributes.initialOrigin.y, contentOffset.y) - delta)
            } else {
                attributes.transform = CGAffineTransform(translationX: 0, y: min(contentOffset.y, headerSize.height))
            }
        }
        else if type == .TodayWeatherCell {
            let updatedHeight = max(headerSize.height / 2, headerSize.height / 2 - contentOffset.y)
            let delta = updatedHeight - headerSize.height
            attributes.transform = CGAffineTransform(translationX: 0, y: max(0, contentOffset.y - attributes.initialOrigin.y - delta))
        }
    }
}
