//
//  FirstViewController.swift
//  swiftycompanion2
//
//  Created by Ivan Zelenskyi on 11/6/18.
//  Copyright © 2018 Ivan Zelenskyi. All rights reserved.
//

import UIKit

struct Request : Decodable{
    let access_token : String
}

class FirstViewController: UIViewController {
    
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var notFoundImage: UIImageView!
    
    let charset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789-")
    var token : String?
    var currentUser : UserInfo?
    var data = [User(id: 23104, login: "izelensk", url: "https://cdn.intra.42.fr/users/kbovt.jpg"), User(id: 22342, login: "kbovt", url: "https://cdn.intra.42.fr/users/kbovt.jpg")]
    var placeholder : Data?
    let images = [#imageLiteral(resourceName: "im1"),#imageLiteral(resourceName: "im2"),#imageLiteral(resourceName: "im3"),#imageLiteral(resourceName: "im4")]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func getToken(completion : @escaping(_ success : Bool) -> Void){
        let uid = "91277f6f0296fb92a2ba30bc1fc505011153b9704b73f4a92f80d0006905aa7e"
        let secret = "6937c60dcf762e47cdd2cf4f3e6f437e6602628c53a343918e875318d7041e30"
        
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else { return }
        var request = URLRequest(url: url)
        
        let parameters: [String: Any] = [
            "grant_type": "client_credentials",
            "client_id": uid,
            "client_secret": secret,
            ]
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Accept" : "application/json", "Content-Type": "application/json"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error{
                print(err)
            } else if let d = data {
                do{
                    print("it is about to take token")
                    let token = try JSONDecoder().decode(Request.self, from: d)
                    print(token.access_token)
                    self.token = token.access_token
                    completion(true)
                } catch{
                    print("error")
                }
            }
        }).resume()
    }
    
    func getUsers(min : String, max : String){
        let getUsers = URL.init(string: "https://api.intra.42.fr/v2/users/?range[login]=\(min),\(max)&per_page=50")
        let bearer = "Bearer \(self.token!)"
        var request = URLRequest(url: getUsers!)
        
        request.allHTTPHeaderFields = ["Authorization" : bearer]
        URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if let err = error{
                print(err)
            } else if let d = data {
                do{
                    print(d)
                    let users = try JSONDecoder().decode([User].self, from: d)
                    print(users)
                    self.data = users
                    DispatchQueue.main.async {
                        self.notFoundView.isHidden = true
                        if self.data.isEmpty{
                            self.notFoundView.isHidden = false
                            self.notFoundImage.image = self.images[Int(arc4random_uniform(UInt32(self.images.count)))]
                        }
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
                    }
                } catch {
                    print("Error while getUsers..")
                    self.getToken(){
                        (success) -> Void in
                        if success{
                            print("retriyng with new token")
                            self.getUsers(min : min, max : max)
                        } else {
                            print("error while get token")
                        }
                    }
                }
            }
        }).resume()
    }
    
    func    getUserByXlogin(xlogin : String, completion : @escaping(_ success : Bool) -> Void){
        let getUsers = URL.init(string: "https://api.intra.42.fr/v2/users/\(xlogin)")
        let bearer = "Bearer \(self.token!)"
        var request = URLRequest(url: getUsers!)
        let secVC = self.tabBarController?.viewControllers![1] as! SecondViewController
        DispatchQueue.main.async {
            secVC.activity.startAnimating()
            secVC.activityBackground.isHidden = false
        }
        request.allHTTPHeaderFields = ["Authorization" : bearer]
        URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if let err = error{
                print(err)
            } else if let d = data {
                print(d)
                do{
                    let userInfo = try JSONDecoder().decode(UserInfo.self, from: d)
                    self.currentUser = userInfo
//                    print(self.currentUser)
                    completion(true)
                } catch {
                    print("Error while getUserbyXlogin...")
                    self.getToken(){
                        (success) -> Void in
                        if success{
                            self.getUserByXlogin(xlogin: xlogin){
                                (success) -> Void in
                                if(success){
                                    print("Successfully retried")
                                } else {
                                    print("Can't process with new token")
                                }
                            }
                        } else {
                            print("error while get token")
                        }
                    }

                }
            }
        }).resume()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            placeholder = try Data(contentsOf: URL(string: "https://cdn.intra.42.fr/users/medium_default.png")!)
        } catch {
            print("error")
        }
        tableView.rowHeight = 80
        getToken(){
            (success) -> Void in
            if success{
                print("token OK")
            } else {
                print("error while get token")
            }
        }
        let secVC = SecondViewController.init(nibName: "SecondViewController", bundle: nil)
        secVC.awakeFromNib()
    }
    
    func searchForName(name : String){
        if ((name.count) < 2) || (((name.lowercased().rangeOfCharacter(from: self.charset)) == nil)){
            return
        }
        let minRange = name.lowercased()
        let maxRange = minRange + "zzz"
        getUsers(min: minRange, max: maxRange)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ripToken(_ sender: Any) {
        self.token = "PleaseHalp!"
    }
    

}

extension   FirstViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText
        print(text)
        if text.lowercased().rangeOfCharacter(from: charset.inverted) != nil {
            print("bad")
            self.searchBar.text! = String(self.searchBar.text!.dropLast())
        } else {
            print("good")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
//            {
                self.searchForName(name: text)
//            }
        }
    }
}

extension   FirstViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        if indexPath.row  >= self.data.count{
            print("strannge error")
            return cell!
        }
        cell?.xlogin.text = self.data[indexPath.row].login
        let url = URL(string: "https://cdn.intra.42.fr/users/small_\(self.data[indexPath.row].login).jpg")
        //https://cdn.intra.42.fr/users/medium_default.png
        do {
            let data = try Data(contentsOf: url!)
            cell?.image_small.image = UIImage(data: data)
        } catch {
            cell?.image_small.image = UIImage(data: self.placeholder!)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.selectedIndex = 1
        getUserByXlogin(xlogin: (self.data[indexPath.row].login)){
            (success) -> Void in
            if(success){
                print("wow")
                let secVC = self.tabBarController?.viewControllers![1] as! SecondViewController
                let url = URL(string: (self.currentUser?.image_url)!)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    secVC.currentProject = (self.currentUser?.projects_users)!
                    secVC.email.text = self.currentUser?.email
                    secVC.login.text = self.currentUser?.login
                    secVC.lastName.text = self.currentUser?.last_name
                    secVC.firstName.text = self.currentUser?.first_name
                    secVC.image.image = UIImage(data: data!)
                    secVC.phone.text = self.currentUser?.phone
                    secVC.phone.replaceEmpty(replace: "Unknown")
                    secVC.location.text = self.currentUser?.location
                    secVC.location.replaceEmpty(replace: "Unavailable")
                    if ((self.currentUser?.cursus_users.count)! > 0) {
                        secVC.level.text = String(format:"%.2f", (self.currentUser?.cursus_users[0].level)!)
                        secVC.histogram.selectSkills(cursus: (self.currentUser?.cursus_users)!)
                    }
                    secVC.histogram.drawBackground()
                    secVC.pickerProject.reloadAllComponents()
                    secVC.activity.stopAnimating()
                    secVC.activityBackground.isHidden = true
                }
            } else {
                print("error while get token")
            }
        }
    }
}

