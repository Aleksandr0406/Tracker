//
//  PH.swift
//  Tracker
//
//  Created by 1111 on 15.04.2025.
//

import UIKit

final class GradientBorderView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    private let borderWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    private func configureGradientLayer() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(resource: .gradientColor1).cgColor,
            UIColor(resource: .gradientColor2).cgColor,
            UIColor(resource: .gradientColor3).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.cornerRadius = cornerRadius
        
        let maskLayer = createMaskLayer()
        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }
    
    private func createMaskLayer() -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = borderWidth
        return maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.mask?.frame = bounds
        (gradientLayer.mask as? CAShapeLayer)?.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}

