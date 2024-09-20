//
//  String+Validation.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
