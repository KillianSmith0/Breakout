//
//  SettingsTVC.swift
//  Breakout_V1
//
//  Created by Killian Smith on 13/04/2017.
//  Copyright © 2017 Killian Smith. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changePaddleSize(_ sender: UISlider) {
        Settings.Instance.PaddleSize = sender.value
    }
    
    @IBAction func changePaddleColorSegment(_ sender: UISegmentedControl) {
        let colorIndex = sender.selectedSegmentIndex
        let color: UIColor!
        if colorIndex == 0 {
            color = UIColor.cyan
        }else if colorIndex == 1 {
            color = UIColor.green
        }else{
            color = UIColor.red
        }
        Settings.Instance.PaddleColor = color
    }
    
    @IBOutlet weak var numOfBallsStepper: UISegmentedControl!
    @IBAction func changeBallsPerGame(_ sender: UISegmentedControl) {
        Settings.Instance.NumberOfBalls = Int(numOfBallsStepper.titleForSegment(at: numOfBallsStepper.selectedSegmentIndex)!)!
    }
    
    @IBAction func changeBallSpeed(_ sender: UISlider) {
        Settings.Instance.BallSpeed = Double(sender.value)
    }
    
    @IBOutlet weak var bricksPRLabel: UILabel!
    @IBAction func changeBricksPerRow(_ sender: UIStepper) {
        Settings.Instance.BlocksPerRow = Int(sender.value)
        bricksPRLabel.text! = "Bricks Per Row: \(Settings.Instance.BlocksPerRow)"

    }
    
    @IBOutlet weak var rowsLabel: UILabel!
    @IBAction func changeRows(_ sender: UIStepper) {
        Settings.Instance.NumberOfRows = Int(sender.value)
        rowsLabel.text = "Rows: \(Settings.Instance.NumberOfRows)"
        
    }
    
    @IBAction func resetHighScoreButton(_ sender: UIButton) {
        UserDefaults.standard.setValue(0, forKey: "highestScore")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
}
