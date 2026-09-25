//
//  Author.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//
import Vapor
import Fluent

final class Author: Model, Content, @unchecked Sendable {

    static let schema = "authors"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "country")
    var country: String

    @Children(for: \.$author)
    var books: [Book]

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        country: String
    ) {
        self.id = id
        self.name = name
        self.country = country
    }
}
