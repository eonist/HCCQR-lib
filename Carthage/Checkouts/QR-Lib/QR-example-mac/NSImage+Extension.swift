import Cocoa

extension NSImage{
   /**
    * creates cgimage from nsimage
    * - Important: ⚠️️ we use autoreleasepool{} or else there will be memory leakage
    */
   var cgImage: CGImage? {
      return autoreleasepool {
         return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
      }
   }
   var ciImage:CIImage? {
      guard let cgImg:CGImage = self.cgImage else {Swift.print("unable to convert to cgImage");return nil}
      let ciImg:CIImage? = CoreImage.CIImage.init(cgImage: cgImg)
      return ciImg
   }
}
