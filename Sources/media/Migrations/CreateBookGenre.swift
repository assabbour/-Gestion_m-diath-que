//
//  CreateBookGenre.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Fluent

struct CreateBookGenre: AsyncMigration {

    func prepare(on database: any Database) async throws {
        try await database.schema("book_genre")
            .id()

            .field(
                "book_id",
                .uuid,
                .required,
                .references("books", "id", onDelete: .cascade)
            )

            .field(
                "genre_id",
                .uuid,
                .required,
                .references("genres", "id", onDelete: .cascade)
            )

            .unique(on: "book_id", "genre_id")

            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("book_genre").delete()
    }
}
