//
//  PharmacyDetailTVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 02/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class MinbakDetailTVC: UITableViewController {

    let postsname : [String] = ["업소명", "주소"]
    
    var posts : [String] = ["", ""]
    
    var parameters : [String] = ["name", "addr"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = " 상세 정보"
    }
    
    func initialize(post : AnyObject!)
    {
        for i in 0..<posts.count
        {
            var str = post.value(forKey: parameters[i]) as! NSString as String
            
            str = str.replacingOccurrences(of: "<BR>", with: "\n")
            
            posts[i] = str
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MinbakDetailTVCell", for: indexPath) as! MinbakDetailTVCell
        
        var image : UIImage!
        
        if postsname[indexPath.row] == "주소"
        {
            image = UIImage(named: "address.png")
        }
        else if postsname[indexPath.row] == "업소명"
        {
            image = UIImage(named: "name.png")
        }
        cell.myimage.image = image
        
        cell.mytitle.text = postsname[indexPath.row]
        cell.mydetail.numberOfLines = 0
        cell.mydetail.text = posts[indexPath.row]
        
        return cell // as UITableViewCell
    }
}
