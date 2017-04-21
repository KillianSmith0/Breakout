//
//  BreakoutBehavior.swift
//  Breakout_V1
//
//  Created by Killian Smith on 13/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    var gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.magnitude = 0.05
        gravity.gravityDirection = CGVector(dx: 0.0, dy: 0.01)
        return gravity
    }()
    
    lazy var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.addBoundary(withIdentifier: "Floor" as NSCopying, from: CGPoint(x: 0, y: UIScreen.main.bounds.height), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
        collider.addBoundary(withIdentifier: "Left" as NSCopying, from: CGPoint(x: 0,y: 0), to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
        collider.addBoundary(withIdentifier: "Right" as NSCopying, from: CGPoint(x: UIScreen.main.bounds.width, y: 0), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
        return collider
    }()
    
    private var ballBehavior: UIDynamicItemBehavior = {
        let ballBehavior = UIDynamicItemBehavior()
        ballBehavior.allowsRotation = true
        ballBehavior.elasticity = 1
        ballBehavior.density = 1
        return ballBehavior
    }()
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    func paddleMoved(_ view: PaddleView){
        collider.removeBoundary(withIdentifier: "Paddle" as NSCopying)
        collider.addBoundary(withIdentifier: "Paddle" as NSCopying, for: UIBezierPath(rect: view.frame))
    }
    
    // MARK: - Adds items to behaviors
    func addPaddle(_ view: PaddleView){
        dynamicAnimator?.referenceView?.addSubview(view)
        collider.addBoundary(withIdentifier: "Paddle" as NSCopying, for: UIBezierPath(rect: view.frame))
    }
    
    func addBall(_ view: BallView){
        dynamicAnimator?.referenceView?.addSubview(view)
        gravity.addItem(view)
        collider.addItem(view)
        ballBehavior.addItem(view)
    }
    
    func addBound(view: UIView, name: String){
        dynamicAnimator?.referenceView?.addSubview(view)
        collider.addBoundary(withIdentifier: name as NSCopying, for: UIBezierPath(rect: view.frame))
    }
    
    // Adds ball to behaviors, and shoots it in upwards direction
    func shootBalls(_ views: [BallView]){
        for ball in views {
            addBall(ball)
            ballBehavior.addLinearVelocity(CGPoint(x: CGFloat(arc4random_uniform(40)) - 21.0, y: 300), for: ball)
        }
    }
    
    func changeVelocity(velocity: CGPoint, view: BallView){
        ballBehavior.addLinearVelocity(velocity, for: view)
    }
    
    // MARK: - Removes items from behaviors
    func removeBlock(_ blockID: String){
        collider.removeBoundary(withIdentifier: blockID as NSCopying)
    }
    
    func removeView(_ view: UIView) {
        gravity.removeItem(view)
        collider.removeItem(view)
        ballBehavior.removeItem(view)
    }
    
    func removeAll(){
        gravity.items.forEach(gravity.removeItem(_:))
        collider.items.forEach(collider.removeItem(_:))
        ballBehavior.items.forEach(ballBehavior.removeItem(_:))
        collider.boundaryIdentifiers?.forEach(collider.removeBoundary(withIdentifier:))
    }
    
    func setCollisionDelegate(delegate: UICollisionBehaviorDelegate) {
        collider.collisionDelegate = delegate
    }

}
