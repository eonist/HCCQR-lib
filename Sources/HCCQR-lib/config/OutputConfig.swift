import Foundation
import QR_lib
/**
 * Enables custom colormap and custome scale
 * - Fixme: ⚠️️ maybe find a better name?
 */
public struct OutputConfig {
   let scale: Scale
   let palette: ColorPalette
   /**
    * - Parameters:
    *    - scale: which colors to use in the output HCCQR
    *    - palette: screen and module scale
    */
   init(scale: Scale, palette: ColorPalette = .cp4()) {
      self.scale = scale
      self.palette = palette
   }
   static let `default`: OutputConfig = .init(scale: .init(6, 2), palette: .cp4())
}
