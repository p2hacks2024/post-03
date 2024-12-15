//
//  MockTaskPoolRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

final actor MockTaskPoolRepository: TaskPoolRepositoryProtocol {
    init() {}

    func getPools() async throws -> [Components.Schemas.TaskPool] {
        Components.Schemas.TaskPool.mocks
    }

    func getPool(id: Components.Parameters.id) async throws -> Components.Schemas.TaskPool {
        .mockActive
    }
}
