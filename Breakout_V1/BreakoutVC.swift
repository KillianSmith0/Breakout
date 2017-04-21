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
        static let NumberOfBlocks: Int = 35
        static let NumberOfBalls: Int = 2
        static let BallSpeed: Double = 20.0
    }
    
    private var tapCount: Int = 0 {
        didSet{
            if tapCount == 1 {
                gameView.breakoutBehavior.shootBalls([BallView](balls.values))
                startLabel.isHidden = true
                endGame = false
            }
        }
    }
    
    // Game Attributes
    private var highScore: Int = 0 {
        didSet{ highScoreLabel.text! = String(highScore)}
    }
    
    private var score: Int = 0 {
        didSet{
            scoreLabel.text = String(score)
            let oldHighScore = UserDefaults.standard.integer(forKey: "highestScore")
            if score > oldHighScore {
                highScore = score
                UserDefaults.standard.setValue(highScore, forKey: "highestScore")
                UserDefaults.standard.synchronize()
            }
        }
    }
    private var endGame: Bool = false
    private var blocksLeft: Int = GameSettings.NumberOfBlocks {
        didSet{ if blocksLeft == 0 { gameOver() }}
    }
    
    private var lives: Int = GameSettings.NumberOfBalls {
        didSet{ if lives == 0 { gameOver() }}
    }
    
    
    // Game Objects
    private var balls: [String: BallView] = [String: BallView]()
    private var blocks: [String: BlockView]! = [String: BlockView]()
    private var paddle: PaddleView!
    
    // Text Labels
    
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var gameView: GameView!

        
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.breakoutBehavior.setCollisionDelegate(delegate: self)
        gameView.animator.delegate = self
        prepareGame()
    }
    
    // Launches the ball after1, if the game has ended, checks before restart
    @IBAction func startGame(_ sender: UITapGestureRecognizer) {
        tapCount += 1
        
        if endGame == true { // & tapped screen then restart game
            print("Reset GAME")
            resetGame()
        }
    }
    
    
    @IBAction func movePaddle(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .began || sender.state == .changed) {
            let translation = sender.translation(in: self.paddle)
            
            paddle.position = CGPoint(x: paddle.position.x + translation.x, y: paddle.position.y)
            gameView.breakoutBehavior.paddleMoved(paddle)
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
    
    
    // MARK: - Methods that create the different type of views
    
    private func makePaddle(){
        paddle = PaddleView(frame: CGRect(origin: CGPoint(x: gameView.bounds.size.width/2 - Constants.PaddleSize.width/2, y: gameView.bounds.size.height * (3/4)), size: Constants.PaddleSize))
        
        gameView.breakoutBehavior.addBound(view: paddle, name: "Paddle")
        gameView.addSubview(paddle)
    }
    
    private func makeBlocks(_ numberOfBlocks: Int){
        let spacing: CGFloat = 2.0
        let totalSpacing: CGFloat = spacing * 5 + 2
        let blockWidth: CGFloat = (gameView.bounds.width-totalSpacing)/5
        let xSpacing: CGFloat = blockWidth + spacing
        
        let blockHeight: CGFloat = 20.0
        let ySpacing: CGFloat = blockHeight + 2.0
        
        for i in 1..<numberOfBlocks/5{
            for j in 0...4{
                let y: CGFloat = spacing + (ySpacing * CGFloat(i))
                let x: CGFloat = spacing + (xSpacing * CGFloat(j))
                let block = BlockView(frame: CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: blockWidth, height: blockHeight)))
                
                let blockID: String = "Block\(i)\(j)"
                gameView.breakoutBehavior.addBound(view: block, name: blockID)
                blocks[blockID] = block
                
                gameView.addSubview(block)
            }
        }
    }
    
    private func makeBalls(_ numberOfBalls: Int){
        for i in 0..<numberOfBalls {
            let ballX: CGFloat = paddle.position.x + (Constants.BallSize.width/4) + (paddle.size.width * (CGFloat(i)/CGFloat(GameSettings.NumberOfBalls)))
            let ballY: CGFloat = paddle.position.y - Constants.BallSize.height
            let ballID: String = "Ball\(i)"
            let ball = BallView(frame: CGRect(origin: CGPoint(x: ballX, y: ballY), size: Constants.BallSize))
            balls[ballID] = ball
            
            gameView.addSubview(ball)
        }
    }
    
    
    // MARK: - Methods that deal with collision checks
    
    private func checkBallDied (boundaryID: String, ball: BallView) {
        if boundaryID == "Floor" {
            gameView.breakoutBehavior.removeView(ball)
            ball.isHidden = true
            lives -= 1
        }
    }
    
    private func checkBlockCollision(boundaryID: String) {
        let blockIDs = [String](blocks.keys)
        
        if blockIDs.contains(boundaryID){
            score += (5/GameSettings.NumberOfBalls) * 10
            gameView.breakoutBehavior.removeBlock(boundaryID)
            blocks[boundaryID]?.isHidden = true
            blocksLeft -= 1
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        
        if let id = identifier as? String, !endGame {
            checkBlockCollision(boundaryID: id)  // if block then destroyBoundary
            checkBallDied(boundaryID: id, ball: item as! BallView)
            if id.contains("Block") {
                let velocity = CGPoint(x:CGFloat(arc4random_uniform(60)) - 31.0, y: 100)
                gameView.breakoutBehavior.changeVelocity(velocity: velocity, view: item as! BallView)
            }
        }
        
        
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        // if ball against paddle boundary
        if balls.values.contains(item as! BallView), let ball = item as? BallView,
            let id = identifier as? String {
            if id == "Paddle" {
                if p.x <= paddle.position.x + (3/7 * paddle.size.width) {
                    gameView.breakoutBehavior.changeVelocity(velocity: CGPoint(x: -Int(arc4random_uniform(200)+100),y: -100), view: ball)
                }else if p.x >= paddle.position.x + (5/7 * paddle.size.width) {
                    gameView.breakoutBehavior.changeVelocity(velocity: CGPoint(x: Int(arc4random_uniform(200)) - 100,y: -100), view: ball)
                }else{
                    gameView.breakoutBehavior.changeVelocity(velocity: CGPoint(x: Int(arc4random_uniform(200)+100),y: -100), view: ball)
                }
            }
        }
    }
    
    
    // Mark: - Methods that deal with game logic and setup
    
    
    // Called when no balls/bricks left. Able to start game again.
    func gameOver(){
        // Display game over labels
        scoreLabel.text = String(score*(lives+1))
        startLabel.text! = "Game Over☄️\tScore: \(scoreLabel.text!)\nTap to play again🎮"
        startLabel.isHidden = false
        endGame = true
    }
    
    // Initializes game properties to prepare game to play
    func prepareGame(){
        tapCount = 0
        score = 0
        lives = GameSettings.NumberOfBalls
        
        balls = [String: BallView]()   // removes all views and ids
        blocks = [String: BlockView]()
        paddle = PaddleView()
        
        makePaddle()
        makeBalls(GameSettings.NumberOfBalls)
        makeBlocks(GameSettings.NumberOfBlocks)
        endGame = false
    }
    
    // Called when screen is tapped when a game ends
    func resetGame(){
        for view in gameView.subviews{
            view.isHidden = true
        }
        scoreLabel.isHidden = false
        highScoreLabel.isHidden = false
        
        let collider = gameView.breakoutBehavior.collider
        for name in collider.boundaryIdentifiers as! [String] {
            if name.contains("Ball") || name.contains("Paddle") || name.contains("Block"){
                collider.removeBoundary(withIdentifier: name as NSCopying)
            }
        }
        prepareGame()
    }
    
    // MARK: - Dynamic animator methods
    
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

