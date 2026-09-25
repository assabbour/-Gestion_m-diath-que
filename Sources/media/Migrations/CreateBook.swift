//
//  CreateBook.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Fluent

struct CreateBook: AsyncMigration {

    func prepare(on database: any Database) async throws {

        try await database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("year", .int, .required)
            .field("pages", .int, .required)

            // Clé étrangère vers authors
            .field(
                "author_id",
                .uuid,
                .required,
                .references("authors", "id")
            )
            .create()
    }

    func revert(on database: any Database) async throws {

        try await database.schema("books")
            .delete()
    }
}
