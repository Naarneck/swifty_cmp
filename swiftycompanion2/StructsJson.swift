//
//  StructsJson.swift
//  swiftycompanion2
//
//  Created by Ivan Zelenskyi on 11/16/18.
//  Copyright © 2018 Ivan Zelenskyi. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id : Int
    var login : String
    var url : String
}

struct UserInfo: Decodable {
    let id : Int
    let email : String
    let login : String
    let first_name : String
    let last_name : String
    //    var url : String
    let phone : String?
    let image_url : String
    let location : String?
    let cursus_users: [CursusUser] //add optional
    let projects_users: [ProjectsUser]
}

struct ProjectsUser: Codable {
    let id, occurrence: Int
    let finalMark: Int?
    let status: Status
    let validated: Bool?
    let currentTeamID: Int?
    let project: Cursus
    let cursusIDS: [Int]
    let markedAt: String?
    let marked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, occurrence
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case currentTeamID = "current_team_id"
        case project
        case cursusIDS = "cursus_ids"
        case markedAt = "marked_at"
        case marked
    }
}

struct CursusUser: Codable {
    let grade: String?
    let level: Double
    let skills: [Skill]
    let id: Int
    let beginAt: String
    let endAt: String?
    let cursusID: Int
    let hasCoalition: Bool
    let cursus: Cursus
    
    enum CodingKeys: String, CodingKey {
        case grade, level, skills, id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case cursusID = "cursus_id"
        case hasCoalition = "has_coalition"
        case cursus
    }
}

enum Status: String, Codable {
    case finished = "finished"
    case inProgress = "in_progress"
    case parent = "parent"
    case searchingAGroup = "searching_a_group"
}

struct Skill: Codable {
    let id: Int
    let name: String
    let level: Double
}

struct Cursus: Codable {
    let id: Int
    let createdAt: String?
    let name, slug: String
    let parentID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name, slug
        case parentID = "parent_id"
    }
}
