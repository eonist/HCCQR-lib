import Cocoa
import QR_lib

open class View: NSView {
   override open var isFlipped: Bool { return true } // TopLeft orientation
   override public init(frame: CGRect) {
      super.init(frame: frame)
      Swift.print("hello world")
      self.wantsLayer = true // if true then view is layer backed
      testCreatingHCCQRImage { img in
         let imageView: NSImageView = .init(frame: .init(origin: .zero, size: img.size))
         imageView.image = img
         self.addSubview(imageView)
      }
      //      readingManyHCCQRImages()
      //      creatingManyHCCQRImages(onComplete:{images in Swift.print("images.count:  \(images.count)")})
      //      testFixingMemLeak()
   }
   /**
    * Boilerplate
    */
   public required init?(coder decoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
