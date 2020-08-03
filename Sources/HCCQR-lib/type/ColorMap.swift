import Foundation
/**
 * Stores the BoolRow that correspond to a color
 * - Abstract: Stores the bool-combination-index for the color
 * - Fixme: ⚠️️ Consider making this a struct
 * - Parameters:
 *   - idx: The array represents the layers of QRImages (true equals black, false equals white)
 *   - color: the color at the index
 */
public typealias ColorMap = (idx: BoolRow, color: Pixel)
