//
//  BookGenre.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Vapor
import Fluent

final class BookGenre: Model, Content, @unchecked Sendable {

    static let schema = "book_genre"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "book_id")
    var book: Book

    @Parent(key: "genre_id")
    var genre: Genre

    init() {}

    init(
        id: UUID? = nil,
        bookID: UUID,
        genreID: UUID
    ) {
        self.id = id
        self.$book.id = bookID
        self.$genre.id = genreID
    }
}
