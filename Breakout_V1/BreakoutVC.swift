//
//  BreakoutVC.swift
//  Breakout_V1
//
//  Created by Killian Smith on 14/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class BreakoutVC: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    struct Constants {
        static let BallSize = CGSize(width: 15.0, height: 15.0)
        static let PaddleSize = CGSize(width: 100.0, height: 10.0)
    }
    
    struct GameSettings {
        static let NumberOfBlocks: Int = 25
        static let NumberOfBalls: Int = 5
        static let BallSpeed: Double = 20.0
    }
    private var tapCount: Int = 0
    
    private var balls: [BallView] = [BallView]()
    
    private var blocks: [BlockView]! = [BlockView]()
    
    private var paddle: PaddleView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var gameView: GameView!
    
    var breakoutBehavior = BreakoutBehavior()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.gameView)
        animator.addBehavior(self.breakoutBehavior)
        return animator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.delegate = self

        // Make the paddle
        let paddleX = gameView.bounds.size.width/2 - Constants.PaddleSize.width/2
        let paddleY = gameView.bounds.size.height * (3/4)
        paddle = PaddleView(frame: CGRect(origin: CGPoint(x: paddleX, y: paddleY), size: Constants.PaddleSize))
        paddle.position = CGPoint(x: paddleX, y: paddleY)

        // Generate the balls
        for i in 0..<GameSettings.NumberOfBalls {
            let ballX: CGFloat = paddle.position.x + (Constants.BallSize.width/4) + (Constants.PaddleSize.width * (CGFloat(i)/CGFloat(GameSettings.NumberOfBalls)))
            let ballY: CGFloat = paddle.position.y - Constants.BallSize.height
            let ball = BallView(frame: CGRect(origin: CGPoint(x: ballX, y: ballY), size: Constants.BallSize))
            balls.append(ball)
        }
        
        // Generate the blocks
        makeBlocks(numberOfBlocks: GameSettings.NumberOfBlocks)
        
        // Add views to the gameview and the behaviors
        gameView.addSubview(paddle)
        gameView.addSubviews(balls)
        gameView.addSubviews(blocks)
        
        breakoutBehavior.addPaddle(paddle)
    }
    //@IBAction func startGame(TAPGesture){ }
    
    @IBAction func insertBall(_ sender: UITapGestureRecognizer) {
        let x = gameView.bounds.size.width * CGFloat(arc4random()) / CGFloat(RAND_MAX) // drops ball down at random x
        makeBalls(numberOfBalls: GameSettings.NumberOfBalls,x: x, y: 0.0 as CGFloat)
        print("\(sender.location(in: self.gameView))")
        
        if tapCount < 1 {
            for ball in balls {
                breakoutBehavior.addView(ball)
            }
            print("BallBehaviors added")

        }
        tapCount += 1
    }
    
    @IBAction func movePaddle(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .began || sender.state == .changed) {
            let translation = sender.translation(in: self.paddle)
            
            paddle.position = CGPoint(x: paddle.position.x + translation.x, y: paddle.position.y)
            breakoutBehavior.paddleMoved(paddle)
            sender.setTranslation(CGPoint.zero, in: self.gameView)
            
            if(paddle.frame.minX < 0){
                paddle.position = CGPoint(x: 0,y: paddle.position.y)
            }
            if(paddle.frame.maxX > gameView.bounds.width){
                let paddleOrigin = gameView.bounds.width - paddle.size.width
                paddle.position = CGPoint(x: paddleOrigin, y: paddle.position.y)
            }
        }
    }
    
    private func makeBlocks(numberOfBlocks: Int){
        let spacing: CGFloat = 2.0
        let totalSpacing: CGFloat = spacing * 5 + 2
        let blockWidth: CGFloat = (gameView.bounds.width-totalSpacing)/5
        let xSpacing: CGFloat = blockWidth + spacing
        
        let blockHeight: CGFloat = 20.0
        let ySpacing: CGFloat = blockHeight + 2.0
       
        for i in 1...numberOfBlocks/5{
            for j in 0...4{
                let y: CGFloat = spacing + (ySpacing * CGFloat(i))
                let x: CGFloat = spacing + (xSpacing * CGFloat(j))

                let block = BlockView(frame: CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: blockWidth, height: blockHeight)))
                blocks.append(block)
            }
        }
    }
    
    private func makeBalls(numberOfBalls: Int, x: CGFloat, y: CGFloat){
        let ballView = BallView(frame: CGRect(origin: CGPoint(x: x, y: y), size: Constants.BallSize))
        
        gameView.addSubview(ballView)
        breakoutBehavior.addView(ballView)
        
        
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("Animation paused")
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("Animation resumed")
    }
}

extension UIColor {
    static func  RandomColor() -> UIColor {
        let randomHue = CGFloat(arc4random()) / CGFloat(RAND_MAX)
        return UIColor(hue: randomHue, saturation: 1.0, brightness: 1.0, alpha: 0.5)
    }
}

