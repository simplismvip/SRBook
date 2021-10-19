//
//  SRExtension+Collection.swift
//  SReader
//
//  Created by JunMing on 2021/7/13.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    subscript<T>(_ index: Index, default default: T) -> Element where T == Self.Element {
        return indices.contains(index) ? self[index] : `default`
    }
}

extension Collection where Element == String? {
    func removeSpaceAndJoin(separator: String) -> String {
        return self.unwrapAndRemoveUnwantSpaceElement().joined(separator: separator).split(separator: " ").joined(separator: " ")
    }
}

fileprivate extension Collection where Element == String? {
    func unwrapAndRemoveUnwantSpaceElement() -> [String] {
        return self
            .compactMap { $0 } // remove all nil element
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } // remove space and newline, if " " -> ""
            .filter { !$0.isEmpty } // remove "" elements
    }
}
