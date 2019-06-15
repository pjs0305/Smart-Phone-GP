//
//  FoodDetailTVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 02/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class FoodDetailTVC: UITableViewController {

    let postsname : [String] = ["업소명", "주소", "연락처", "업태", "메뉴", "등록일"]
    
    var posts : [String] = ["", "", "", "", "", ""]
    
    var parameters : [String] =
        ["dataTitle", "adres", "telNo", "bizcnd", "menu", "regDate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = " 상세 정보"
    }
    
    func initialize(post : AnyObject!)
    {
        print(post)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodDetailTVCell", for: indexPath) as! FoodDetailTVCell
        
        var image : UIImage!
        
        if postsname[indexPath.row] == "주소"
        {
            image = UIImage(named: "address.png")
        }
        else if postsname[indexPath.row] == "업소명"
        {
            image = UIImage(named: "name.png")
        }
        else if postsname[indexPath.row] == "연락처"
        {
            image = UIImage(named: "call.png")
        }
        else if postsname[indexPath.row] == "업종"
        {
            image = UIImage(named: "shop.png")
        }
        else if postsname[indexPath.row] == "업태"
        {
            image = UIImage(named: "shop.png")
        }
        else
        {
            image = UIImage(named: "etc.png")
        }
        cell.myimage.image = image
        
        let text = postsname[indexPath.row]
        
        let textRange = NSMakeRange(0, text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        cell.mytitle.attributedText = attributedText
        
        cell.mydetail.numberOfLines = 0
        cell.mydetail.text = posts[indexPath.row]
        
        return cell // as UITableViewCell
    }
}
