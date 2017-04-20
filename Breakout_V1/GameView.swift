//
//  GameView.swift
//  Breakout_V1
//
//  Created by Killian Smith on 13/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class GameView: UIView {

    var bezierPaths = [String: UIBezierPath]()
    
    func setPath(_ path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
    
    func addSubviews(_ views: [UIView]){
        for view in views{
            self.addSubview(view)
        }
    }

}
