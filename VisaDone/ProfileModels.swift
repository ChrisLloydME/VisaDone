//
//  ProfileModels.swift
//  VisaDone
//

import SwiftUI

struct ProfileIdentity: Equatable {
    var displayName: String
    var handle: String
    var pronouns: String
    var bio: String
    var location: String
    var joinLabel: String
    var followers: Int
    var following: Int
    var avatarImage: String

    static let fixture = ProfileIdentity(
        displayName: "Nora Hale",
        handle: "@nora.hale",
        pronouns: "she/her",
        bio: "Product designer, slow traveller, keeper of very thorough PDFs. I write about the quiet parts of the journey.",
        location: "Berlin, Germany",
        joinLabel: "Member since 2023",
        followers: 2_846,
        following: 212,
        avatarImage: "profileAvatar"
    )

    var handleLine: String {
        "\(handle) · \(pronouns)"
    }
}

enum ProfileSetting: String, CaseIterable, Identifiable {
    case account
    case privacy
    case notifications
    case data
    case help

    var id: String { rawValue }

    var title: String {
        switch self {
        case .account: "Account"
        case .privacy: "Privacy"
        case .notifications: "Notifications"
        case .data: "Data & Sharing"
        case .help: "Help & Support"
        }
    }

    var subtitle: String {
        switch self {
        case .account: "Name, handle and sign-in"
        case .privacy: "Profile visibility"
        case .notifications: "Replies and updates"
        case .data: "Saved data and permissions"
        case .help: "FAQs and guidance"
        }
    }

    var systemImage: String {
        switch self {
        case .account: "person.crop.circle"
        case .privacy: "lock.shield"
        case .notifications: "bell.badge"
        case .data: "externaldrive.badge.icloud"
        case .help: "questionmark.circle"
        }
    }

    var sheetSubtitle: String {
        switch self {
        case .account: "The details attached to your VisaDone profile."
        case .privacy: "Decide what the community can see."
        case .notifications: "Choose which little updates reach you."
        case .data: "Review how this local prototype handles your information."
        case .help: "A few answers, without a ticket queue."
        }
    }
}

enum ProfileCollectionKind: String, Identifiable {
    case posts
    case favorites

    var id: String { rawValue }

    var title: String {
        switch self {
        case .posts: "All posts"
        case .favorites: "Saved stories"
        }
    }

    var subtitle: String {
        switch self {
        case .posts: "Everything you've shared with the VisaDone community."
        case .favorites: "The guides and stories you've kept for later."
        }
    }

    var systemImage: String {
        switch self {
        case .posts: "square.text.square"
        case .favorites: "bookmark"
        }
    }
}

enum ProfileFixtures {
    static let initialFavoriteIDs: Set<String> = [
        "uk-folder-worked",
        "document-organisation",
        "honeymoon-timeline",
        "us-road-trip",
        "uk-visitor-differently",
        "appointment-prep-guide"
    ]

    static let savedLabels: [String: String] = [
        "uk-folder-worked": "Saved 2d ago",
        "document-organisation": "Saved 4d ago",
        "honeymoon-timeline": "Saved 1w ago",
        "us-road-trip": "Saved 2w ago",
        "uk-visitor-differently": "Saved 3w ago",
        "appointment-prep-guide": "Saved 1mo ago"
    ]

    static let authoredPosts: [DiscoveryPost] = [
        DiscoveryPost(
            id: "profile-schengen-folder",
            format: .guide,
            region: .schengen,
            title: "The Schengen folder I wish I'd built sooner",
            summary: "The order, the tabs, and the one-page index that made my application easier to live with.",
            body: """
            My first folder was a tote bag with good intentions. Everything was in there; nothing was findable. The version I finally trusted was much more boring.

            I started with a single index page: date, document, and page number. Behind it, six tabs — identity, trip, money, work, accommodation, and copies. Anything that explained a mismatch went directly behind the document it explained, not into a separate pile.

            The rule that helped most was "one question, one place." If I found myself wondering where something lived, I added it to the index. By the time I printed the folder for the appointment, I could answer almost any question without emptying the bag.

            None of this is official advice. It was just the system that let me stop re-checking the same page long enough to get some sleep.
            """,
            coverImage: "coverTravelDesk",
            coverAspectRatio: 0.8,
            tags: ["Documents", "Schengen"],
            author: .you,
            timeLabel: "Apr 8",
            likeCount: 428,
            commentCount: 36,
            readMinutes: 6,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-vfs-appointment",
            format: .guide,
            region: .schengen,
            title: "What my VFS appointment actually looked like",
            summary: "The queue, the small kindnesses, and the one document I was glad I had printed twice.",
            body: """
            I had imagined a room of silent, serious people. What I found was a queue that moved faster than the website suggested, a security guard with very clear directions, and a couple in front of me quietly rehearsing the dates of their trip.

            Inside, the person at the window was kind and efficient. They asked for the folder, took a few pages, and asked one question about a hotel booking I had almost left at home. I had printed it twice by accident. That accident saved me a week.

            I left with a receipt, a slightly shaky signature, and a feeling that the hardest part was not the conversation but the waiting before it. If you are going soon: take the extra copy, arrive with time to spare, and bring water.

            This was my own experience at one appointment. Requirements and processes vary, so always follow the current instructions for your own application.
            """,
            coverImage: "coverSigning",
            coverAspectRatio: 1.25,
            tags: ["Appointment", "Experience"],
            author: .you,
            timeLabel: "Apr 2",
            likeCount: 312,
            commentCount: 29,
            readMinutes: 5,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-iceland-itinerary",
            format: .guide,
            region: .schengen,
            title: "The Iceland itinerary I keep sending to friends",
            summary: "A nine-day south-coast loop with weather buffers and no 6 a.m. starts.",
            body: """
            This is the version I send when someone asks for the itinerary, not the highlight reel. It is built around three bases, two flexible days, and the assumption that the weather will change at least once.

            We started with two nights near Reykjavík, moved east along the south coast, and finished with a slow morning before the flight home. The distance looks modest on a map. The light, the stops, and the occasional road closure make it feel generous.

            The most useful thing we packed was a thermos. The second most useful was a printed list of the names of the places we were staying. I also kept the booking confirmations offline in one folder, which made check-in feel less like a scavenger hunt.

            Leave one day unplanned. On ours, we found a hot spring with almost nobody there and stayed until our fingers wrinkled.
            """,
            coverImage: "coverIcelandSkogafoss",
            coverAspectRatio: 1.5,
            tags: ["Iceland", "Itinerary"],
            author: .you,
            timeLabel: "Mar 24",
            likeCount: 356,
            commentCount: 31,
            readMinutes: 8,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-cover-letter",
            format: .guide,
            region: .schengen,
            title: "A cover letter that sounded like me",
            summary: "One page, plain language, and a structure that kept the important facts in view.",
            body: """
            The cover letters I found online all sounded like they were written by the same very formal person. Mine needed to sound like me, without becoming an essay.

            The structure that worked was simple. One short paragraph on the trip and its dates. One on why I was going and what I was returning to. One on the documents I had included. Then a plain closing line. No adjectives doing the work that evidence should do.

            I wrote it once, left it overnight, and cut it by a third in the morning. The final page had more white space and more useful information. It also gave me a document I could check against the rest of the application without rereading every booking.

            Every application is different. This is just the shape that made mine feel clear.
            """,
            coverImage: "coverLaptopNotes",
            coverAspectRatio: 1.5,
            tags: ["Cover letter", "Documents"],
            author: .you,
            timeLabel: "Mar 18",
            likeCount: 228,
            commentCount: 18,
            readMinutes: 4,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-accommodation-proof",
            format: .guide,
            region: .schengen,
            title: "Proof of accommodation: the paper trail I kept",
            summary: "The quiet pile of confirmations that answered more questions than I expected.",
            body: """
            I nearly treated accommodation as a single booking confirmation. In the end, it was a small paper trail: the reservation, the cancellation terms, a map showing where it sat relative to the rest of the trip, and the name of the person who would meet us.

            The map was a last-minute addition. It helped me notice that one of our bookings was on the other side of the city from where I thought. That was a useful discovery before the trip, not during it.

            I kept all confirmations in one place and labelled them with the nights they covered. For the days we stayed with friends, I kept a short invitation note with their address and the dates. Nothing dramatic. Just enough for the trip to make sense on paper.

            Requirements vary. Bring what your own application asks for, plus whatever helps the story stay legible to someone reading it for the first time.
            """,
            coverImage: "coverNotes",
            coverAspectRatio: 1.25,
            tags: ["Accommodation", "Documents"],
            author: .you,
            timeLabel: "Mar 9",
            likeCount: 187,
            commentCount: 23,
            readMinutes: 5,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-uk-visit",
            format: .guide,
            region: .unitedKingdom,
            title: "What I changed for my second UK visitor application",
            summary: "The second time around, I prepared in layers: facts, explanations, then everything else.",
            body: """
            The first time, I prepared in order of worry. The second time, I prepared in order of usefulness.

            Layer one was the facts: dates, booking, work, money, the reason for the trip. Layer two was a short explanation anywhere a fact might look incomplete. Layer three was context I could hand over if it was relevant, but did not need to lead with.

            The folder got thinner. The story got clearer. I also printed a small index page, mostly for myself, and it made the final check calm enough to be useful.

            The application was mine, with its own particular details. Take what is useful from other people's experiences, but let the current official checklist decide what belongs in your folder.
            """,
            coverImage: "coverLondonAerial",
            coverAspectRatio: 1.5,
            tags: ["Documents", "Planning"],
            author: .you,
            timeLabel: "Feb 28",
            likeCount: 261,
            commentCount: 32,
            readMinutes: 7,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-kirkjufell",
            format: .photo,
            region: .schengen,
            title: "Kirkjufell, before the weather turned",
            summary: "The mountain appeared for ninety seconds. I nearly missed it.",
            body: """
            We had been sitting in the car for an hour with the engine off, watching a band of cloud swallow the summit. The forecast promised a break around ten. It arrived eighteen minutes early.

            I took this through the open window with cold hands and no expectation of a masterpiece. Then the cloud came back, and the mountain was gone for the rest of the day. We drove on to a bakery that was almost closed and bought the last two cinnamon buns.

            That is the whole story. Fine light, a brief window, and breakfast rescued at the last minute.
            """,
            coverImage: "coverIcelandKirkjufell",
            coverAspectRatio: 1.5,
            tags: ["Iceland", "Photography"],
            author: .you,
            timeLabel: "Feb 20",
            likeCount: 512,
            commentCount: 16,
            readMinutes: nil,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-b2-interview",
            format: .guide,
            region: .unitedStates,
            title: "Notes from a calm B-2 interview",
            summary: "What the waiting room felt like, and the four questions that still stick with me.",
            body: """
            The room was smaller and more ordinary than the version in my head. A row of chairs, a ticket screen, and everyone holding a folder a little too tightly.

            When my number came up, the officer asked why I was travelling, what I did, who was paying for the trip, and what I was coming back to. I answered each one with the shortest true version. I had the folder ready, but I did not reach for it unless asked.

            What helped beforehand was writing down the five facts I wanted to be clear about, not memorising a speech. I could still feel my heart going, but my answers were mine.

            The conversation was short. The relief lasted the whole walk to the station. Experiences differ, so I would not treat my questions as a script for anyone else's interview.
            """,
            coverImage: "coverNYCEmpire",
            coverAspectRatio: 0.8,
            tags: ["Interview", "Preparation"],
            author: .you,
            timeLabel: "Feb 12",
            likeCount: 296,
            commentCount: 27,
            readMinutes: 6,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-glacier",
            format: .photo,
            region: .schengen,
            title: "Jökulsárlón in soft rain",
            summary: "Ice, rain, and the best kind of silence.",
            body: """
            The rain was light enough that we did not notice it until our sleeves were soaked. The lagoon was the colour of old glass, and the icebergs moved so slowly they seemed to be part of the shore.

            We stood there longer than we meant to. A seal surfaced near the far bank, looked in our direction, and went back under. Nobody said anything. The car heater took ten minutes to forgive us.

            I like this photograph because it is almost grey. There is no drama in it, just the feeling of being very small and very awake.
            """,
            coverImage: "coverIcelandGlacier",
            coverAspectRatio: 1.0,
            tags: ["Iceland", "Nature"],
            author: .you,
            timeLabel: "Jan 28",
            likeCount: 619,
            commentCount: 23,
            readMinutes: nil,
            isExperience: false
        ),
        DiscoveryPost(
            id: "profile-copenhagen",
            format: .photo,
            region: .schengen,
            title: "Copenhagen without the checklist",
            summary: "A weekend built around bakeries, long walks, and one very sensible train pass.",
            body: """
            We arrived with one museum booking and no plan for the rest. That turned out to be the right amount of planning for a city that is lovely to walk through without trying very hard.

            The pattern became: coffee, a long loop through a neighbourhood, one bakery stop, and whatever looked interesting on the way home. We saw the harbour at sunset twice because it was on the way and because it was better than the thing we had planned.

            My favourite hour was spent on a bench watching a family load a small boat with an improbable number of bags. Nothing happened. It was perfect.
            """,
            coverImage: "coverCopenhagen",
            coverAspectRatio: 0.8,
            tags: ["Denmark", "Weekend"],
            author: .you,
            timeLabel: "Jan 16",
            likeCount: 244,
            commentCount: 15,
            readMinutes: nil,
            isExperience: false
        )
    ]
}

struct ProfileVisaExperience: Identifiable {
    let id: String
    let image: String
    let label: String
    let detail: String

    static let samples = [
        ProfileVisaExperience(id: "gb", image: "visaFlagGB", label: "UK", detail: "United Kingdom · Visitor visa application"),
        ProfileVisaExperience(id: "us", image: "visaFlagUS", label: "US", detail: "United States · B1/B2 visa application"),
        ProfileVisaExperience(id: "fr", image: "visaFlagFR", label: "France", detail: "France · Schengen application experience shared"),
        ProfileVisaExperience(id: "is", image: "visaFlagIS", label: "Iceland", detail: "Iceland · Travel and visa experience shared")
    ]
}
