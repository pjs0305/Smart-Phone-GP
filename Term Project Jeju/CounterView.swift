//
//  CounterView.swift
//  ㄹㄹㄹㅁㄴㄹ
//
//  Created by KPUGAME on 10/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
@IBDesignable
class CounterView: UIView {

    struct Constants
    {
        var numberOfGlasses = 0
        let lineWidth: CGFloat = 5.0
        let arcWidth: CGFloat = 40
        
        var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    var constants : Constants = Constants()
    
    @IBInspectable var counter: Int = 0
    {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var outlineColor: UIColor = .black
    @IBInspectable var fillColor: UIColor = UIColor(red: 0, green: 0.75, blue: 1, alpha: 1)
    @IBInspectable var counterColor: UIColor = .gray
    
    override func draw(_ rect: CGRect) {
        // 콤파스를 이용해서 반지르만큼 조정한 후 두꺼운 펜으로 돌리면서 아크를 그림
        // 1. 아크 센터 설정 = 뷰의 중앙
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 2. 반지름 설정은 바운드의 max
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // 3. 아크의 시간과 끝
        let startangle : CGFloat = 3 * .pi / 4
        let endangle : CGFloat = .pi / 4
        
        // 4. 패스 설정
        let path = UIBezierPath(arcCenter: center, radius: radius/2 - constants.arcWidth/2 - 2.5, startAngle: startangle, endAngle: endangle, clockwise: true)
        
        // 5. 스트로크
        path.lineWidth = constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        // 아웃라인 그리기
        let outlinepath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 1, startAngle: startangle, endAngle: endangle, clockwise: true)
        outlinepath.addArc(withCenter: center, radius: bounds.width/2 - constants.arcWidth - 1, startAngle: endangle, endAngle: startangle, clockwise: false)
        outlinepath.lineWidth = 3.0
        outlineColor.setStroke()
        outlinepath.stroke()
    
        let angleDiff : CGFloat = 2 * .pi - startangle + endangle
        let arclengthperglass = angleDiff / CGFloat(constants.numberOfGlasses)
        let fillendangle = arclengthperglass * CGFloat(counter) + startangle
        
        let fillpath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 2.5, startAngle: startangle, endAngle: fillendangle, clockwise: true)
        fillpath.addArc(withCenter: center, radius: bounds.width/2 - constants.arcWidth + 1.0, startAngle: fillendangle, endAngle: startangle, clockwise: false)
        
        // 4 - 크로우즈패스로 설정하고 스트로크
        fillpath.close()
        fillpath.lineWidth = 5.0
        fillColor.setFill()
        fillpath.fill()
    }
    
    // 점수가 올라갈 때 한 번에 올라가지 않기 위한 변수
    var endCount : Int = 0
    var timer: Timer? = nil
    
    // timer에서 호출되는 메소드 매 timer even마다 value을 1 증감
    // value의 didSet에 의해서 변경을 감지하여 라벨을 변경
    @objc func updateValue(timer: Timer)
    {
        var term : Int = Int(Double(endCount - counter) / 100.0)
        
        if term < 1
        {
            term = 1
        }
        
        if ( endCount < counter)
        {
            counter -= term
        }
        else
        {
            counter += term
        }
        
        if (endCount == counter)
        {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    // 주어진 duration 동안 endValue와 value의 차이만큼 나눠서 timer event 발생
    // 점수를 1씩 증감하도록 updateValue 호출
    func setValue(newValue: Int, duration: Float) {
        endCount = newValue
        
        if timer != nil
        {
            timer?.invalidate()
            timer = nil
        }
        
        let delta = abs(endCount - counter)
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
