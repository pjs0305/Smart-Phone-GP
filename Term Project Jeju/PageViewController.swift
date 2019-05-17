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
    var beforePageIndex : Int! = 0
    var afterPageIndex : Int! = 1
    var pageID = ["PageOne", "PageTwo"]
    
    var mainSB : UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle : nil)
    }
    
    func GetVC(identity : String!) -> UIViewController!
    {
        return self.mainSB.instantiateViewController(withIdentifier: identity)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // 인덱스가 맨 앞이면 nil
        guard pageIndex > 0 else
        {
            return nil
        }
        
        // 이전 페이지 인덱스
        pageIndex -= 1
        
        return GetVC(identity: pageID[pageIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard pageIndex < pageID.count - 1 else
        {
            return nil
        }
        
        // 다음 페이지 인덱스
        pageIndex += 1
        
        return GetVC(identity: pageID[pageIndex])
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageID.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        self.setViewControllers([GetVC(identity: pageID[0])], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
}
