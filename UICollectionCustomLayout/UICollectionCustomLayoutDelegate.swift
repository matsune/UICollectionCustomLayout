//
//  UICollectionCustomLayoutDelegate.swift
//  UICollectionCustomLayout
//
//  Created by Yuma Matsune on 2017/10/23.
//  Copyright © 2017年 matsune. All rights reserved.
//

import Foundation

public protocol UICollectionCustomLayoutDelegate: class {
    var kindOfItem: String { get }
    var kindsOfSupplementary: [String] { get }
    
    func collectionView(_ collectionView: UICollectionView, rectForCellOfKind kind: String, at indexPath: IndexPath) -> CGRect
    func collectionView(_ collectionView: UICollectionView, zIndexForCellOfKind kind: String, at indexPath: IndexPath) -> Int
    
    func collectionView(_ collectionView: UICollectionView, numberOfSupplementaryViewsOfKind kind: String, InSection section: Int) -> Int
    func numberOfSections(in collectionView: UICollectionView, ofKind kind: String) -> Int
}

extension UICollectionCustomLayoutDelegate {
    var kindsOfSupplementary: [String] {
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView, rectForCellOfKind kind: String, at indexPath: IndexPath) -> CGRect {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, zIndexForCellOfKind kind: String, at indexPath: IndexPath) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSupplementaryViewsOfKind kind: String, InSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView, ofKind kind: String) -> Int {
        return 0
    }
}
