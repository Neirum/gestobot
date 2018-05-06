//
//  GBSettingsViewController.swift
//  Gestobot
//
//  Created by user on 9/25/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import UIKit

class GBSettingsViewController: UIViewController {

    @IBOutlet private weak var scaleLabel: UILabel!
    @IBOutlet weak var robotIdField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    public var areaScale: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        updateScaleLabel()
    }
    
    // MARK: - Actions
    @IBAction func addRobot(_ sender: Any) {
        
    }
    
    @IBAction func robotIdJoin(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func plusButtonDidTapped(_ sender: GBRoundButton) {
        if areaScale < 8 {
            areaScale += 1
            updateScaleLabel()
        }
    }
    
    @IBAction func minusButtonDidTapped(_ sender: GBRoundButton) {
        if areaScale > 2 {
            areaScale -= 1
            updateScaleLabel()
        }
    }

    // MARK: - Private
    private func updateScaleLabel() {
        scaleLabel.text = "\(areaScale)x\(areaScale)"
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension GBSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView .dequeueReusableCell(withIdentifier: "reusableRobotCell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reusableRobotCell")
        }
        
        cell?.textLabel?.text = "Cool robot"
        cell?.textLabel?.textColor = .white
        cell?.backgroundColor = .darkBlue
        return cell!
    }
    
}
