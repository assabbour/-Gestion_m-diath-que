//
//  Genre.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//
import Vapor
import Fluent

final class Genre: Model, Content, @unchecked Sendable {

    static let schema = "genres"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Siblings(
        through: BookGenre.self,
        from: \.$genre,
        to: \.$book
    )
    var books: [Book]

    init() {}

    init(
        id: UUID? = nil,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
