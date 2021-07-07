//
//  GradientView.swift
//  Marvel
//
//  Created by Mark Dalton on 7/5/21.
//

import UIKit

/// Gradient view.
class GradientView: UIView {

    // Gradient start color.
    @IBInspectable
    var startColor: UIColor = .clear

    // Gradient end color.
    @IBInspectable
    var endColor: UIColor = .black.withAlphaComponent(0.5)
    
    /// Gradient layer.
    private var gradient: CAGradientLayer?
    
    /// Layout subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update gradient frame as necessary.
        gradient?.frame = bounds
    }
    
    /// Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    /// Setup gradient.
    private func setupGradient() {
        gradient = CAGradientLayer()
        gradient?.frame = bounds
        gradient?.colors = [startColor.cgColor, endColor.cgColor]
        layer.addSublayer(gradient!)
    }

}
