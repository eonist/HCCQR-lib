
import UIKit

extension UIImage {
   /**
    * invertedImage
    */
   func invertedImage() -> UIImage? {
      guard let cgImage = self.cgImage else { return nil }
      let ciImage = CoreImage.CIImage(cgImage: cgImage)
      guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
      filter.setDefaults()
      filter.setValue(ciImage, forKey: kCIInputImageKey)
      let context = CIContext(options: nil)
      guard let outputImage = filter.outputImage else { return nil }
      guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
      return UIImage(cgImage: outputImageCopy)
   }
   /**
    * Creates UIImage for size and color
    */
   static func createImage(size: CGSize, color:UIColor) -> UIImage {
      return UIGraphicsImageRenderer(size: size).image { rendererContext in
         color.setFill()
         rendererContext.fill(CGRect(origin: .zero, size: size))
      }
   }
}

extension UIImage {
   /**
    * - Note: Somehow this works with retina images where scale is 2x as wekk 🤷
    */
   func getPixelColor(pos: CGPoint) -> UIColor {
      
      let pixelData = self.cgImage!.dataProvider!.data
      let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

      let pixelInfo: Int = ((Int(self.size.width*self.scale) * Int(pos.y)) + Int(pos.x)) * 4
//      Swift.print("pixelInfo:  \(pixelInfo)")
      
      let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
      let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
      let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
      let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
      
      return UIColor(red: r, green: g, blue: b, alpha: a)
   }
   /**
    * someUIImage.cgImage doesnt work so we use this
    */
   func cgImage() -> CGImage? {
      guard let ciImage = self.ciImage else {return nil}
      let context:CIContext = CIContext.init(options: nil)
      return context.createCGImage(ciImage, from: ciImage.extent)
   }
}
