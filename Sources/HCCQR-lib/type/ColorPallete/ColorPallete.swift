import Foundation
/**
 * Stores many ColorMap's which makes up the pallet
 * - Note: The idea is that ColorPallete array can hold 4-colors, 8-colors, 16-colors etc
 * - Note: idx represent false = black, true = white
 * - Note: if you match the array correctly, then the color is used
 * - Fixme: ⚠️️ differentiate ColorPallet and ChannelPallet names
 */
public typealias ColorPallete = [ColorMap]
