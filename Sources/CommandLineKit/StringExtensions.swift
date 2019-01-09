/*
 * StringExtensions.swift
 * Copyright (c) 2014 Ben Gollmer.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* Required for localeconv(3) */
#if os(OSX)
  import Darwin
#elseif os(Linux)
  import Glibc
#endif

internal extension String {
  /* Retrieves locale-specified decimal separator from the environment
   * using localeconv(3).
   */
  private func _localDecimalPoint() -> Character {
    guard let locale = localeconv(), let decimalPoint = locale.pointee.decimal_point else {
      return "."
    }

    return Character(UnicodeScalar(UInt8(bitPattern: decimalPoint.pointee)))
  }

  /**
   * Attempts to parse the string value into a Double.
   *
   * - returns: A Double if the string can be parsed, nil otherwise.
   */
  func toDouble() -> Double? {
    let decimalPoint = String(self._localDecimalPoint())
    guard decimalPoint == "." || self.range(of: ".") == nil else { return nil }
    let localeSelf = self.replacingOccurrences(of: decimalPoint, with: ".")
    return Double(localeSelf)
  }

  /**
   * Pads a string to the specified width.
   *
   * - parameter toWidth: The width to pad the string to.
   * - parameter by: The character to use for padding.
   *
   * - returns: A new string, padded to the given width.
   */
  func padded(toWidth width: Int, with padChar: Character = " ") -> String {
    var s = self
    var currentLength = self.count

    while currentLength < width {
      s.append(padChar)
      currentLength += 1
    }

    return s
  }

  /**
   * Wraps a string to the specified width.
   *
   * This just does simple greedy word-packing, it doesn't go full Knuth-Plass.
   * If a single word is longer than the line width, it will be placed (unsplit)
   * on a line by itself.
   *
   * - parameter atWidth: The maximum length of a line.
   * - parameter wrapBy:  The line break character to use.
   * - parameter splitBy: The character to use when splitting the string into words.
   *
   * - returns: A new string, wrapped at the given width.
   */
  func wrapped(atWidth width: Int, wrapBy: Character = "\n", splitBy: Character = " ") -> String {
    var s = ""
    var currentLineWidth = 0

    for word in self.split(separator: splitBy) {
      let wordLength = word.count

      if currentLineWidth + wordLength + 1 > width {
        /* Word length is greater than line length, can't wrap */
        if wordLength >= width {
          s += word
        }

        s.append(wrapBy)
        currentLineWidth = 0
      }

      currentLineWidth += wordLength + 1
      s += word
      s.append(splitBy)
    }

    return s
  }
}
