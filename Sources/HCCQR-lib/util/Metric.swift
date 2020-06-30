import Foundation
/**
 * Store module & screen scale
 * - Parameters:
 *   - module: 1-module means 1qr-unit is 1x1 Pixel, 8 means 8x8 Pixel
 *   - screen: 1px means normal screen 2x mens retina screen etc
 * - Fixme: ⚠️️ Maybe make it a struct?
 * - Fixme: ⚠️️ Rename to Scale?
 */
public typealias Scale = (module: Int, screen: Int)
public typealias Size = (width: Int, height: Int)
