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
    
    @IBOutlet weak var bricksPRLabel: UILabel!
    @IBOutlet weak var rowsLabel: UILabel!
    
    @IBOutlet weak var paddleSizeSlider: UISlider!
    @IBOutlet weak var numOfBallsSTepper: UISegmentedControl!
    @IBOutlet weak var ballSpeedSlider: UISlider!
    @IBOutlet weak var bricksPerRowStepper: UIStepper!
    @IBOutlet weak var rowStepper: UIStepper!
    
    
    
    
    @IBAction func changePaddleSize(_ sender: UISlider) {
        Settings.Instance.PaddleSize = sender.value
    }
    
    @IBAction func changeBallsPerGame(_ sender: UISegmentedControl) {
        Settings.Instance.NumberOfBalls = Int(numOfBallsSTepper.titleForSegment(at: numOfBallsSTepper.selectedSegmentIndex)!)!
    }
    
    @IBAction func changeBallSpeed(_ sender: UISlider) {
        Settings.Instance.BallSpeed = Double(sender.value)
    }
  
    
    @IBAction func changeBricksPerRow(_ sender: UIStepper) {
        Settings.Instance.BlocksPerRow = Int(sender.value)
        bricksPRLabel.text! = "Bricks Per Row: \(Settings.Instance.BlocksPerRow)"

    }

    @IBAction func changeRows(_ sender: UIStepper) {
        Settings.Instance.NumberOfRows = Int(sender.value)
        rowsLabel.text = "Rows: \(Settings.Instance.NumberOfRows)"
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
}
