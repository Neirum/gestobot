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
    
    private let robotsController = GBDependencies.shared.robotsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        updateScaleLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if robotsController.robots.isEmpty {
            robotsController.addRobot(robotId: "robo_kop")
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }
    
    // MARK: - Actions
    @IBAction func addRobot(_ sender: Any) {
        addNewRobot()
    }
    
    @IBAction func robotIdJoin(_ sender: UITextField) {
        addNewRobot()
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
    
    private func addNewRobot() {
        robotIdField.resignFirstResponder()
        if let newRobotId = robotIdField.text {
            robotsController.addRobot(robotId: newRobotId)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
        robotIdField.text = nil
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension GBSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return robotsController.robots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reusableRobotCell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reusableRobotCell")
            cell?.textLabel?.textColor = .white
            cell?.backgroundColor = .darkBlue
        }
        
        cell?.textLabel?.text = robotsController.robots[indexPath.row].robotId
        return cell!
    }
    
}
