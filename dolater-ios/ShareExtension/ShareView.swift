//
//  ShareView.swift
//  ShareExtension
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

struct ShareView: View {
    @State var model: ShareModel = .init()

    var body: some View {
        NavigationStack {
            Form {
                Text(model.url?.absoluteString ?? "")
            }
            .navigationTitle("Save URL")
            .navigationBarTitleDisplayMode(.inline)
            .onSubmit {
                model.onSave()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        model.onCancel()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        model.onSave()
                    }
                }
            }
        }
    }
}

#Preview {
    ShareView()
}
