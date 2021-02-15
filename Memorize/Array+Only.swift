//
//  Array+Only.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 15/02/21.
//

import Foundation

extension Array {
  var only: Element? { count == 1 ? first : nil }
}
