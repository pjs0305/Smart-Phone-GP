//
//  InPvcVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 02/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class InPvcVC: UIViewController {
    var pageIndex : Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Good(_ sender: Any) {
        if(GoodMapVC.posts.count == 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoodLoadingVC") as! GoodLoadingVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoodMapVC") as! GoodMapVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func Food(_ sender: Any) {
        if(FoodMapVC.posts.count == 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodLoadingVC") as! FoodLoadingVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodMapVC") as! FoodMapVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func Pharmacy(_ sender: Any) {
        if(PharmacyMapVC.posts.count == 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PharmacyLoadingVC") as! PharmacyLoadingVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PharmacyMapVC") as! PharmacyMapVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func doneToViewController(segue:UIStoryboardSegue)
    {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
