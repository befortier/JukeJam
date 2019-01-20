import UIKit

public final class SPStorkTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    public var isSwipeToDismissEnabled: Bool = true
    public var isTapAroundToDismissEnabled: Bool = true
    public var  showIndicator: Bool = true
    public var customHeight: CGFloat? = nil
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = SPStorkPresentationController(presentedViewController: presented, presenting: presenting)
        controller.isSwipeToDismissEnabled = self.isSwipeToDismissEnabled
        controller.isTapAroundToDismissEnabled = self.isTapAroundToDismissEnabled
        controller.showIndicator = self.showIndicator
        controller.customHeight = self.customHeight
        controller.transitioningDelegate = self
        return controller
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SPStorkPresentingAnimationController()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SPStorkDismissingAnimationController()
    }
}
