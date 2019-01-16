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

struct game {
    let name: String
    let image: UIImage
    let info: String
}

class GameTableViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    var gameText = String()
    var url = "http://www.giantbomb.com/api/search?"
    var games = [game]()
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        tableview.separatorStyle = .none
        getGames()
    }
    
    func getGames() {
        
        startActivityIndicator()
        
        let params = ["api_key":"41a61a447f50f94f33f1f66c67e6a7eab9f9a00a", "format":"json", "query":"\(gameText)", "resources":"game", "page":"1", "limit":"10"]
        
        Alamofire.request(url, method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("There is no Response from the API call")
                    return
                }
                
                do {
                    let json = try JSON(data: response.data!)
                    
                    if let results = json["results"].array {
                        for i in 0..<results.count {
                            let result = results[i]
                            
                            if let name = result["name"].string {
                                if let info = result["deck"].string {
                                    if let imageURL = result["image"]["small_url"].string {
                                        
                                        let mainImageURL = URL(string: imageURL )
                                        let mainImageData = NSData(contentsOf: mainImageURL!)
                                        if let mainImage = UIImage(data: (mainImageData as Data?)!) {
                                            self.games.append(game.init(name: name, image: mainImage, info: info))
                                            print(self.games)
                                            
                                            self.stopActivityIndicator()
                                            self.tableview.separatorStyle = .singleLine
                                            self.tableview.reloadData()
                                            
                                        }
                                    }
                                }
                                else {
                                    print("Game has no Info")
                                }
                            }
                            else {
                                print("Game has no Name")
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
        }
    }
    
    func startActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        
        let gameName  = cell.viewWithTag(1)as!UILabel
        gameName.text = games[indexPath.row].name
        
        let gameinfo  = cell.viewWithTag(2)as!UITextView
        gameinfo.text = games[indexPath.row].info
        
        let gameImage  = cell.viewWithTag(3)as!UIImageView
        gameImage.image = games[indexPath.row].image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400.0
    }
    
}
