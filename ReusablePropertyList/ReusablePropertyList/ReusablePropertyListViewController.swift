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

class ReusablePropertyListViewController: UIViewController, CardsLayoutDelegate {
    
    private var collectionView: UICollectionView!
    
    private weak var datasource: PropertyListDatasource!
    
    var numberOfHorizontalVisibleCards: Int = 1
    var numberOfVerticalVisibleCards: Int = 1
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
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
        let cardsFlowLayout = CardsFlowLayout()
        cardsFlowLayout.delegate = self
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: cardsFlowLayout)
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
        collectionView.isPagingEnabled = true
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
