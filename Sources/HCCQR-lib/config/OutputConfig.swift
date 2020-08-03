import Foundation
import QR_lib
/**
 * Enables custom colormap and custome scale
 * - Fixme: ⚠️️ maybe find a better name?
 */
public struct OutputConfig {
   public let scale: Scale
   public let palette: ColorPalette
   /**
    * - Parameters:
    *    - scale: which colors to use in the output HCCQR
    *    - palette: screen and module scale
    */
   public init(scale: Scale, palette: ColorPalette = CType.c4.cp()) {
      self.scale = scale
      self.palette = palette
   }
   public static let `default`: OutputConfig = .init(scale: .init(6, 2), palette: CType.c4.cp())
}
