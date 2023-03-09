//
//  MakeHashable.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import Turbo

extension VisitProposal: Hashable {
    public static func == (lhs: Turbo.VisitProposal, rhs: Turbo.VisitProposal) -> Bool {
        lhs.url == rhs.url && lhs.options == rhs.options
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(options)
    }
}

extension VisitOptions: Hashable {
    public static func == (lhs: Turbo.VisitOptions, rhs: Turbo.VisitOptions) -> Bool {
        lhs.action == rhs.action && lhs.response == rhs.response
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(response)
    }
}

extension VisitResponse: Hashable {
    public static func == (lhs: VisitResponse, rhs: VisitResponse) -> Bool {
        lhs.isSuccessful == rhs.isSuccessful &&
        lhs.statusCode == rhs.statusCode &&
        lhs.responseHTML == rhs.responseHTML
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(isSuccessful)
        hasher.combine(statusCode)
        hasher.combine(responseHTML)
    }
}
