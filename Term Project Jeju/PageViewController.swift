//
//  PageViewController.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 16/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
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
        
        super.viewDidLoad()
        
    }
}
