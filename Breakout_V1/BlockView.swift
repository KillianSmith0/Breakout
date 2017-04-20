//
//  BlockView.swift
//  Breakout_V1
//
//  Created by Killian Smith on 19/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class BlockView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.size = frame.size
        backgroundColor = UIColor.RandomColor()
        layer.cornerRadius = frame.size.width / 10.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
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
            
            print("Paddle pos: \(self.position!)")
        }
    }

}
