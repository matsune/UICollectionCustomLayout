//
//  UICollectionCustomLayout.swift
//  UICollectionCustomLayout
//
//  Created by Yuma Matsune on 2017/10/23.
//  Copyright © 2017年 matsune. All rights reserved.
//

import Foundation
import UIKit

open class UICollectionCustomLayout: UICollectionViewLayout {
    typealias AttrDict = [IndexPath : UICollectionViewLayoutAttributes]
    
    public weak var delegate: UICollectionCustomLayoutDelegate!
    
    private var cache: [String : AttrDict] = [:]
    
    private var contentSize: CGSize = .zero
    
    override open func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else { return }
        prepareCache()
        
        contentSize = .zero
        
        for section in 0..<collectionView.numberOfSections {
            for row in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath   = IndexPath(row: row, section: section)
                let attributes  = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let frame       = delegate.collectionView(collectionView, rectForCellOfKind: delegate.kindOfItem, at: indexPath)
                attributes.frame = frame
                contentSize = maxContentSize(from: frame)
                
                cache[delegate.kindOfItem]?.updateValue(attributes, forKey: indexPath)
            }
        }
        
        for kind in delegate.kindsOfSupplementary {
            let numberOfSupplementarySections = delegate.numberOfSections(in: collectionView,
                                                                          ofKind: kind)
            for section in 0..<numberOfSupplementarySections {
                let numberOfViewsInSection = delegate.collectionView(collectionView,
                                                                    numberOfSupplementaryViewsOfKind: kind,
                                                                    InSection: section)
                for row in 0..<numberOfViewsInSection {
                    let indexPath = IndexPath(row: row, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
                    let frame = delegate.collectionView(collectionView, rectForCellOfKind: kind, at: indexPath)
                    attributes.frame = frame
                    
                    contentSize = maxContentSize(from: frame)
                    
                    cache[kind]?.updateValue(attributes, forKey: indexPath)
                }
            }
        }
        updateZIndexes()
    }
    
    private func prepareCache() {
        cache[delegate.kindOfItem] = [:]
        delegate.kindsOfSupplementary.forEach { cache[$0] = [:] }
    }
    
    private func updateZIndexes() {
        guard let collectionView = collectionView else { return }
        
        cache.forEach { kind, attributeDict in
            attributeDict.forEach { indexPath, attributes in
                attributes.zIndex = delegate.collectionView(collectionView, zIndexForCellOfKind: kind, at: indexPath)
            }
        }
    }
    
    private func maxContentSize(from frame: CGRect) -> CGSize {
        let maxX = frame.origin.x + frame.size.width
        let maxY = frame.origin.y + frame.size.height
        return CGSize(width: max(contentSize.width, maxX), height: max(contentSize.height, maxY))
    }
    
    override open var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[delegate.kindOfItem]?[indexPath]
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes: [UICollectionViewLayoutAttributes] = []
        cache.forEach { kind, attributeDict in
            attributeDict.forEach { path, attributes in
                if rect.intersects(attributes.frame) {
                    allAttributes.append(attributes)
                }
            }
        }
        return allAttributes
    }
    
    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = cache[elementKind] {
            return attributes[indexPath]
        }
        return nil
    }
}

