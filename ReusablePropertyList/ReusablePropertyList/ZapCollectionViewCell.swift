//
//  ZapCollectionViewCell.swift
//  ReusablePropertyList
//
//  Created by Felipe Lefevre Marino on 13/11/18.
//  Copyright © 2018 Zap SA Internet. All rights reserved.
//

import UIKit

class ZapCollectionViewCell: UICollectionViewCell {
    
    static var id: String = "ZapCollectionViewCell"
    
    @IBOutlet weak var codLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        
    }
}
