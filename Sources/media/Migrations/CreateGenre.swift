//
//  CreateGenre.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Fluent

struct CreateGenre: AsyncMigration {

    func prepare(on database: any Database) async throws {
        try await database.schema("genres")
            .id()
            .field("name", .string, .required)
            .unique(on: "name")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("genres").delete()
    }
}
