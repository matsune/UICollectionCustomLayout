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

    fileprivate let itemReuseIdentifier = "dayCell"
    
    var supplementaryKinds: [String] = ["BackgroundView", "WeekView"]
    fileprivate let backgroundReuseIdentifier = "backgroundView"
    fileprivate let weekReuseIdentifier = "weekView"
    
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
                                forSupplementaryViewOfKind: supplementaryKinds[0],
                                withReuseIdentifier: backgroundReuseIdentifier)
        collectionView.register(UINib(nibName: "CalendarWeekView", bundle: nil),
                                forSupplementaryViewOfKind: supplementaryKinds[1],
                                withReuseIdentifier: weekReuseIdentifier)
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
        case supplementaryKinds[0]:
            guard let reusableView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: backgroundReuseIdentifier,
                                                  for: indexPath) as? CalendarBackgroundView else {
                                                    fatalError()
            }
            reusableView.backgroundColor = .white
            reusableView.monthLabel.text = "\(indexPath.section + 1)"
            return reusableView
        case supplementaryKinds[1]:
            guard let reusableView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: weekReuseIdentifier,
                                                  for: indexPath) as? CalendarWeekView else {
                                                    fatalError()
            }
            reusableView.backgroundColor = .gray
            reusableView.weekdayLabel.text = "\(Calendar.current.shortWeekdaySymbols[indexPath.row])"
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
    
    func collectionView(_ collectionView: UICollectionView, rectForItemCellAt indexPath: IndexPath) -> CGRect {
        let weekdayViewHeight: CGFloat = 20.0
        let dayWidth  = collectionView.bounds.width / 7.0
        let dayHeight = (collectionView.bounds.height - weekdayViewHeight) / 5.0
        var x = collectionView.bounds.width * CGFloat(indexPath.section)
        x += CGFloat(indexPath.row % 7) * dayWidth
        let week = CGFloat(indexPath.row / 7)
        let y = week * CGFloat(dayHeight) + weekdayViewHeight
        return CGRect(x: x,
                      y: y,
                      width: dayWidth - 5,
                      height: dayHeight - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, rectForSupplementaryViewOfKind kind: String, at indexPath: IndexPath) -> CGRect {
        let weekdayViewHeight: CGFloat = 20.0
        
        switch kind {
        case supplementaryKinds[0]:
            let x = collectionView.bounds.width * CGFloat(indexPath.section)
            return CGRect(x: x,
                          y: 0,
                          width: collectionView.bounds.width,
                          height: collectionView.bounds.height)
            
        case supplementaryKinds[1]:
            let dayWidth = collectionView.bounds.width / 7.0
            var x = collectionView.bounds.width * CGFloat(indexPath.section)
            x += dayWidth * CGFloat(indexPath.row)
            return CGRect(x: x,
                          y: 0,
                          width: dayWidth,
                          height: weekdayViewHeight)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, zIndexForItemCellat indexPath: IndexPath) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, zIndexForSupplementaryViewOfKind kind: String, at indexPath: IndexPath) -> Int {
        switch kind {
        case supplementaryKinds[0]:
            return 1
        case supplementaryKinds[1]:
            return 20
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSupplementaryViewsOfKind kind: String, InSection section: Int) -> Int {
        switch kind {
        case supplementaryKinds[0]:
            return 1
        case supplementaryKinds[1]:
            return 7
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView, ofKind kind: String) -> Int {
        switch kind {
        case supplementaryKinds[0], supplementaryKinds[1]:
            return 12
        default:
            return 0
        }
    }
}
