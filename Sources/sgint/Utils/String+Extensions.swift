//
//  String+Extensions.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

extension String {
    mutating
    func appendLine(_ string: String) {
        append(string)
        append("\n")
    }
}
