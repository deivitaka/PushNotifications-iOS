//
//  ViewController.swift
//  PushNotificationsApp
//
//  Created by Deivi Taka on 6/28/16.
//  Copyright © 2016 Deivi Taka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [(String, String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "NotificationCell")! as UITableViewCell
        (view.viewWithTag(1) as? UILabel)?.text = notifications[indexPath.row].0
        (view.viewWithTag(2) as? UILabel)?.text = notifications[indexPath.row].1
        
        return view
    }
    
    func addNotification(title: String, body: String) {
        DispatchQueue.main.async {
            let indexPath = [IndexPath(item: self.notifications.count, section: 0)]
            self.notifications.append((title, body))
            self.tableView.insertRows(at: indexPath, with: .bottom)
        }
    }
}
