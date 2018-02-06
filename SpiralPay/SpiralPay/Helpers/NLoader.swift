
import UIKit

enum AnimationType {
    case RoundCirclingAT
    
    func getAnimation() -> NLoaderDelegate {
        switch self {
        case .RoundCirclingAT:
            return RoundCircling()
        }
    }
}

protocol NLoaderDelegate {
    func addLayer(to layer: CALayer, with size: CGSize, color:UIColor)
}

class NLoader {
    
    private static var isLoaderShowing: Bool! = false

    private static var superContainerView: UIView?
    private static var gradientView: UIView?
    private static var containerView: UIView?
    
    private static var isLoading: Bool! = false
    
    var loaderDelegate: NLoaderDelegate?
    
    public static var shared: NLoader = NLoader()
    
    public final func startNLoader() {
        if NLoader.isLoaderShowing == true {
            return
        }
        NLoader.isLoaderShowing = true
        
        let window = UIApplication.shared.keyWindow!
        NLoader.superContainerView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height))
        NLoader.superContainerView?.backgroundColor = UIColor.clear
        
        NLoader.gradientView = UIView(frame: CGRect(x: 0, y: 0, width: NLoader.superContainerView!.frame.size.width, height: NLoader.superContainerView!.frame.size.height))
        NLoader.gradientView?.backgroundColor = UIColor.black
        NLoader.gradientView?.alpha = 0.4
        NLoader.superContainerView?.addSubview(NLoader.gradientView!);
        
        NLoader.containerView = UIView(frame: NLoader.gradientView!.frame)
        NLoader.containerView?.backgroundColor = UIColor.clear
        NLoader.superContainerView?.addSubview(NLoader.containerView!);
        
        AnimationType.RoundCirclingAT.getAnimation().addLayer(to: NLoader.containerView!.layer, with: CGSize(width: 20, height: 20), color: UIColor.white)
        
        window.addSubview(NLoader.superContainerView!)
    }
    
    public final func stopNLoader() {
        NLoader.superContainerView?.removeFromSuperview()
        NLoader.gradientView?.removeFromSuperview()
        NLoader.containerView?.removeFromSuperview()
        
        NLoader.superContainerView = nil
        NLoader.gradientView = nil
        NLoader.containerView = nil
        
        NLoader.isLoaderShowing = false
    }
    
}

//MARK: Animations

class RoundCircling: NLoaderDelegate {
    
    func addLayer(to parentLayer: CALayer, with size: CGSize, color:UIColor) {
        
        let numberOfCircles: Int = 6
        let radiusOfCircles: CGFloat = size.width/2
        let diameterOfCircles: CGFloat = size.width
        
        let animationY = CAKeyframeAnimation()
        animationY.keyPath = "transform.translation.y"
        animationY.values = [0, diameterOfCircles, 3*diameterOfCircles, 4*diameterOfCircles, 3*diameterOfCircles, diameterOfCircles, 0]
        animationY.keyTimes = [0, 0.16, 0.33, 0.50, 0.66, 0.83, 1]
        animationY.repeatCount = HUGE
        animationY.isRemovedOnCompletion = false
        animationY.duration = 2
        
        let animationX = CAKeyframeAnimation()
        animationX.keyPath = "transform.translation.x"
        animationX.values = [0, 2*diameterOfCircles, 2*diameterOfCircles, 0, -2*diameterOfCircles, -2*diameterOfCircles, 0]
        let aniXKeyTimes: [CFTimeInterval] = [0, 0.16, 0.33, 0.50, 0.66, 0.83, 1]
        animationX.keyTimes = aniXKeyTimes as [NSNumber]
        animationX.repeatCount = HUGE
        animationX.isRemovedOnCompletion = false
        animationX.duration = 2
        
        let timingFunciton = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationY.timingFunctions = [timingFunciton,timingFunciton,timingFunciton,timingFunciton,timingFunciton,timingFunciton]
        animationX.timingFunctions = [timingFunciton,timingFunciton,timingFunciton,timingFunciton,timingFunciton,timingFunciton]
        
        let durX = animationX.duration
        let beginTime = CACurrentMediaTime()
        var beginTimes = [CFTimeInterval]()
        
        for keyTime in aniXKeyTimes {
            beginTimes.append(durX*keyTime)
        }
        
        let circleContainer = CALayer()
        circleContainer.frame.size = CGSize(width: 5*diameterOfCircles, height: 5*diameterOfCircles)
        circleContainer.frame.origin = CGPoint(x: parentLayer.frame.size.width/2 - circleContainer.frame.size.width/2, y: parentLayer.frame.size.height/2 - circleContainer.frame.size.height/2)
        
        for i in 0 ..< numberOfCircles {
            let circle = CAShapeLayer()
            circle.backgroundColor = UIColor.white.cgColor
            circle.frame = CGRect(x: 2*diameterOfCircles , y: 0, width: radiusOfCircles * 2, height: radiusOfCircles * 2)
            circle.borderWidth = 0.5
            circle.cornerRadius = radiusOfCircles
            
            animationX.beginTime = beginTime + beginTimes[i]
            animationY.beginTime = beginTime + beginTimes[i]
            circle.add(animationX, forKey: "animationX")
            circle.add(animationY, forKey: "animationY")
            circleContainer.addSublayer(circle)
        }
        parentLayer.addSublayer(circleContainer)
    }
    
}
