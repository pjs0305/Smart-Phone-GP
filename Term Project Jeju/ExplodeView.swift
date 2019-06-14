//
//  ExplodeView.swift
//  Anagrams
//
//  Created by KPUGAME on 23/05/2019.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import UIKit

class ExplodeView : UIView
{
    // CAEmitterLayer 변수
    private var emitter : CAEmitterLayer!
    private var texture : UIImage!
    
    // UIView class 메소드 : CALayer가 아니라 CAEmitterLayer 리턴
    override class var layerClass : AnyClass
    {
        return CAEmitterLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 파티클 표현을 위해서 emitter cell을 생성하고 설정
        emitter = self.layer as? CAEmitterLayer
        emitter.emitterSize = self.bounds.size
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
        
        texture = UIImage(named: "particle")!
        assert(texture != nil, "particle image not found")
    }
    
    func setPoint(point : CGPoint, duration : Double)
    {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.center = point
        }, completion: nil)
        
    }
    
    func emit()
    {
        let emitterCell = CAEmitterCell()
        
        emitterCell.name = "cell" // name 설정
        emitterCell.contents = texture.cgImage // contents는 texture 이미지로
        emitterCell.birthRate = 200 // 1초에 200개 생성
        emitterCell.lifetime = 0.75 // 1개 particle은 0.75초 동안 생존
        emitterCell.greenRange = 0.99
        emitterCell.greenSpeed = -0.99
        emitterCell.velocity = 160 // 셀의 속도 범위 160 - 40 ~ 160 + 40
        emitterCell.velocityRange = 40
        emitterCell.scaleRange = 0.5 // 셀크기 1.0 - 0.5 ~ 1.0 + 0.5
        emitterCell.scaleSpeed = -0.2 // 셀크기 감소 속도
        emitterCell.emissionRange = CGFloat(Double.pi * 2) // 셀 생성 방향 360도
        emitter.emitterCells = [emitterCell] // emitterCell 배열에 넣는다.
    }
    
    func stopemit()
    {
        emitter.emitterCells = []
    }
}
