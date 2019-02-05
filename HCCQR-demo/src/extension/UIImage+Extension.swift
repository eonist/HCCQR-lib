
import UIKit

extension UIImage {
   /**
    * Inverts an image (black becomes white etc)
    */
   func invertedImage() -> UIImage? {
      guard let cgImage = self.cgImage else {Swift.print("err"); return nil }
      let ciImage = CoreImage.CIImage(cgImage: cgImage)
      guard let filter = CIFilter(name: "CIColorInvert") else { Swift.print("err");return nil }
      filter.setDefaults()
      filter.setValue(ciImage, forKey: kCIInputImageKey)
      let context = CIContext(options: nil)
      guard let outputImage = filter.outputImage else {Swift.print("err"); return nil }
      guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else {Swift.print("err"); return nil }
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
    * - Note: Somehow this works with retina images where scale is 2x as well
    * - Note: alternative: https://gist.github.com/giulio92/69e4f74217422154bb25d2a35d6710f8
    */
   func getPixelColor(pos:CGPoint) -> UIColor? {
      guard let cgImage = self.cgImage() else {Swift.print("unable to get cgImage");return nil}
      guard let dataProvider = cgImage.dataProvider else {Swift.print("unable to get dataProvider");return nil}
      guard let pixelData:CFData = dataProvider.data else {Swift.print("unable to get cfData");return nil}
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
    * Returns color of every pixel in an image (strange that width isnt mapped first?)
    */
   var pixelColors:[[UIColor]] {
      let (width,height) = (Int(size.width), Int(size.height))
      return (0..<height).map { y in
         (0..<width).compactMap{ x in
            getPixelColor(pos: .init(x: x, y: y))
         }
      }
   }
   /**
    * Asserts if an image has non black or white pixel. (aka a gray pixel)
    */
   var hasNoneBlackOrWhiteColor:Bool {
      let pixelColors = self.pixelColors
      //Swift.print("pixelColors.count:  \(pixelColors.count)")
      //pixelColors.flatMap{$0}.forEach{ (color:UIColor) in Swift.print("\(color.description)")}
      let hasNoneBlackOrWhiteColor:Bool = pixelColors.flatMap{$0}.first(where: {$0 != UIColor.black || $0 != UIColor.white}) == nil
      return hasNoneBlackOrWhiteColor
   }
   /**
    * someUIImage.cgImage doesn't work so we use this
    */
   func cgImage() -> CGImage? {
      guard let ciImage = self.ciImage else {Swift.print("unable to get ciImage");return nil}
      let context:CIContext = CIContext.init(options: nil)
      return context.createCGImage(ciImage, from: ciImage.extent)
   }
}
