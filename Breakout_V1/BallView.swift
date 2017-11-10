//
//  BallView.swift
//  Breakout_V1
//
//  Created by Killian Smith on 20/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class BallView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.RandomColor()
        layer.cornerRadius = frame.size.width / 2.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}
