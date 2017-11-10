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
    
    private var tapCount: Int = 0 {
        didSet{
            if tapCount == 1 {
                startLabel.isHidden = true
                endGame = false
                gameView.breakoutBehavior.shootBalls([BallView](balls.values))
            }
        }
    }
    
    // Game Attributes
    private var highScore: Int = UserDefaults.standard.integer(forKey: "highestScore"){
        didSet{
            print("NEW highscore")
            highScoreLabel.text! = "Highscore: \(highScore)" }
    }
    
    private var score: Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
            let oldHighScore = UserDefaults.standard.integer(forKey: "highestScore")
            if score > oldHighScore {
                highScore = score
                UserDefaults.standard.setValue(highScore, forKey: "highestScore")
                UserDefaults.standard.synchronize()
            }
        }
    }
    private var endGame: Bool = false
   
    private var blocksLeft: Int = 0 {
        didSet{ if blocksLeft == 0 { gameOver() }}
    }
    
    private var lives: Int = Settings.Instance.NumberOfBalls {
        didSet{ if lives == 0 { gameOver() }}
    }
    
    
    // Game Objects
    private var balls: [String: BallView] = [String: BallView]()
    private var blocks: [String: BlockView]! = [String: BlockView]()
    private var paddle: PaddleView!
    
    // Text Labels
    @IBOutlet weak var scoresStackView: UIStackView!
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetGame()
    }
    
    
    // MARK: - Gesture Recognizer actions
    
    // Launches the ball after (see tapCount), if the game has ended it checks before restart
    @IBAction func startGame(_ sender: UITapGestureRecognizer) {
        tapCount += 1
        if endGame == true { // & tapped screen then restart game
            print("Game Started")
            resetGame()
        }
    }
    
    // Pan Gesuture
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
        paddle = PaddleView()
        let paddleWidth: CGFloat = 100.0 * CGFloat(Settings.Instance.PaddleSize)
        let paddleHeight: CGFloat = 15.0
        
        let paddleStartXY = CGPoint(x: gameView.bounds.size.width/2 - Constants.PaddleSize.width/2,y:gameView.bounds.size.height * (3/4))
        
        paddle = PaddleView(frame: CGRect(origin: paddleStartXY, size: CGSize(width: paddleWidth, height: paddleHeight)))
        
        gameView.breakoutBehavior.addBound(view: paddle, name: "Paddle")
        gameView.addSubview(paddle)
    }
    
    private func makeBlocks(_ numberOfBlocks: Int){
        let spacing: CGFloat = 2.0
        let totalSpacing: CGFloat = spacing * (CGFloat(Settings.Instance.BlocksPerRow)+1)
        
        let blockWidth: CGFloat = (gameView.bounds.width-totalSpacing)/CGFloat(Settings.Instance.BlocksPerRow)
        let xSpacing: CGFloat = blockWidth + spacing
        let blockHeight: CGFloat = blockWidth/3
        let ySpacing: CGFloat = blockHeight + 2.0
        // empties array
        blocks = [String: BlockView]()
        
        for i in 1...Settings.Instance.NumberOfRows {
            for j in 0...Settings.Instance.BlocksPerRow{
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
        balls = [String: BallView]()   // removes all views and ids
        for i in 0..<numberOfBalls {
            let ballX: CGFloat = paddle.position.x + (Constants.BallSize.width/4) + (paddle.size.width * (CGFloat(i)/CGFloat(Settings.Instance.NumberOfBalls)))
            let ballY: CGFloat = paddle.position.y - Constants.BallSize.height
            let ballID: String = "Ball\(i)"
            let ball = BallView(frame: CGRect(origin: CGPoint(x: ballX, y: ballY), size: Constants.BallSize))
            balls[ballID] = ball
            gameView.addSubview(ball)
        }
    }
    
    
    // MARK: - Methods that deal with collision checks
    
    private func checkFloorCollision(boundaryID: String, ball: UIView) {
        if boundaryID == "Floor" {
            gameView.breakoutBehavior.removeView(ball)
            ball.isHidden = true
            lives -= 1
        }
    }
    
    private func checkBlockCollision(boundaryID: String, ball: UIView) {
        let blockIDs = [String](blocks.keys)
        
        if blockIDs.contains(boundaryID){
            // Bounce ball back
            
            score += (5/lives) * 10
            // Destroy block
            gameView.breakoutBehavior.removeBlock(boundaryID)
            blocks[boundaryID]?.isHidden = true
            blocksLeft -= 1
        }
    }
    
    private func checkPaddleCollision(boundaryID: String, ball: BallView, at p: CGPoint) {
        if boundaryID.contains("Paddle"){
            if p.x <= (paddle.position.x + (3/7 * paddle.size.width)) {   //LHS
                gameView.breakoutBehavior.changeVelocity(velocity: CGPoint(x: -Int(arc4random_uniform(200)+100),y: 50), view: ball)
            }
            if p.x >= (paddle.position.x + (5/7 * paddle.size.width)) {
                gameView.breakoutBehavior.changeVelocity(velocity: CGPoint(x: Int(arc4random_uniform(200)) - 100,y: 50), view: ball)
            }else{
                gameView.breakoutBehavior.changeVelocity(velocity: CGPoint(x: Int(arc4random_uniform(100))-50,y: 50), view: ball)
            }
        }
    }
    
    // For paddle collision, need point p to decide which direction to send ball
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        // if ball against paddle boundary
        if balls.values.contains(item as! BallView), let ball = item as? BallView,
            let id = identifier as? String {
                checkPaddleCollision(boundaryID: id, ball: ball, at: p)
                checkBlockCollision(boundaryID: id, ball: item as! UIView)  // if block destroyBoundary
                checkFloorCollision(boundaryID: id, ball: item as! UIView)
        }
    }
    
    
    // MARK: - Methods that deal with game logic and setup
    
    // Called when no balls/bricks left. Able to start game again.
    private func gameOver(){
        // Display game over labels
        print("GameOver")
        let finalScore = score*(lives+1)
        scoreLabel.text = "Score: \(finalScore)"
        startLabel.text! = "Game Over☄️\tScore: \(finalScore)\nTap to play again🎮"
        startLabel.isHidden = false
        endGame = true
    }
    
    // Initializes game properties to prepare game to play
    private func prepareGame(){
        // Initialize gameProperties
        print("Preparing for new game")
        endGame = false
        tapCount = 0
        score = 0
        lives = Settings.Instance.NumberOfBalls
        blocksLeft = Settings.Instance.BlocksPerRow * Settings.Instance.NumberOfRows
        
        highScoreLabel.text = "Highscore: \(highScore)"
        scoresStackView.isHidden = false
        
        gameView.breakoutBehavior.addWalls()
        makePaddle()
        makeBalls(lives)
        makeBlocks(blocksLeft)
    }
    
    // Called when screen is tapped when a game ends
    private func resetGame(){
        print("Screen tap after loss, NewGame.")
        
        for view in gameView.subviews{
            view.isHidden = true
        }
        gameView.breakoutBehavior.removeAll()
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
