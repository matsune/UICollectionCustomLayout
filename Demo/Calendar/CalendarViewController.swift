//
//  CalendarViewController.swift
//  Demo
//
//  Created by Yuma Matsune on 2017/10/23.
//  Copyright © 2017年 matsune. All rights reserved.
//

import Foundation
import UIKit
import UICollectionCustomLayout

final class CalendarViewController: UIViewController {
    
    private var collectionView: UICollectionView!

    var kindOfItem: String = "DayCell"
    fileprivate let itemReuseIdentifier = "dayCell"
    
    var kindsOfSupplementary: [String] = ["BackgroundView"]
    fileprivate let backgroundReuseIdentifier = "backgroundView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        
        let layout = UICollectionCustomLayout()
        layout.delegate = self
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.width),
                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarDayCell", bundle: nil),
                                forCellWithReuseIdentifier: itemReuseIdentifier)
        collectionView.register(UINib(nibName: "CalendarBackgroundView", bundle: nil),
                                forSupplementaryViewOfKind: kindsOfSupplementary[0],
                                withReuseIdentifier: backgroundReuseIdentifier)
        view.addSubview(collectionView)
        view.backgroundColor = .white
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath) as? CalendarDayCell else {
            fatalError()
        }
        cell.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        cell.dayLabel.text = "\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case kindsOfSupplementary[0]:
            guard let reusableView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: backgroundReuseIdentifier,
                                                  for: indexPath) as? CalendarBackgroundView else {
                                                    fatalError()
            }
            reusableView.backgroundColor = .white
            reusableView.monthLabel.text = "\(indexPath.section + 1)"
            return reusableView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
}

extension CalendarViewController: UICollectionCustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, rectForCellOfKind kind: String, at indexPath: IndexPath) -> CGRect {
        switch kind {
        case kindOfItem:
            let dayWidth  = collectionView.bounds.width / 7.0
            let dayHeight = collectionView.bounds.height / 5.0
            var x = collectionView.bounds.width * CGFloat(indexPath.section)
            x += CGFloat(indexPath.row % 7) * dayWidth
            let week = CGFloat(indexPath.row / 7)
            let y = week * CGFloat(dayHeight)
            return CGRect(x: x,
                          y: y,
                          width: dayWidth - 5,
                          height: dayHeight - 5)
            
        case kindsOfSupplementary[0]:
            let x = collectionView.bounds.width * CGFloat(indexPath.section)
            return CGRect(x: x,
                          y: 0,
                          width: collectionView.bounds.width,
                          height: collectionView.bounds.height)
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, zIndexForCellOfKind kind: String, at indexPath: IndexPath) -> Int {
        switch kind {
        case kindOfItem:
            return 10
        case kindsOfSupplementary[0]:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSupplementaryViewsOfKind kind: String, InSection section: Int) -> Int {
        switch kind {
        case kindsOfSupplementary[0]:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView, ofKind kind: String) -> Int {
        switch kind {
        case kindsOfSupplementary[0]:
            return 12
        default:
            return 0
        }
    }
}
