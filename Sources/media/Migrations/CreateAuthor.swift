//
//  CreateAuthor.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Fluent

struct CreateAuthor: AsyncMigration {

    func prepare(on database: any Database) async throws {

        try await database.schema("authors")
            .id()
            .field("name", .string, .required)
            .field("country", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {

        try await database.schema("authors")
            .delete()
    }
}
