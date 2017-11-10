//
//  Settings.swift
//  Breakout_V1
//
//  Created by Killian Smith on 21/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    
    static let Instance = Settings() 
    
    var PaddleColor: UIColor = UIColor.cyan {
        didSet{
            print("New paddleColor: \(PaddleColor)")
        }
    }
    
    var PaddleSize: Float = 1.0 {
        didSet{
            print("New paddleSize: \(PaddleSize*100)")
        }
    }
    var BlocksPerRow: Int = 4 {
        didSet{
            print("New BlocksPR: \(BlocksPerRow)")
        }
    }
    var NumberOfRows: Int = 3 {
        didSet{
            print("New # of Rows: \(NumberOfRows)")
        }
    }
    
    var NumberOfBalls: Int = 2 {
        didSet{
            print("New # of balls: \(NumberOfBalls)")
        }
    }
    
    var BallSpeed: Double = 1.0 {
        didSet{
            print("New ballSpeed: \(BallSpeed)")
        }
    }
    
}
