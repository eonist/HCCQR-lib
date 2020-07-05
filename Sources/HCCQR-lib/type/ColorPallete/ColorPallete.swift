import Foundation
/**
 * Stores many ColorMap's which makes up the pallet
 * - Note: The idea is that ColorPallete array can hold 4-colors, 8-colors, 16-colors etc
 * - Abstract: Used in the creation process
 * - Note: idx represent false = black, true = white
 * - Note: if you match the array correctly, then the color is used
 * - Note: there is also Channel map which is used to read hccqr codes
 */
public typealias ColorPallete = [ColorMap]
