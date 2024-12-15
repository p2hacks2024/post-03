//
//  View+BindingSync.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

extension View {
    func sync<T: Equatable>(_ lhs: Binding<T>, _ rhs: Binding<T>) -> some View {
        onChange(of: lhs.wrappedValue) { _, newValue in
            rhs.wrappedValue = newValue
        }
        .onChange(of: rhs.wrappedValue) { _, newValue in
            lhs.wrappedValue = newValue
        }
    }

    func sync<T: Equatable>(_ binding: Binding<T>, _ focusState: FocusState<T>.Binding) -> some View {
        onChange(of: binding.wrappedValue) { _, newValue in
            focusState.wrappedValue = newValue
        }
        .onChange(of: focusState.wrappedValue) { _, newValue in
            binding.wrappedValue = newValue
        }
    }
}
