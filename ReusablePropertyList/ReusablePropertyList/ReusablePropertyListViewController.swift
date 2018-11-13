//
//  ReusablePropertyListChilController.swift
//  ReusablePropertyList
//
//  Created by Felipe Lefevre Marino on 13/11/18.
//  Copyright © 2018 Zap SA Internet. All rights reserved.
//

import UIKit

protocol PropertyListDatasource: class {
    func collectionView(tag: Int, numberOfItemsInSection: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(tag: Int, didSelectRow at: IndexPath)
}

class ReusablePropertyListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private weak var datasource: PropertyListDatasource!
    
    var cellsForRow: Int = 1
    var cellHeight: CGFloat = 60.0
    var scrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            flowLayout?.scrollDirection = scrollDirection
            collectionView.collectionViewLayout = flowLayout!
        }
    }
    var margin: CGFloat = 16.0
    
    init(datasource: PropertyListDatasource, cellId: String, collectionTag: Int) {
        self.datasource = datasource
        super.init(nibName: nil, bundle: nil)
        setupCollectionView(tag: collectionTag)
        register(id: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView(tag: Int) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = scrollDirection
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.tag = tag
    }
    
    private func register(id: String) {
        collectionView.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
    }
}

extension ReusablePropertyListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.collectionView(tag: collectionView.tag, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return datasource.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension ReusablePropertyListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: call child delegate with index of selected card
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // TODO: call data loader when next page arrives
        // or call delegate to download and increase data
    }
}

extension ReusablePropertyListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (view.bounds.width / CGFloat(cellsForRow)) - margin * 2.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
// TODO: custom flow layout that sets cells size accordingly to number of cells by rows and height
