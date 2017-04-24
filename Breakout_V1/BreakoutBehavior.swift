//
//  BreakoutBehavior.swift
//  Breakout_V1
//
//  Created by Killian Smith on 13/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    lazy var collider: UICollisionBehavior = UICollisionBehavior()
    
    private var ballBehavior: UIDynamicItemBehavior = {
        let ballBehavior = UIDynamicItemBehavior()
        ballBehavior.allowsRotation = true
        ballBehavior.elasticity = 1
        ballBehavior.density = 1
        ballBehavior.resistance = 0
        return ballBehavior
    }()
    
    override init(){
        super.init()
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
        collider.addItem(view)
        ballBehavior.addItem(view)
    }
    
    func addBound(view: UIView, name: String){
        dynamicAnimator?.referenceView?.addSubview(view)
        collider.addBoundary(withIdentifier: name as NSCopying, for: UIBezierPath(rect: view.frame))
    }
    
    func addWalls() {
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.addBoundary(withIdentifier: "Floor" as NSCopying, from: CGPoint(x: 0, y: UIScreen.main.bounds.height), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
        collider.addBoundary(withIdentifier: "Left" as NSCopying, from: CGPoint(x: 0,y: 0), to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
        collider.addBoundary(withIdentifier: "Right" as NSCopying, from: CGPoint(x: UIScreen.main.bounds.width, y: 0), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
    }
    
    // Adds ball to behaviors, and shoots it in upwards direction
    func shootBalls(_ views: [BallView]){
        for ball in views {
            addBall(ball)
            ballBehavior.addLinearVelocity(CGPoint(x: CGFloat(arc4random_uniform(200)) - 100.0, y: CGFloat(400*Settings.Instance.BallSpeed)), for: ball)
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
        collider.removeItem(view)
        ballBehavior.removeItem(view)
    }
    
    func removeAll(){
        collider.items.forEach(collider.removeItem(_:))
        ballBehavior.items.forEach(ballBehavior.removeItem(_:))
        collider.boundaryIdentifiers?.forEach(collider.removeBoundary(withIdentifier:))
    }
    
    func setCollisionDelegate(delegate: UICollisionBehaviorDelegate) {
        collider.collisionDelegate = delegate
    }

}
