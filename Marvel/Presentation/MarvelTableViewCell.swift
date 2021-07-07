//
//  MarvelTableViewCell.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//

import UIKit

class MarvelTableViewCell: UITableViewCell {
    
    /// Background image.
    @IBOutlet weak var backgroundImage: UIImageView!
    
    /// Name label.
    @IBOutlet weak var nameLabel: UILabel!
    
    /// Shadow view.
    @IBOutlet weak var shadowView: UIView!
    
    /// Gradient view.
    @IBOutlet weak var gradientView: GradientView!

}
