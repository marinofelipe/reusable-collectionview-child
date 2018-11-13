//
//  MainViewController.swift
//  ReusablePropertyList
//
//  Created by Felipe Lefevre Marino on 13/11/18.
//  Copyright © 2018 Zap SA Internet. All rights reserved.
//

import UIKit

enum CollectionView: Int {
    case vr, zap
}

class MainViewController: UIViewController {

    @IBOutlet weak var horizontalListContainer: UIView!
    @IBOutlet weak var verticalListContainer: UIView!
    
    var vrPropertyModels: [VRPropertyModel] = VRPropertyModel.mock()
    var zapPropertyModels: [ZapPropertyModel] = ZapPropertyModel.mock()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupContainers()
    }
    
    private func setupContainers() {
        let vrPropertyListController = ReusablePropertyListViewController(datasource: self, cellId: VRPropertyCollectionViewCell.id, collectionTag: CollectionView.vr.rawValue)
        vrPropertyListController.scrollDirection = .horizontal
        add(vrPropertyListController, to: horizontalListContainer)
        
        let zapPropertyListController = ReusablePropertyListViewController(datasource: self, cellId: ZapCollectionViewCell.id, collectionTag: CollectionView.zap.rawValue)
        add(zapPropertyListController, to: verticalListContainer)
    }
}

extension MainViewController: PropertyListDatasource {
    func collectionView(tag: Int, numberOfItemsInSection: Int) -> Int {
        if tag == CollectionView.vr.rawValue {
            return vrPropertyModels.count
        }
        return zapPropertyModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == CollectionView.vr.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VRPropertyCollectionViewCell.id, for: indexPath) as? VRPropertyCollectionViewCell else { fatalError() }
            cell.neighborhoodLabel.text = vrPropertyModels[indexPath.item].neighborhood
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZapCollectionViewCell.id, for: indexPath) as? ZapCollectionViewCell else { fatalError() }
        cell.codLabel.text = String(zapPropertyModels[indexPath.item].cod)
        cell.streetLabel.text = zapPropertyModels[indexPath.item].street
        return cell
    }
    
    func collectionView(tag: Int, didSelectRow at: IndexPath) {
        // TODO:
    }
}

extension UIViewController {
    
    func add(_ child: UIViewController?, to subview: UIView? = nil) {
        guard let child = child else { return }
        
        addChild(child)
        
        child.view.frame = subview?.bounds ?? view.bounds
        subview != nil ? subview?.addSubview(child.view) : view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

struct ZapPropertyModel {
    var cod: Int
    var street: String
    
    static func mock() -> [ZapPropertyModel] {
        var models: [ZapPropertyModel] = []
        for index in 0...29 {
            models.append(ZapPropertyModel(cod: index, street: "Street \(index)"))
        }
        return models
    }
}

struct VRPropertyModel {
    var neighborhood: String
    
    static func mock() -> [VRPropertyModel] {
        var models: [VRPropertyModel] = []
        for index in 0...19 {
            models.append(VRPropertyModel(neighborhood: "Neighborhood \(index)"))
        }
        return models
    }
}
