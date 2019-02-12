import UIKit

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
