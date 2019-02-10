
import UIKit
/**
 * Modifiers
 */
extension UIImage {
   /**
    * Inverts an image (black becomes white etc)
    */
   func invertedImage() -> UIImage? {
      guard let ciImage:CIImage = self.ciImage() else {Swift.print("UIImage.invertedImage() - unable to create ciImage"); return nil}//CoreImage.CIImage(cgImage: cgImage)
      guard let cgImage:CGImage = ciImage.invertedImage() else {Swift.print("unable to create cgImage");return nil}
      return UIImage(cgImage: cgImage)
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
/**
 * Parsers
 */
extension UIImage {
   /**
    * - Note: Somehow this works with retina images where scale is 2x as well
    * - Note: alternative: https://gist.github.com/giulio92/69e4f74217422154bb25d2a35d6710f8
    * - TODO: ⚠️️ cgImage or cgImage doesnt always work, try to make this more consistent
    */
   func getPixelColor(pos:CGPoint) -> UIColor? {
      guard let cgImage = self.cgImage ?? self.cgImage() else {Swift.print("getPixelColor() - unable to get cgImage");return nil}
      guard let dataProvider = cgImage.dataProvider else {Swift.print("getPixelColor() - unable to get dataProvider");return nil}
      guard let pixelData:CFData = dataProvider.data else {Swift.print("getPixelColor() - unable to get cfData");return nil}
      let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      
      //      Swift.print("pixelInfo:  \(pixelInfo)")
      return getPixelColor(pos: pos, data: data)
   }
   /**
    * Internal helper
    */
   private func getPixelColor(pos:CGPoint, data:UnsafePointer<UInt8>) -> UIColor? {
      let pixelInfo:Int = ((Int(self.size.width*self.scale) * Int(pos.y)) + Int(pos.x)) * 4
      let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
      let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
      let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
      let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
      return UIColor(red: r, green: g, blue: b, alpha: a)
   }
   /**
    * Returns color of every pixel in an image
    * - TODO: Should return optional
    */
   var pixelColors:[UIColor] {
      guard let cgImage = self.cgImage ?? self.cgImage() else {Swift.print("getPixelColor() - unable to get cgImage");return []}
      guard let dataProvider = cgImage.dataProvider else {Swift.print("getPixelColor() - unable to get dataProvider");return []}
      guard let pixelData:CFData = dataProvider.data else {Swift.print("getPixelColor() - unable to get cfData");return []}
      let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      let (width,height) = (Int(size.width), Int(size.height))
      return (0..<height).flatMap { y in
         return (0..<width).compactMap{ x in
            getPixelColor(pos: .init(x: x, y: y), data:data)
         }
      }
   }
   /**
    * someUIImage.cgImage doesn't work so we use this
    */
   func cgImage() -> CGImage? {
      guard let ciImage = self.ciImage else {Swift.print("cgImage() - unable to get ciImage");return nil}
      let context:CIContext = CIContext.init(options: nil)
      return context.createCGImage(ciImage, from: ciImage.extent)
   }
   /**
    * sometimes uiImage.ciImage just doesn't work
    */
   func ciImage() -> CIImage? {
      guard let cgImage:CGImage = self.cgImage else {Swift.print("UIImage.ciImage() - unable to create cgimage");return nil}
      return CoreImage.CIImage(cgImage: cgImage)
   }
}

extension CIImage{
   /**
    * Inverts an image (black becomes white etc)
    */
   func invertedImage() -> CGImage? {
      guard let filter = CIFilter(name: "CIColorInvert") else { Swift.print("UIImage.invertedImage() - unable to create filter");return nil }
      filter.setDefaults()
      filter.setValue(self, forKey: kCIInputImageKey)
      let context = CIContext(options: nil)
      guard let outputImage:CIImage = filter.outputImage else {Swift.print("UIImage.invertedImage() - unable to create CIImage"); return nil }
      guard let outputImageCopy:CGImage = context.createCGImage(outputImage, from: outputImage.extent) else {Swift.print("UIImage.invertedImage() - unable to create outputImageCopy"); return nil }
      return outputImageCopy
   }
}
extension CGImage{
   /**
    * Inverts an image (black becomes white etc)
    */
   func invertedImage() -> CGImage? {
      guard let filter = CIFilter(name: "CIColorInvert") else { Swift.print("UIImage.invertedImage() - unable to create filter");return nil }
      filter.setDefaults()
      filter.setValue(self, forKey: kCIInputImageKey)
      let context = CIContext(options: nil)
      guard let outputImage:CIImage = filter.outputImage else {Swift.print("UIImage.invertedImage() - unable to create CIImage"); return nil }
      guard let outputImageCopy:CGImage = context.createCGImage(outputImage, from: outputImage.extent) else {Swift.print("UIImage.invertedImage() - unable to create outputImageCopy"); return nil }
      return outputImageCopy
   }
}
