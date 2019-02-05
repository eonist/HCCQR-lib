
import UIKit
/**
 * Modifiers
 */
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
    * someUIImage.cgImage doesn't work so we use this
    */
   func cgImage() -> CGImage? {
      guard let ciImage = self.ciImage else {Swift.print("cgImage() - unable to get ciImage");return nil}
      let context:CIContext = CIContext.init(options: nil)
      return context.createCGImage(ciImage, from: ciImage.extent)
   }
}

/**
 * Asserter
 */
extension UIImage{
   /**
    * Asserts if an image has non black or white pixel. (aka a gray pixel)
    */
   var hasOnlyBlackAndWhiteColorMap:Bool {
//      Swift.print("hasNoneBlackOrWhiteColor")
      return hasOnlyColorMap(colorMap: [.black,.white])
   }
   /**
    * Asserts if an image has only the colors speccified in the colors array
    * ## Example:
    * hasOnlyColorMap(these: [.red,.green,.blue,.white])
    */
   func hasOnlyColorMap(colorMap:[UIColor]) -> Bool{
//      Swift.print("hasOnly")
//      Swift.print("colors:  \(colors)")
//      Swift.print("self.size:  \(self.size)")
//      Swift.print("self.scale:  \(self.scale)")
      let pixelColors = self.pixelColors
//      Swift.print("pixelColors.count:  \(pixelColors.count)")
      let condition:(UIColor) -> Bool = { color in
         let matchCondition:(UIColor) -> Bool = {
//            Swift.print("$0 \($0) color: \(color)")
            let isMatching:Bool = $0.isEqualRGBA(uiColor:color)//$0 == color//$0.isEqualWithConversion(uiColor:color)
//            Swift.print("isMatching:  \(isMatching)")
            return isMatching
         }
         let firstmatch = colorMap.first(where: matchCondition)
//         Swift.print("firstmatch:  \(firstmatch)")
//         Swift.print("firstmatch:  \(firstmatch) color: \(color)")
         return firstmatch == nil
      }
      let first = pixelColors.flatMap{$0}.first(where: condition)
//      Swift.print("first:  \(first)")
      return first == nil
   }
}
