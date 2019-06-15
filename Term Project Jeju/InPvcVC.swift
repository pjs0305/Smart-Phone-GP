//
//  InPvcVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 02/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

@IBDesignable
class InPvcVC: UIViewController {
    var pageIndex : Int! = 0
    @IBOutlet weak var minbak: UIButton!
    @IBOutlet weak var good: UIButton!
    @IBOutlet weak var food: UIButton!
    @IBOutlet weak var phar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if minbak != nil
        {
        minbak.layer.cornerRadius = 10
        minbak.layer.masksToBounds = true
        minbak.layer.borderWidth = 5
        minbak.layer.borderColor = UIColor.black.cgColor
        }
        
        if good != nil
        {
        good.layer.cornerRadius = 10
        good.layer.masksToBounds = true
        good.layer.borderWidth = 5
        good.layer.borderColor = UIColor.black.cgColor
        }
        
        if food != nil
        {
        food.layer.cornerRadius = 10
        food.layer.masksToBounds = true
        food.layer.borderWidth = 5
        food.layer.borderColor = UIColor.black.cgColor
        }
        
        if phar != nil
        {
        phar.layer.cornerRadius = 10
        phar.layer.masksToBounds = true
        phar.layer.borderWidth = 5
        phar.layer.borderColor = UIColor.black.cgColor
        }
        
        self.view.backgroundColor = UIColor(white: 1, alpha: 0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Minbak(_ sender: Any) {
        if(MinbakMapVC.posts.count == 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MinbakLoadingVC") as! MinbakLoadingVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MinbakMapVC") as! MinbakMapVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
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
