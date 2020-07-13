import Foundation
/**
 * Store module & screen scale
 * - Parameters:
 *   - module: 1-module means 1qr-unit is 1x1 Pixel, 8 means 8x8 Pixel
 *   - screen: 1px means normal screen 2x mens retina screen etc
 * - Fixme: ⚠️️ make it a struct, width .scale that combines module and screen?
 */
public typealias Scale = (module: Int, screen: Int)
/**
 * - Fixme: ⚠️️ make Size a stuct, because then you can add capacity and scaledSize to it as getters in an extension
 */
public typealias Size = (width: Int, height: Int)
