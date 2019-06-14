//
//  CounterLabelView.swift
//  Anagrams
//
//  Created by KPUGAME on 20/05/2019.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import UIKit

// UILabel을 상속받는 class
class CounterLabelView: UILabel
{
    // 1. label에 표시할 값
    var value: Int  = 0
    {
        // 2. 변수가 바뀔 때마다 감시하고 있다가 label을 변경
        didSet
        {
            self.text = "\(value)"+tailtext
            
            if (changecolor == true)
            {
                self.textColor = UIColor(red: 0, green: 0, blue: CGFloat(Double(value)/100.0), alpha: 1)
            }
        }
    }
    
    // 점수가 올라갈 때 한 번에 올라가지 않기 위한 변수
    var endValue : Int = 0
    var timer: Timer? = nil
    var tailtext : String! = ""
    var changecolor = false
    
    // timer에서 호출되는 메소드 매 timer even마다 value을 1 증감
    // value의 didSet에 의해서 변경을 감지하여 라벨을 변경
    @objc func updateValue(timer: Timer)
    {
        if ( endValue < value)
        {
            value -= 1
        }
        else
        {
            value += 1
        }
        
        if (endValue == value)
        {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    // 주어진 duration 동안 endValue와 value의 차이만큼 나눠서 timer event 발생
    // 점수를 1씩 증감하도록 updateValue 호출
    func setValue(newValue: Int, duration: Float) {
        endValue = newValue
        
        if timer != nil
        {
            timer?.invalidate()
            timer = nil
        }
        
        let delta = abs(endValue - value)
        if (delta != 0)
        {
            var interval = Double(duration / Float(delta))
            if interval < 0.01
            {
                interval = 0.01
            }
            
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.updateValue(timer:)), userInfo: nil, repeats: true)
        }
    }
}
