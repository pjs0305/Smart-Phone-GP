//
//  GoodDetailTVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 02/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class GoodDetailTVC: UITableViewController {

    let postsname : [String] = ["업소명", "주소", "연락처", "업종", "영업시간", "휴무상태", "등록일"]
    
    var posts : [String] = ["", "", "", "", "", "", ""]
    
    var parameters : [String] =
        ["dataTitle", "area", "adres", "telNo", "induty", "bsnTime", "hvofSttus", "regDate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = " 상세 정보"
    }

    func initialize(post : AnyObject!)
    {
        var temps : [String] = ["", "", "", "", "", "","", ""]
        
        for i in 0..<temps.count
        {
            var str = post.value(forKey: parameters[i]) as! NSString as String
            
            str = str.replacingOccurrences(of: "<BR>", with: "\n")
            
            temps[i] = str
        }
        
        posts[0] = temps[0]
        posts[1] = temps[1] + " " + temps[2]
        posts[2] = temps[3]
        posts[3] = temps[4]
        posts[4] = temps[5]
        posts[5] = temps[6]
        posts[6] = temps[7]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodDetailTVCell", for: indexPath) as! GoodDetailTVCell
        
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
