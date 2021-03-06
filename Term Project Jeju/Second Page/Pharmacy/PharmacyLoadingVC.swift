//
//  GoodLoadingVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 13/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
import MapKit
import SpriteKit

class PharmacyLoadingVC: UIViewController, XMLParserDelegate {
    
    @IBOutlet var counterview : CounterView!
    @IBOutlet var counterlabel : CounterLabelView!
    @IBOutlet var loadinglabel : CounterLabelView!
    @IBOutlet var nextbutton: UIButton!
    @IBOutlet weak var toy: UIButton!
    
    @IBAction func move(_ sender: Any) {
        self.audioController.playerEffect(name: SoundDing)
        
        self.particle.emit()
        
        let duration = Double(randomNumber(minX: 5, maxX: 10)) / 10.0
        let point = CGPoint(x:randomNumber(minX: 0, maxX: UInt32(ScreenWidth - 50) ), y : randomNumber(minX: 0, maxX: UInt32(ScreenHeight - 50) ))
        let transorm = CGAffineTransform(rotationAngle: CGFloat(randomNumber(minX: 0, maxX: 360)))
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.toy.center = point
            self.toy.transform = transorm
            self.particle.center = point
        }, completion:{ (finished: Bool) in
            self.particle.stopemit()
        }
        )
    }
    
    var particle = ExplodeView(frame: CGRect(x: ScreenWidth/2, y: ScreenHeight/2, width: 10, height: 10))
    var parser = XMLParser()
    
    // title과 date 같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var baseurl : String! = "http://data.jeju.go.kr/rest/nightpharmacy/getNightPharmacyList?serviceKey=7Z3e6MM%2BZVra4DYqS7dDT%2Bsfh%2Fw2JlIBVc4uE9Xc%2FEKVgineKHp9fvznQMmblhdNhsBaCa2S31NGHVGY2j9gLg%3D%3D&pageSize=10"
    
    var parameters : [String] =
        ["adres"/*주소*/, "dataTitle"/*업소명*/, "la"/*위도*/, "lo"/*경도*/,
            "regDate"/*작성일*/, "remark"/*비고*/, "telNo"/*연락처*/]
    
    var datas : [String: NSMutableString] = [:]
    
    var start : Bool = false
    var total : Int = 100
    var count : Int = 0
    
    var audioController : AudioController
   
    required init?(coder aDecoder: NSCoder) {
        audioController = AudioController()
        audioController.preloadAudioEffects(audioFileNames: AudioEffectfFiles)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.nextbutton.isEnabled = false
        self.view.addSubview(particle)
        
        let toyimage = UIImage(named: toylist[randomNumber(minX: 0, maxX: UInt32(toylist.count - 1))])
        toy.setImage(toyimage, for: UIControl.State.normal)
        toy.layer.zPosition = 10
        toy.center = CGPoint(x:randomNumber(minX: 0, maxX: UInt32(ScreenWidth - 50)), y : randomNumber(minX: 0, maxX: UInt32(ScreenHeight - 50)))
        particle.center = toy.center
        
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
        self.navigationItem.hidesBackButton = true
        
        counterlabel.tailtext = "%"
        counterlabel.changecolor = true
        loadinglabel.tailtext = "개의 약국을 발견하였습니다."
        
        if(PharmacyMapVC.posts.count == 0)
        {
            DispatchQueue.global(qos: .background).async {
                
                var page = 1
                while(true)
                {
                    print(self.total, self.count)
                    
                    self.beginParsing(url:self.baseurl + String("&startPage=\(page)") )
                    if self.total == self.count
                    {
                        break
                    }
                    
                    page += 1
                }
                
                while(self.counterlabel.value != 100){}
                
                DispatchQueue.main.async {
                    self.nextbutton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func Next(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PharmacyMapVC") as! PharmacyMapVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // parse 오브젝트 초기화하고 XMLParserDelegate로 설정하고 XML 파싱 시작
    func beginParsing(url : String)
    {
        parser = XMLParser(contentsOf: (URL(string:url))!)!
        
        parser.delegate = self
        parser.parse()
    }
    
    // parser가 새로운 element를 발견하면 변수를 생성한다.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        
        if (elementName as NSString).isEqual(to: "list")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            for i in 0..<parameters.count
            {
                datas[parameters[i]] = NSMutableString()
                datas[parameters[i]] = ""
            }
        }
    }
    
    // title과 pubDate를 발견하면 title1과 date에 완성한다.
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "totalCount")
        {
            total = Int(string)!
            
            DispatchQueue.main.async {
                self.counterview.constants.numberOfGlasses = self.total
            }
        }
        
        if element.isEqual(to: "pageSize")
        {
            count = PharmacyMapVC.posts.count
            
            DispatchQueue.main.async {
                self.counterview.setValue(newValue: self.count, duration: 0.5)
                let percent : Int = Int(Float(self.count) / Float(self.total) * 100.0)
                self.counterlabel.setValue(newValue: percent, duration: 0.5)
                self.loadinglabel.setValue(newValue: self.count, duration: 0.5)
            }
        }
        
        for i in 0..<parameters.count
        {
            if element.isEqual(to: parameters[i])
            {
                datas[parameters[i]]?.append(string)
            }
        }
    }
    
    // element의 끝에서 feed 데이터를 dictionary에 저장
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "list")
        {
            for i in 0..<parameters.count
            {
                if !datas[parameters[i]]!.isEqual(nil)
                {
                    elements.setObject(datas[parameters[i]]!, forKey: parameters[i] as NSCopying)
                }
            }
            
            PharmacyMapVC.posts.add(elements)
        }
    }
    
    ////
}
