import Foundation
import QR_lib
/**
 * Enables custom colormap and custome scale
 * - Fixme: ⚠️️ maybe find a better name?
 */
public struct OutputConfig {
   let scale: Scale
   let map: ColorPallete
   init(scale: Scale, map: ColorPallete = ColorPallete.rgbColorPallete()) {
      self.scale = scale
      self.map = map
   }
   static let `default`: OutputConfig = .init(scale: (6, 2), map: ColorPallete.rgbColorPallete())
}
