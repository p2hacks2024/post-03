//
//  DLTextField.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

struct DLTextField: View {
    private let label: String
    @Binding private var text: String
    @Binding private var isFocused: Bool
    @FocusState private var focusState: Bool

    init(_ label: String, text: Binding<String>, isFocused: Binding<Bool>) {
        self.label = label
        _text = text
        _isFocused = isFocused
        focusState = isFocused.wrappedValue
    }

    var body: some View {
        TextField(label, text: $text)
            .focused($focusState)
            .textFieldStyle(.roundedBorder)
            .sync($isFocused, $focusState)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var isFocused: Bool = false

    DLTextField("Text Field", text: $text, isFocused: $isFocused)
}
