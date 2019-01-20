//import UIKit
//
//class PlaybackButtonGraphics {
//    class func imageWithFilledPolygons(_ lines: [[CGPoint]]) -> UIImage {
//        let context = CGContext(data: nil,
//                                            width: 64, height: 64,
//                                            bitsPerComponent: 8, bytesPerRow: 8*64*4,
//                                            space: CGColorSpaceCreateDeviceRGB(),
//                                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue);
//        
//        let path = CGMutablePath()
//        for linePoints in lines {
//            path.addLines(between: linePoints)
//        }
//        
//        context?.addPath(path)
//        context?.fillPath()
//
//        if let image = context?.makeImage() {
//            return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up)
//        }
//        
//        return UIImage()
//    }
//    
//    class func playButtonImage() -> UIImage {
//        return UIImage(named: "play")!
//    }
//    
//    class func nextButtonImage() -> UIImage {
//        return imageWithFilledPolygons([
//            [
//                CGPoint(x: 64, y: 32),
//                CGPoint(x: 32, y: 48),
//                CGPoint(x: 32, y: 16),
//            ], [
//                CGPoint(x: 32, y: 32),
//                CGPoint(x: 0, y: 48),
//                CGPoint(x: 0, y: 16),
//            ]])
//    }
//    
//    class func previousButtonImage() -> UIImage {
//        return imageWithFilledPolygons([
//            [
//                CGPoint(x: 32, y: 32),
//                CGPoint(x: 64, y: 48),
//                CGPoint(x: 64, y: 16),
//            ], [
//                CGPoint(x: 0, y: 32),
//                CGPoint(x: 32, y: 48),
//                CGPoint(x: 32, y: 16),
//            ]])
//    }
//    
//    class func pauseButtonImage() -> UIImage {
//        return UIImage(named: "pause")!
//    }
//}
