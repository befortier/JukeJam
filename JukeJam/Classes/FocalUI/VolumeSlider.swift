import Foundation

class VolumeSlider: UISlider{
    
  override init(frame: CGRect){
        super.init(frame: frame)
        self.round(corners: [.topRight, .bottomRight], radius: 10)
        self.setThumbImage(UIImage(), for: .normal)
        self.alpha = 0
        self.value = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: CGPoint(x: bounds.origin.x , y: bounds.origin.y), size: CGSize(width: bounds.size.width, height: 20))
        
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    override func awakeFromNib() {
        self.setThumbImage(UIImage(), for: .normal)
        super.awakeFromNib()
    }
}
