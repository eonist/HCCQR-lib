import Foundation
/**
 * The idea is that ColorMap array can hold 4-colors, 8-colors, 16-colors etc
 * - Abstract: Used in the creation process
 * - Note: idx represent false = black, true = white
 * - Note: if you match the array correctly, then the color is used
 * - Note: there is also Channel map which is used to read hccqr codes
 * - Fixme: ⚠️️ Consider renaming to ColorMaps ? it's more array-esque
 */
public typealias ColorMap = [ColorMapItem]
