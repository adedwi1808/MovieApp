//
//  UIView+Extension.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

import UIKit

extension UIView {
    func startShimmering() {
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.6).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.8)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }

    func stopShimmering(){
        self.layer.mask = nil
    }
}
