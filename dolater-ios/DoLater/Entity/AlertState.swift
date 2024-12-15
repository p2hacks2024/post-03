//
//  AlertState.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

struct AlertState: Hashable, Sendable {
    var isPresented: Bool = false {
        didSet {
            if !isPresented {
                title = ""
                message = nil
            }
        }
    }
    var title: String = ""
    var message: String? = nil {
        didSet {
            if message != nil {
                isPresented = true
            }
        }
    }
}
