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
    var PaddleColor: UIColor = .cyan
    var PaddleSize: Float = 1.0
    var BlocksPerRow: Int = 4
    var NumberOfRows: Int = 3
    var NumberOfBalls: Int = 2
    var BallSpeed: Double = 1.0
}
