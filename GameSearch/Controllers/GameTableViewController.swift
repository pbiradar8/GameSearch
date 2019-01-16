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
    
    var page = 1
    var limit = 20
    var totalGames = Int()
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        tableview.separatorStyle = .none
        
        startActivityIndicator()
        getGames(page: 1)
    }
    
    func getGames(page: Int) {
        
        print("GetGames Called \(page) times")
        let params = ["api_key":"41a61a447f50f94f33f1f66c67e6a7eab9f9a00a", "format":"json", "query":"\(gameText)", "resources":"game", "page":"\(page)", "limit":"\(limit)"]
        
        Alamofire.request(self.url, method: .get, parameters: params)
                .validate()
                .responseJSON { response in
                    do {
                        let json = try JSON(data: response.data!)
                        if let jsonStatusCode = json["status_code"].int {
                            if jsonStatusCode == 1 {
                                if let totalGames = json["number_of_total_results"].int {
                                    if totalGames == 0 {
                                        self.creatSimpleAlert(message: "There are no games with this names")
                                    }
                                    self.totalGames = totalGames
                                    
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
                                                            DispatchQueue.main.async {
                                                                self.tableview.reloadData()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                self.creatSimpleAlert(message: json["error"].string!)
                            }
                        }
                    } catch {
                        self.creatSimpleAlert(message: "Could not connect to game search engine")
                    }
            }
    }
    
    func creatSimpleAlert(message: String) {
        let alert = UIAlertController(title: "Uh oh..", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        self.stopActivityIndicator()
    }
    
    func startActivityIndicator() {
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        spinner.color = .blue
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func stopActivityIndicator() {
        self.spinner.isHidden = true
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == games.count - 1 {
            //We are at last cell
            startActivityIndicator()

            if games.count < totalGames {
                //Load more Games
                page = page + 1
                DispatchQueue.global().async {
                    Thread.sleep(forTimeInterval: 3)
                    self.getGames(page: self.page)
                }
            } else {
                self.stopActivityIndicator()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400.0
    }
    
}
