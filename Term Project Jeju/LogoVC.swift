//
//  LogoVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 15/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class LogoVC: UIViewController {

    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "logo.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleToFill
        imageView.clipsToBounds = false
        imageView.image = image
        imageView.center = view.center
        
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateValue(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateValue(timer: Timer)
    {
        timer.invalidate()
        self.timer = nil
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        vc.navigationItem.hidesBackButton = true
        
        UIView.animate(withDuration: 0.75, animations: {() -> Void in
            UIView.setAnimationCurve(.easeInOut)
            self.navigationController?.pushViewController(vc, animated: true)
            UIView.setAnimationTransition(.curlUp, for: (self.navigationController?.view)!, cache: false)})
        
        guard let viewControllers = self.navigationController?.viewControllers,
            let index = viewControllers.index(of: self) else { return }
        self.navigationController?.viewControllers.remove(at: index)
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
