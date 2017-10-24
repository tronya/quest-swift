//
//  ViewController.swift
//  Quest
//
//  Created by Yurii Troniak on 8/31/17.
//  Copyright © 2017 Yurii Troniak. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let accessToken = AccessToken.current {
            print("access token",accessToken);
            print("access token", accessToken.authenticationToken);
            print("--------")
            getServeceAccsess(token: accessToken.authenticationToken)
        }
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])

        loginButton.center = view.center
        loginButton.center.y += 50
        view.addSubview(loginButton)
        
        
    }
    func getServeceAccsess(token:String){
        
        let url = URL(string: "\(ProjectVars.serverLink)token_auth/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(token)", forHTTPHeaderField: "access_token")
        request.httpBody = "{\n  \"access_token\": \"\(token)\"\n}".data(using: .utf8)
 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response, let data = data {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                print(statusCode)
                if (statusCode == 200) {
                    do{
                        guard let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? NSDictionary else {
                            return
                        }
                        guard let appToken = json["token"] as? String else {
                            return
                        }
                        TokenModel.appToken = appToken
                        
                    }catch {
                        print("Error with Json: \(error)")
                        
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "SwitchToMainScreen", sender: self)
                    }
                }else{
                    print("3-----------",error)
                }
                
            }
        }
        
        task.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SwitchToMainScreen" {
            let Destination = (segue.destination as! MainScreen)
            Destination.appToken = TokenModel.appToken!
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
