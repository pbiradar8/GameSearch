//
//  GameTableViewController.swift
//  GameSearch
//
//  Created by Biradar, Pravin on 1/15/19.
//  Copyright © 2019 Biradar, Pravin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GameTableViewController: UITableViewController {
    
    var gameText = String()
    
    var url = "http://www.giantbomb.com/api/search/?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGames()
    }
    
    func getGames() {
        let params = ["api_key":"41a61a447f50f94f33f1f66c67e6a7eab9f9a00a", "format":"json", "query":"\(gameText)", "resources":"game"]
        
        Alamofire.request(url, method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    return
                }
                
                print(response)
        }
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
}
