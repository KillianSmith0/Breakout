//
//  BreakoutBehavior.swift
//  Breakout_V1
//
//  Created by Killian Smith on 13/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    private var gravity = UIGravityBehavior()

    private lazy var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.addBoundary(withIdentifier: "verticalMin" as NSCopying, from: CGPoint(x: 0,y: 0), to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
        collider.addBoundary(withIdentifier: "verticalMax" as NSCopying, from: CGPoint(x: UIScreen.main.bounds.width, y: 0), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
        return collider
    }()
    
    private var ballBehavior: UIDynamicItemBehavior = {
        let ballBehavior = UIDynamicItemBehavior()
        ballBehavior.allowsRotation = true
        ballBehavior.elasticity = 0.8
        return ballBehavior
    }()
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
//        addChildBehavior(ballBehavior)
    }
    
    func addPaddle(_ view: UIView){
        dynamicAnimator?.referenceView?.addSubview(view)
        collider.addBoundary(withIdentifier: "Paddle" as NSCopying, for: UIBezierPath(rect: view.frame))
    }
    
    func paddleMoved(_ view: UIView){
        collider.removeBoundary(withIdentifier: "Paddle" as NSCopying)
        collider.addBoundary(withIdentifier: "Paddle" as NSCopying, for: UIBezierPath(rect: view.frame))
    }
    
    func addView(_ view: UIView){
        dynamicAnimator?.referenceView?.addSubview(view)
        gravity.addItem(view)
        collider.addItem(view)
    }
    
    func removeView(_ view: UIView){
        gravity.removeItem(view)
        collider.removeItem(view)
        dynamicAnimator?.referenceView?.removeFromSuperview()
    }
    
}
