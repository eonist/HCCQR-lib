import Foundation

/**
 * DEPRECATED
 */
extension QRWriter{
   /**
    * Creates NSView with nsImage (macOS)
    * Note: Convenience method
    * - TODO: ⚠️️ Move this out of this lib and into app libs using this lib 👌
    */
   #if os(macOS)
   public static func imageView(nsImage: Image, rect: CGRect) -> NSImageView {
      let imageView:NSImageView = NSImageView(frame: rect)
      imageView.image = nsImage
      imageView.imageAlignment = .alignTopLeft
      // imageView.imageScaling = .scaleNone
      return imageView
   }
   #endif
}
/**
 * DEPRECATED
 */
extension QRWriter{
   /**
    * Creates a CIImage from str
    * - TODO: ⚠️️ this is different for mac. see deprecated code, i think its the same now
    * - Note: Generates an output image representing the input data according to the ISO/IEC 18004:2006 standard. The width and height of each module (square dot) of the code in the output image is one point.
    * - Note: Correction levels available: L 7%, M 15%, Q 25%, H 30%
    * - Note: Encoding: NSISOLatin1StringEncoding is standard but ASCII or UTF-8 works too.
    * - Important: ⚠️️ scale is calculated from module: version1 has 23 modules, if you provide size: w:46,h:46 then the scale will be 2x
    * - NOTE: allowLossyConversion: If true, then allows characters to be removed or altered in conversion. (https://developer.apple.com/documentation/foundation/nsstring/1413692-data)
    */
   public static func ciImage(str: String, size: CGSize?, ecLevel:ECLevel) throws -> CIImage {
      guard let data:Data = str.data(using: .utf8, allowLossyConversion: false) else {throw ("QRLib.QRUtil.ciImage() - Unable to create data") }
      return try ciImage(data: data, size: size, ecLevel: ecLevel)
   }
   /**
    * Creates QR image from a string
    * ## Examples:
    * let image = QRUtil.qrImage(str: "testing", size: .init(width:100,height:100))
    * - Parameter str: The message you want the QR to contain
    * - Parameter size: The size you want the QR to be
    */
   public static func qrImage(str:String, size:CGSize?, ecLevel:ECLevel = .l) throws -> Image {
      guard let ciImage:CIImage = try? QRWriter.ciImage(str: str, size: size, ecLevel:ecLevel) else { throw ("⚠️️ QRLib.QRUtil.qrImage() - Failed to create ciImage ecLevel:\(ecLevel.rawValue) str.count:\(str.count) size:\(String(describing: size)) ⚠️️") }
      let image:Image = ImageUtil.image(ciImage: ciImage)// else {Swift.print("⚠️️ QRLib.QRUtil.qrImage() - Failed to create uiImage ⚠️️");return nil}
      return image
   }
}

/**
 * - Description: Image 👉 String
 */
extension QRReader {
   #if os(iOS)
   /**
    * Returns a string for an UIImage with a QRCode
    * ## Examples:
    * qrCode(image: image)
    * - TODO: ⚠️️ rename to string(image)
    */
   public static func qrCode(image: Image) throws -> String {
      guard let ciImage:CIImage = image.ciImage ?? image.ciImage() else {throw "QRLib.QRStringUtil.qrCode() - Unable to get CIImage" }
      return try data(ciImage: ciImage)
   }
   #endif
   /**
    * Returns a string for a CIImage instance
    * - TODO: ⚠️️ check if topLeft is the same as bounds.topleft, if not you have a more use-full rectangle outline
    * - Note: there is feature.symbolDescriptor,feature.bounds,feature.topLeft,ciImage.extent(size)
    * - Note: There is also: CIDetectorAccuracyLow, which has better performance
    * - TODO: ⚠️️ rename to stringAndFrame?
    */
   public static func qrCode(ciImage: CIImage) throws -> StringAndFrame {
      guard let feature:CIQRCodeFeature = try? ciImage.qrCodeFeature() else {throw ("QRStringUtil.qrCode - Unable to create CIQRCodeFeature") }
      let qrFrame:CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
      guard let msgStr = feature.messageString else {throw "QRStringUtil.qrCode - Unable to get msgStr"}
      return (qrStr: msgStr, qrFrame: qrFrame)
   }
   /**
    * Returns a string for an CIImage with a QRCode
    * - Note: There is also: CIDetectorTypeFace
    */
   fileprivate static func qrCode(ciImage: CIImage) throws -> String {
      guard let feature:CIQRCodeFeature = try? ciImage.qrCodeFeature() else {throw "QRLib.QRUtil.qrCode() - Unable to get qrCodeFeature"}
      guard let messageString:String = feature.messageString else {throw "QRLib.QRUtil.qrCode() - Unable to get messageString"}
      return messageString
   }
}
/**
 * Type
 */
extension QRReader{
   public typealias StringAndFrame = (qrStr: String, qrFrame: CGRect)
}
/**
 * Extra
 */
extension QRReader{
   #if os(iOS)
   /**
    * Returns a string for an UIImage with a QRCode (⚠️️ New ⚠️️)
    * ## Examples:
    * - iOS provides descriptor in the cameraCapture call
    * qrCode(descriptor: descriptor)//Data()
    * - TODO: ⚠️️ rename to data(image)
    */
   public static func qrCode(descriptor:CIQRCodeDescriptor) -> Data {
      return descriptor.data
   }
   #endif
}
