import CoreImage

extension CIImage {
   /**
    * CIImage -> CGImage
    */
   func cgImage() -> CGImage? {
      //      guard let ciImage: CIImage = self.ciImage else { Swift.print("cgImage() - unable to get ciImage"); return nil }
//      let context: CIContext = .init(options: nil)
      return Image.ciContext.createCGImage(self, from: self.extent)
   }
}
