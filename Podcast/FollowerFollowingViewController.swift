//
//  FollowerFollowingViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 9/10/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

/**
 * This view controller is for both displaying your followers and whom you follow.
 */

import UIKit

class FollowerFollowingViewController: UIViewController {
    
    var usersTableView: UITableView!
    
    var users: [SearchUser]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
