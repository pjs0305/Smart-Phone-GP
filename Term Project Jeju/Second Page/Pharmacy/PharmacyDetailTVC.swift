//
//  PharmacyDetailTVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 02/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class PharmacyDetailTVC: UITableViewController {

    let postsname : [String] = ["업소명", "주소", "연락처", "등록일", "비고"]
    
    var posts : [String] = ["", "", "", "", ""]
    
    var parameters : [String] = ["dataTitle", "adres", "telNo", "regDate", "remark"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = posts[0] + " 상세 정보"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        
        return cell // as UITableViewCell
    }
}
