//
//  File.swift
//  IsometrikStream
//
//  Created by Appscrip 3Embed on 19/02/25.
//

import SwiftData
import Foundation

class GiftDataPersistence {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init() throws {
        let schema = Schema([CachedGiftModel.self, CachedGiftCategoryModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            print("Failed to create ModelContainer: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Gift Category Operations
    
    func saveGiftCategories(_ categories: [CachedGiftCategoryModel]) throws {
        for category in categories {
            modelContext.insert(category)
        }
        try modelContext.save()
    }
    
    func fetchGiftCategories() throws -> [CachedGiftCategoryModel] {
        let descriptor = FetchDescriptor<CachedGiftCategoryModel>()
        return try modelContext.fetch(descriptor)
    }
    
    func deleteAllGiftCategories() throws {
        let descriptor = FetchDescriptor<CachedGiftCategoryModel>()
        let existingCategories = try modelContext.fetch(descriptor)
        
        for category in existingCategories {
            modelContext.delete(category)
        }
        try modelContext.save()
    }
    
    // MARK: - Gift Operations
    
    func saveGifts(_ gifts: [CachedGiftModel]) throws {
        for gift in gifts {
            modelContext.insert(gift)
        }
        try modelContext.save()
    }
    
    func fetchGifts() throws -> [CachedGiftModel] {
        let descriptor = FetchDescriptor<CachedGiftModel>()
        return try modelContext.fetch(descriptor)
    }
    
    func fetchGifts(forGroupId groupId: String) throws -> [CachedGiftModel] {
        let predicate = #Predicate<CachedGiftModel> { gift in
            gift.giftGroupId == groupId
        }
        var descriptor = FetchDescriptor<CachedGiftModel>()
        descriptor.predicate = predicate
        descriptor.sortBy = [SortDescriptor(\CachedGiftModel.id)]
        
        return try modelContext.fetch(descriptor)
    }
    
    func deleteAllGifts() throws {
        let descriptor = FetchDescriptor<CachedGiftModel>()
        let existingGifts = try modelContext.fetch(descriptor)
        
        for gift in existingGifts {
            modelContext.delete(gift)
        }
        try modelContext.save()
    }
    
    // MARK: - Combined Operations
    
    func clearAllData() throws {
        try deleteAllGiftCategories()
        try deleteAllGifts()
    }
}

