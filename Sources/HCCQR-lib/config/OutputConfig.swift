import Foundation
import QR_lib
/**
 * Enables custom colormap and custome scale
 * - Note: to find layerCount use colorPalet.layerCount
 * - Fixme: ⚠️️ maybe find a better name?
 */
public struct OutputConfig {
   public let scale: Scale
   public let cType: CType
   public let useDarkMode: Bool
   /**
    * - Parameters:
    *    - scale: which colors to use in the output HCCQR
    *    - cType: scheme and palette
    *    - useDarkMode: flip light for dark color
    */
   public init(scale: Scale, cType: CType = .c4, useDarkMode: Bool = false) {
      self.scale = scale
      self.cType = cType
      self.useDarkMode = useDarkMode
   }
}
/**
 * Extension
 */
extension OutputConfig {
   public static let `default`: OutputConfig = .init(scale: .init(6, 2), cType: .c4)
   public var palette: ColorPalette { cType.cp(useDarkMode: useDarkMode) }
}
/**
 * Utility
 */
extension OutputConfig {
   /**
    * Get HCCQR-Config based on content-length
    */
   public func hccqrConfig(contentLength: Int) throws -> HCCQRConfig {
      let numOfLayers: Int = self.palette.layerCount
      let version: Int = try HCCQRVersionUtil.version(dataCount: contentLength, qrMode: .byte, ecLevel: .l, numOfLayers: numOfLayers)
      let qrConfig: QRConfig = try .init(version, .byte, .l)
      return .init(qr: .init(qrVersion: qrConfig.version, ecLevel: qrConfig.ecLevel), output: self)
   }
}
