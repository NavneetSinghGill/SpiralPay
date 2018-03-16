//
//  ShoppingCartTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 16/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import CoreData

protocol ShoppingCartTableViewCellDelegate {
    func deleteCellWith(indexPath: IndexPath, combinedItem: CombinedItem?)
}

class ShoppingCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var indexPath: IndexPath?
    var delegate: ShoppingCartTableViewCellDelegate?
    var combinedItem: CombinedItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteButtonTapped() {
        if let indexPath = indexPath {
            delegate?.deleteCellWith(indexPath: indexPath, combinedItem: combinedItem)
        }
    }
    
}
