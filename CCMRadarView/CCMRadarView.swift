//
//  Copyright 2014 Carlos Compean.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

@objc @IBDesignable public class CCMRadarView: UIView{
    
    //var color: UIColor = UIColor.blueColor()
    private var animating: Bool = false
    
    @IBInspectable public var reversedRadar:Bool = false{
        didSet{
            initialSetup()
        }
    }
    
    @IBInspectable public var numberOfWaves:Int = 4{
        didSet{
            initialSetup()
        }
    }
    
    @IBInspectable public var radarColor: UIColor = UIColor.blueColor() {
        didSet{
            initialSetup()
        }
    }
    
    @IBInspectable public var innerRadius: Double = 50.0 {
        didSet{
            initialSetup()
        }
    }
    
    @IBInspectable public var iconImage: UIImage?{
        didSet{
            initialSetup()
        }
    }
    
    @IBInspectable public var iconSize: CGSize = CGSizeMake(20, 20){
        didSet{
            initialSetup()
        }
    }
    
    @IBInspectable public var waveWidth: CGFloat = 2 {
        didSet{
            initialSetup()
        }
    }
    
    @IBInspectable public var maxWaveAlpha: CGFloat = 1 {
        didSet{
            initialSetup()
        }
    }
    
    public func startAnimation() {
        animating = true
        if let sublayers = layer.sublayers {
            for (index,sublayer) in (layer.sublayers as [CALayer]!).enumerate() {
                if let sublayer = sublayer as? CAShapeLayer {
                    let animation = CAKeyframeAnimation()
                    animation.keyPath = "opacity"
                    animation.values = [0,0,1,0]
                    animation.duration = 1.5
                    var beginTime:Double
                    if (!reversedRadar){
                        beginTime = (Double(animation.duration)/Double(numberOfWaves + 1)) * (Double(sublayers.count) - 1.0 - Double(index))
                    } else {
                        beginTime = (Double(animation.duration)/Double(numberOfWaves + 1)) * Double(index)
                    }
                    animation.keyTimes = [0, beginTime/animation.duration, beginTime/animation.duration, (beginTime + Double(animation.duration)/(Double(numberOfWaves) - 2.5))/animation.duration]
                    animation.delegate = self
                    sublayer.addAnimation(animation, forKey: "animForLayer\(index)")
                    sublayer.opacity = 0
                }
            }
        }
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if flag{
            if let sublayers = layer.sublayers {
                for index in 0..<sublayers.count {
                    if(index == sublayers.count - 1 && animating){
                        startAnimation()
                    } else {
                        restoreInitialAlphas()
                    }
                    
                }
            }
            
        }
    }
    
    private func restoreInitialAlphas(){
        var currentAlpha = maxWaveAlpha;
        if reversedRadar {
            for _ in 1..<numberOfWaves{
                currentAlpha /= 2.5
            }
        }
        
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            for (_,sublayer) in (self.layer.sublayers as [CALayer]!).enumerate() {
                if sublayer is CAShapeLayer {
                    sublayer.opacity = Float(currentAlpha)
                    if(self.reversedRadar){
                        currentAlpha *= 2.5
                    } else {
                        currentAlpha /= 2.5
                    }
                }
            }
        })
    }
    
    public func stopAnimation() {
        animating = false
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    override public func layoutSubviews() {
        initialSetup()
    }
    
    private func initialSetup(){
        layer.sublayers = []
        let insetOffsetDelta = (Double(CGRectGetHeight(self.layer.bounds)/2) - innerRadius) / Double(numberOfWaves)
        //let alphaVariance = (maxWaveAlpha - minWaveAlpha) / CGFloat(numberOfWaves)
        var currentInsetOffset:CGFloat = 0;
        
        var currentAlpha = maxWaveAlpha;
        if reversedRadar {
            for _ in 1..<numberOfWaves{
                currentAlpha /= 2.5
            }
        }
        
        for _ in 0..<numberOfWaves {
            let sublayer = CAShapeLayer()
            sublayer.frame = CGRectInset(self.layer.bounds, currentInsetOffset, currentInsetOffset)
            let circle = UIBezierPath(ovalInRect: CGRectInset(sublayer.bounds, waveWidth, waveWidth))
            sublayer.path = circle.CGPath
            sublayer.strokeColor = radarColor.CGColor
            sublayer.lineWidth = waveWidth
            sublayer.fillColor = UIColor.clearColor().CGColor
            sublayer.opacity = Float(currentAlpha)
            layer.addSublayer(sublayer)
            currentInsetOffset += CGFloat(insetOffsetDelta)
            if(reversedRadar){
                currentAlpha *= 2.5
            } else {
                currentAlpha /= 2.5
            }
        }
        
        if let image = iconImage {
            let imageView = UIImageView(frame: CGRectMake((self.bounds.width - iconSize.width) / 2.0, (self.bounds.height - iconSize.height) / 2.0, iconSize.width, iconSize.height))
            imageView.image = image
            self.addSubview(imageView)
        }
        
    }
}
