//
//  ViewController.swift
//  PulseSearchAnimation
//
//  Created by isa on 9.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circleView: UIView!
    var gradient : CAGradientLayer?
    
    var pulseLayers = [CAShapeLayer]()
    
    var imageView : UIImageView!
    
    @IBInspectable open var isLoaded:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        circleView.layer.cornerRadius = circleView.layer.frame.height / 2
        PulseAnimationPosition()
        createPulse()
        setupcircleViewInterface()
    }
    
    /// center circleview design
    private func setupcircleViewInterface(){
        
        let gradientStartColor = UIColor.darkGray
        let gradientEndColor = UIColor.black
        
        gradient?.removeFromSuperlayer()
        
        gradient = CAGradientLayer()
        
        guard let gradient = gradient else {
            return
        }
        
        gradient.frame = circleView.layer.bounds
        gradient.cornerRadius = circleView.layer.frame.height / 2
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        circleView.layer.insertSublayer(gradient, below: circleView.layer)
        
        let imageName = "searchPeople"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        imageView = UIImageView(image: image!)
        imageView.tintColor = UIColor.white.withAlphaComponent(0.7)
        imageView.frame = CGRect(x: circleView.frame.width/2-16, y: circleView.frame.height/2-16, width: 32, height: 32)
        
        circleView.addSubview(imageView)
        circleView.bringSubviewToFront(imageView)
        
    }
    
//    animasyonun sahneye gelişi ve gidişi
    func PulseAnimationPosition(){
        let duration = 1.0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: {
            self.moveCenter(view: self.circleView)
            self.circleView.backgroundColor = UIColor.clear
        }) { (complete) in
            if complete {
                
                UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: {
                    
                    self.imageView?.alpha = 0.3
                    self.imageView.transform =  CGAffineTransform(rotationAngle: .pi*0.1)
                })
                
                UIView.animate(withDuration: duration, delay: 7, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: {
                    self.circleView.transform = CGAffineTransform(scaleX: -1, y: -1)
                    self.circleView.alpha = 0
                }) { (_) in
                    self.pulseLayers.removeAll()
                }
            }
        }
    }
    /// Adding multiple pulse wawe
    func createPulse(){
        let circlePath = UIBezierPath(arcCenter: .zero, radius: circleView.frame.height / 2 * 3, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        for _ in 0...2{
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circlePath.cgPath
            pulseLayer.lineWidth = 2.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.strokeColor = UIColor.clear.cgColor
            pulseLayer.lineCap = .round
            pulseLayer.position = CGPoint(x: circleView.frame.size.width / 2, y: circleView.frame.size.height / 2)
            circleView.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.animatePulse(index: 2)
                }
            }
        }
        
    }
    /// Wawe animations parameters
    /// - Parameter index: Depends on how much you loop in createpulse func
    func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.lightGray.cgColor
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 1.6
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 1.6
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
        
    }

    func moveCenter(view: UIView) {
        view.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
    }
    
    func moveOutOfCenter(view: UIView) {
        view.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.height)
    }
    
    
}
