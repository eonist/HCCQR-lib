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
