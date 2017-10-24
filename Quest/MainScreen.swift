//
//  Quest
//
//  Created by Yurii Troniak on 8/31/17.
//  Copyright © 2017 Yurii Troniak. All rights reserved.
//

import UIKit
import FacebookCore

class MainScreen: UIViewController , UITableViewDataSource, UITableViewDelegate {
    var quests_list:[Quests_list] = []
    
    
    @IBOutlet var tableView: UITableView!
    
    var appToken = String()
    
    
    func queryQuests(token : String){
        let url = URL(string: "\(ProjectVars.serverLink)quests/")!
        var request = URLRequest(url: url)
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                    
                    if let quest_item = json as? [[String: AnyObject]] {
                        for quest in quest_item {
                            self.quests_list.append(Quests_list(quest: quest as NSDictionary))
                        }
                        
                        self.do_table_refresh()
                    }
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "questCell", for: indexPath) as! QuestTableViewCell
        cell.questName?.text = quests_list[indexPath.row].name
        guard let urlString = quests_list[indexPath.row].logo, let url = URL(string: urlString) else {
            return cell
        }
        cell.setImage(withURL: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let questCell = cell as? QuestTableViewCell else {
            return
        }
        questCell.cancelImageRequest()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            self.performSegue(withIdentifier: "showDetailQuest", sender: quests_list[indexPath.row])
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailQuest"{
            guard let detailVC = segue.destination as? QuestDetailController else {
                return
            }
            detailVC.quest = sender as! Quests_list
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if let token = TokenModel.appToken {
            queryQuests(token: token)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
