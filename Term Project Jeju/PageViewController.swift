//
//  PageViewController.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 16/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit


class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UITableViewDelegate, UITableViewDataSource
{
    var pageViewController : UIPageViewController!
    
    var pageIndex : Int! = 0
    var pageCount : Int! = 0
    var pageID = ["PageOne", "PageTwo"]
    
    var mainSB : UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle : nil)
    }
    
    func GetVC(index : Int!) -> UIViewController!
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: pageID[index]) as! InPvcVC
        
        vc.pageIndex = index
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! InPvcVC
        
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index -= 1
        
        return self.GetVC(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! InPvcVC
        
        var index = vc.pageIndex as Int
        
        if(index == pageID.count - 1 || index == NSNotFound)
        {
            return nil
        }
        
        index += 1
        
        return self.GetVC(index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageCount
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageCount = pageID.count
        
        self.dataSource = self
        
        self.setViewControllers([GetVC(index: 0)], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        let background = UIImage(named: "돌하르방.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleToFill
        imageView.clipsToBounds = false
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        CreateTableview()
    }
    
    
    static var myTableView : UITableView!
    static var history: [[String : String]] = []
    
    func CreateTableview()
    {
        let startx : CGFloat = self.view.frame.minX + 10
        let starty : CGFloat = self.view.frame.height * 0.6
        let displayWidth: CGFloat = self.view.frame.width - 20
        let displayHeight: CGFloat = self.view.frame.height * 0.3
        
        PageViewController.myTableView = UITableView(frame: CGRect(x: startx, y: starty, width: displayWidth, height: displayHeight))
        
        PageViewController.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryTVCell")
        PageViewController.myTableView.dataSource = self
        PageViewController.myTableView.delegate = self
        PageViewController.myTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(PageViewController.myTableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if PageViewController.history[indexPath.row].first?.key == "민박집"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MinbakDetailTVC") as! MinbakDetailTVC
            let post = MinbakMapVC.GetPost(name: PageViewController.history[indexPath.row].first!.value)
            vc.initialize(post: post?.post)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if PageViewController.history[indexPath.row].first?.key == "착한 업소"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoodDetailTVC") as! GoodDetailTVC
            let post = GoodMapVC.GetPost(name: PageViewController.history[indexPath.row].first!.value)
            vc.initialize(post: post?.post)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if PageViewController.history[indexPath.row].first?.key == "모범 음식점"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailTVC") as! FoodDetailTVC
            let post = FoodMapVC.GetPost(name: PageViewController.history[indexPath.row].first!.value)
            vc.initialize(post: post?.post)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if PageViewController.history[indexPath.row].first?.key == "심야 약국"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PharmacyDetailTVC") as! PharmacyDetailTVC
            let post = PharmacyMapVC.GetPost(name: PageViewController.history[indexPath.row].first!.value)
            vc.initialize(post: post?.post)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        print(PageViewController.history[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PageViewController.history.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PageViewController.history.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell") as! UITableViewCell
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "HistoryTVCell")
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        
        cell.textLabel?.text = PageViewController.history[indexPath.row].first?.key
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.text = PageViewController.history[indexPath.row].first?.value
        cell.detailTextLabel?.textColor = .blue
        
        return cell
    }
}
