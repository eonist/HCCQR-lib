import Foundation
/**
 * Encapsulates the various modes in which data can be encoded to bits, as defined by the QR Code standard. See ISO 18004:2006, 6.4.1, Tables 2 and 3 for details.
 * - Details:
 * 0001   Numeric   [0001 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 10 × charcount ]
 * 0010   Alphanumeric   [0010 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 11 × charcount ]
 * 0100   Byte encoding   [0100 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 8 × charcount ]
 * 1000   Kanji encoding   [1000 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 13 × charcount ]
 * 0011   Structured append   [0011 : 4] [ Symbol Position : 4 ] [ Total Symbols: 4 ] [ Parity : 8 ]
 * 0111   ECI   [0111 : 4] [ ECI Assignment number : variable ]
 * 0101   FNC1 in first position   [0101 : 4] [ Numeric/Alphanumeric/Byte/Kanji payload : variable ]
 * 1001   FNC1 in second position   [1001 : 4] [ Application Indicator : 8 ] [ Numeric/Alphanumeric/Byte/Kanji payload : variable ]
 * 0000   End of message   [0000 : 4]
 * - Description:
 * 0001   Numeric encoding (10 bits per 3 digits)
 * 0010   Alphanumeric encoding (11 bits per 2 characters)
 * 0100   Byte encoding (8 bits per character)
 * 1000   Kanji encoding (13 bits per character)
 * 0011   Structured append (used to split a message across multiple QR symbols)
 * 0111   Extended Channel Interpretation (select alternate character set or encoding)
 * 0101   FNC1 in first position (see Code 128 for more information)
 * 1001   FNC1 in second position
 * 0000   End of message (Terminator)
 * - Note: good primer: https://en.wikipedia.org/wiki/QR_code
 * - Note: .rawValue = Bits in mode
 */
public enum QRMode: Int,CaseIterable{
   case numeric = 0x01
   case alphaNumeric = 0x02
   case byte = 0x04
}
