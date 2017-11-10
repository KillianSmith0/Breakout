//
//  PaddleView.swift
//  Breakout_V1
//
//  Created by Killian Smith on 19/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class PaddleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.size = frame.size
        backgroundColor = Settings.Instance.PaddleColor
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = frame.size.height / 2.0
        position = CGPoint(x: frame.origin.x, y: frame.origin.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    var size: CGSize!
    
    var position: CGPoint! {    // Optional
        didSet{
            self.frame.origin.x = position.x
            self.frame.origin.y = position.y
        }
    }

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .rectangle
    }

}
