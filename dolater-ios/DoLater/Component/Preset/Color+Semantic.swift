//
//  Color+Semantic.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

extension Color {
    enum Semantic {
        enum Background {
            static let primary = Color(.Primitive.gray2)
            static let secondary = Color(.Primitive.white)
            static let tertiary = Color(.Primitive.black)
        }

        enum Shadow {
            static let primary = Color(.Primitive.gray3)
        }

        enum Text {
            static let primary = Color(.Primitive.black)
            static let secondary = Color(.Primitive.gray)
            static let inversePrimary = Color(.Primitive.white)
            static let alert = Color(.Primitive.red)
        }
    }
}
