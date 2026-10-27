//
//  DiscoveryFixtures.swift
//  VisaDone
//

import SwiftUI

// MARK: - Community members

extension DiscoveryAuthor {
    static let you = DiscoveryAuthor(
        id: "you",
        name: "Nora Hale",
        handle: "@nora.hale",
        initials: "NH",
        palette: .rose,
        bio: "Product designer, slow traveller, keeper of very thorough PDFs.",
        isFollowing: false
    )

    static let mira = DiscoveryAuthor(
        id: "mira",
        name: "Mira Lindqvist",
        handle: "@mira.lindqvist",
        initials: "ML",
        palette: .tide,
        bio: "Stockholm-based designer. Happiest on a long drive with a thermos and no fixed ETA.",
        isFollowing: true
    )

    static let daniel = DiscoveryAuthor(
        id: "daniel",
        name: "Daniel Okafor",
        handle: "@daniel.ok",
        initials: "DO",
        palette: .clay,
        bio: "London. Makes lists for the lists. Currently perfecting a folder system.",
        isFollowing: true
    )

    static let priya = DiscoveryAuthor(
        id: "priya",
        name: "Priya Raman",
        handle: "@priya.raman",
        initials: "PR",
        palette: .plum,
        bio: "Bengaluru to Amsterdam. Learning to leave a little room in the itinerary.",
        isFollowing: false
    )

    static let sofia = DiscoveryAuthor(
        id: "sofia",
        name: "Sofia Almeida",
        handle: "@sofia.almeida",
        initials: "SA",
        palette: .amber,
        bio: "Lisbon. Photographs the in-between bits: trams, tile, weather.",
        isFollowing: true
    )

    static let theo = DiscoveryAuthor(
        id: "theo",
        name: "Theo Martin",
        handle: "@theo.martin",
        initials: "TM",
        palette: .indigo,
        bio: "Lyon. Writes slowly, travels slowly, orders the second coffee.",
        isFollowing: false
    )

    static let hana = DiscoveryAuthor(
        id: "hana",
        name: "Hana Kim",
        handle: "@hana.kim",
        initials: "HK",
        palette: .rose,
        bio: "Seoul. Here for shoulder seasons, quiet museums, and window seats.",
        isFollowing: true
    )

    static let lucas = DiscoveryAuthor(
        id: "lucas",
        name: "Lucas Meyer",
        handle: "@lucas.meyer",
        initials: "LM",
        palette: .slate,
        bio: "Berlin. Plans the budget first and the route second.",
        isFollowing: false
    )

    static let amara = DiscoveryAuthor(
        id: "amara",
        name: "Amara Nwosu",
        handle: "@amara.nwosu",
        initials: "AN",
        palette: .moss,
        bio: "Toronto. First-trip stories and the small victories in between.",
        isFollowing: false
    )

    static let elena = DiscoveryAuthor(
        id: "elena",
        name: "Elena Petrova",
        handle: "@elena.petrova",
        initials: "EP",
        palette: .indigo,
        bio: "Sofia. Trying to make sense of forms without losing the plot.",
        isFollowing: false
    )

    static let noor = DiscoveryAuthor(
        id: "noor",
        name: "Noor Haddad",
        handle: "@noor.haddad",
        initials: "NH",
        palette: .amber,
        bio: "Dubai. Reader, note-taker, chronic over-preparer.",
        isFollowing: false
    )

    static let jonah = DiscoveryAuthor(
        id: "jonah",
        name: "Jonah Reed",
        handle: "@jonah.reed",
        initials: "JR",
        palette: .moss,
        bio: "Portland, Oregon. Road maps, trail snacks, and careful paperwork.",
        isFollowing: false
    )

    static let clara = DiscoveryAuthor(
        id: "clara",
        name: "Clara Bennett",
        handle: "@clara.bennett",
        initials: "CB",
        palette: .rose,
        bio: "Bristol. Weekend walks, good bakeries, one very full document folder.",
        isFollowing: true
    )

    static let mateo = DiscoveryAuthor(
        id: "mateo",
        name: "Mateo Silva",
        handle: "@mateo.silva",
        initials: "MS",
        palette: .clay,
        bio: "São Paulo. Planning slowly, travelling light.",
        isFollowing: false
    )

    static let aisha = DiscoveryAuthor(
        id: "aisha",
        name: "Aisha Rahman",
        handle: "@aisha.rahman",
        initials: "AR",
        palette: .tide,
        bio: "Manchester. Community nurse, folder person, tea enthusiast.",
        isFollowing: false
    )

    static let kenji = DiscoveryAuthor(
        id: "kenji",
        name: "Kenji Watanabe",
        handle: "@kenji.w",
        initials: "KW",
        palette: .slate,
        bio: "Tokyo. Here for cities, windows, and a decent cup of coffee.",
        isFollowing: false
    )

    static let fiona = DiscoveryAuthor(
        id: "fiona",
        name: "Fiona Walsh",
        handle: "@fiona.walsh",
        initials: "FW",
        palette: .plum,
        bio: "Dublin. Travels for weather, apparently.",
        isFollowing: false
    )

    static let ravi = DiscoveryAuthor(
        id: "ravi",
        name: "Ravi Patel",
        handle: "@ravi.patel",
        initials: "RP",
        palette: .indigo,
        bio: "Mumbai. Student visa, second attempt, better organised.",
        isFollowing: true
    )

    static let leila = DiscoveryAuthor(
        id: "leila",
        name: "Leila Karimi",
        handle: "@leila.k",
        initials: "LK",
        palette: .amber,
        bio: "Toronto. Three applications, two years, and a lot of learning.",
        isFollowing: false
    )
}

// MARK: - Bundled community feed

enum DiscoveryFixtures {
    static let posts: [DiscoveryPost] = [
        post(
            "iceland-nine-days", .guide, .schengen,
            "Iceland in nine days, without rushing",
            author: .mira, time: "18m", likes: 342, comments: 31,
            image: "coverIcelandSkogafoss", aspect: 1.5,
            summary: "A south-coast loop with weather buffers, one hot spring, and absolutely no 6 a.m. departures.",
            tags: ["Iceland", "Itinerary"], read: 8, experience: true,
            body: """
            The first version of this trip had eleven stops in seven days. The second version had nine stops in nine days. The second version was better.

            We based ourselves in three places and drove the south coast in one direction, leaving the last day empty on purpose. That empty day became the best day: a long soak, a late lunch, and a drive back to Reykjavík with no schedule. Weather moved things around twice. Nobody minded.

            A few things that made the planning easier for us: one booking spreadsheet, screenshots of every reservation, and a paper copy of the itinerary in the glovebox. We also kept the first night close to the airport and the last night close to the airport, which removed a surprising amount of stress.

            This was a holiday, not a visa. But the same idea applied: build in buffer, keep the important things together, and leave room for the trip to become itself.
            """
        ),
        post(
            "new-york-finally", .photo, .unitedStates,
            "New York, finally",
            author: .amara, time: "34m", likes: 1_284, comments: 54,
            image: "coverNYCEmpire", aspect: 0.8,
            summary: "The first trip after a three-year wait. I spent the first hour doing nothing but looking up.",
            tags: ["New York", "First trip"], experience: true,
            body: """
            I had been planning this trip for so long that the arrival felt oddly quiet. No fireworks. Just a taxi, a key handover, and a street that smelled like rain and pretzels.

            I gave myself permission not to optimise the first day. I walked until I found a park bench, sat down, and watched the city do its thing. The photo is from that afternoon, somewhere around Thirty-Fourth Street. I did not know the building's name until much later.

            The rest of the week was a mix of the things I had saved and the things I stumbled into. The best meal was a slice of pizza eaten standing up. The best view was a free one. The only real plan was breakfast.

            If you are waiting for a first trip of your own: I hope the wait ends somewhere ordinary and beautiful, like this.
            """
        ),
        post(
            "cover-letter-detail", .question, .schengen,
            "How much detail belongs in a cover letter?",
            author: .elena, time: "1h", likes: 72, comments: 19,
            summary: "Mine is one page and somehow still feels like too much. Curious how other people decide what earns a sentence.",
            tags: ["Cover letter", "Documents"],
            body: """
            I have read a dozen examples and they range from a short, polite paragraph to a full day-by-day explanation of a two-week trip. I understand that the point is clarity, but there seems to be very little agreement about what "clear" means.

            Mine currently explains the purpose of the trip, the dates, where I am staying, and how the trip fits with my work. I have left out most of the personal context because it felt like padding. Now I am wondering if it reads as too bare.

            Not looking for a definitive answer, just curious what worked for people who have actually done this before.
            """
        ),
        post(
            "kirkjufell-morning", .photo, .schengen,
            "The morning Kirkjufell disappeared",
            author: .sofia, time: "1h", likes: 486, comments: 12,
            image: "coverIcelandKirkjufell", aspect: 1.5,
            summary: "We drove out before sunrise. The mountain had other plans.",
            tags: ["Iceland", "Photography"],
            body: """
            The forecast said clear. The mountain said otherwise. We sat in the car with the engine off and watched the top disappear into a thick band of cloud, then come back for about ninety seconds, then vanish again.

            I took this when the light briefly found the snow. It is not the postcard shot I had in my head, but it is the one that reminds me of what that morning actually felt like: cold hands, a thermos that was already empty, and the absolute quiet.

            We went back the next day and the whole scene was flat and ordinary. Which feels like the real lesson of travelling with a camera. The conditions are the photograph, not the location.
            """
        ),
        post(
            "uk-folder-worked", .guide, .unitedKingdom,
            "The UK visitor visa folder that finally worked",
            author: .ravi, time: "2h", likes: 267, comments: 38,
            image: "coverTravelDesk", aspect: 0.8,
            summary: "Not a template, not official advice — just the order and cross-references that made my own application easier to review.",
            tags: ["Visitor visa", "Documents"], read: 7, experience: true,
            body: """
            My first attempt at organising documents was a large pile in a tote bag. It worked in the sense that everything was in the bag. It did not work in the sense that I could find anything without emptying the bag onto the floor.

            The second time, I built the folder around questions rather than categories. Why am I going? When? Who is paying? Where will I stay? What brings me back? Each question got a section with the relevant evidence behind it. That meant some documents were referenced twice, which was fine.

            At the front I put a single index page. It listed each section, the documents inside, and the page numbers. I printed two copies of the index. One stayed in the folder; one stayed with me.

            I also stopped trying to make everything look perfect. Original bank printouts, a hotel confirmation, and a short letter explaining one date mismatch were all clearer than a beautifully formatted story that skipped over the mismatch. I would rather say "here is the gap, and here is the explanation" than hope nobody notices.

            This is just the system that made my own file easier to read. Which documents are required depends on your trip, your nationality, and the office reviewing it, so check the current official guidance for your own case.
            """
        ),
        post(
            "b2-interview", .guide, .unitedStates,
            "The B-2 interview, from queue to approval",
            author: .jonah, time: "2h", likes: 394, comments: 46,
            tags: ["Interview", "Preparation"], read: 7, experience: true,
            body: """
            The queue was the part I had not imagined. I had rehearsed answers for weeks, but I had not rehearsed standing in a line in a very ordinary building, holding a very ordinary folder, watching people come back out with expressions I could not read.

            Inside, the officer asked me a few short questions about the purpose of my trip, my work, and who was paying for the flight. I answered with the shortest true version of each. I did not bring out documents unless he asked. He asked for one.

            The whole conversation was maybe four or five minutes. The build-up was months. What helped me most was writing down the five facts I wanted to be clear about ahead of time: why, when, where, who, and what I was returning to. Everything else was noise.

            I left with my passport still in my hand and a completely blank mind about where I was supposed to go next. I stood in the hallway for a minute, then called my sister. That part is not in any guide.

            Interview experiences vary enormously. Mine is just one account, not a template for anyone else's case.
            """
        ),
        post(
            "santorini-shoulder", .photo, .schengen,
            "Santorini in the shoulder season",
            author: .hana, time: "3h", likes: 934, comments: 41,
            image: "coverSantorini", aspect: 0.8,
            summary: "Late May gave us warm water, quiet lanes, and one memorable windstorm.",
            tags: ["Greece", "Islands"],
            body: """
            We arrived just before the cruise ships returned. For two days the village felt like a place where people actually lived: laundry on lines, cats asleep on warm steps, a bakery that sold out by nine.

            The windstorm was not part of the plan. It rearranged two days and cancelled a boat trip. We spent the afternoon in a tiny café, sharing a table with a couple from Athens who insisted we try the cheese pie. I still think about that pie.

            Shoulder season is not a secret anymore, but it was still gentler than I expected. Fewer people, softer light, and enough space to stand still at the exact view everyone photographs. Worth the risk of weather.
            """
        ),
        post(
            "vestrahorn-edge", .photo, .schengen,
            "Vestrahorn, at the edge of the map",
            author: .mira, time: "3h", likes: 622, comments: 18,
            image: "coverIcelandVestrahorn", aspect: 0.8,
            summary: "A black-sand road, a very patient car, and the best light of the trip.",
            tags: ["Iceland", "South coast"],
            body: """
            The drive out here felt like leaving the itinerary behind. The road gets narrow, the houses get sparse, and then there is nothing but black sand, water, and a mountain that looks like it was drawn by someone in a hurry.

            We stayed long enough for the tide to change. The reflection disappeared, came back, and disappeared again. I took maybe twelve photographs. This is the only one I kept.

            There is a small café near the car park that serves a very good fish soup. We ate it after the light was gone, with sand in our shoes and no real plan for dinner. I would like to go back in winter.
            """
        ),
        post(
            "appointment-slots", .question, .schengen,
            "Do appointment slots really open at midnight?",
            author: .priya, time: "4h", likes: 96, comments: 71,
            summary: "I have been refreshing at odd hours and seeing nothing. Is this just how it works, or am I looking at the wrong time?",
            tags: ["Appointments", "Planning"],
            body: """
            I know nobody here can see the booking system for me, and I am not expecting a hotline to the consulate. I am just trying to understand the rhythm of it.

            I have checked early morning, lunchtime, and one memorable 2 a.m. window. Always the same message. A colleague mentioned that she found hers on a random Tuesday afternoon, which is both encouraging and deeply unhelpful.

            If you have been through this recently: did you use a particular time of day, a particular page, or just a lot of patience? Any small practical details would be welcome. My trip is not until the autumn, so I have some time, but I would like to use it sensibly.
            """
        ),
        post(
            "itinerary-template", .guide, .schengen,
            "The one-page itinerary that made my application feel calmer",
            author: .clara, time: "5h", likes: 210, comments: 24,
            tags: ["Itinerary", "Documents"], read: 6, experience: true,
            body: """
            I made the mistake of thinking "itinerary" meant "a beautiful travel plan". Mine was a grid with too many fonts and not enough information. It looked like a holiday brochure, which is probably not the point.

            The second version was one page with five columns: date, city, where we were sleeping, transport, and the booking reference. That was it. No prose. No photographs. If someone wanted more detail, there was a second page with addresses and contact numbers.

            What changed was the way I checked it. With everything in one table, a gap in accommodation was suddenly obvious. So was a train that left before our flight landed. Those were mistakes I might have missed in a prettier document.

            I also printed the page and wrote the page numbers of the supporting bookings in pencil in the margin. That made the whole thing feel less like a pile of paper and more like an index.

            This is a filing habit, not a formula. Every application is different, and official guidance should always win.
            """
        ),
        post(
            "brooklyn-golden-hour", .photo, .unitedStates,
            "Brooklyn Bridge at golden hour",
            author: .amara, time: "5h", likes: 713, comments: 22,
            image: "coverNYCBrooklyn", aspect: 1.5,
            summary: "I walked from Manhattan to Brooklyn with no plan and no time pressure. Best hour of the trip.",
            tags: ["New York", "City walks"],
            body: """
            I almost skipped this. My feet hurt, the subway was right there, and the internet had told me the bridge would be packed. It was packed. It was also completely worth it.

            The light turned the cables into gold and the water into something flat and silver. Everyone was trying to take the same photograph. I joined in for a while, then put the phone away and just walked.

            On the other side I found a pier with a few benches and sat there until the streetlights came on. A man nearby was eating dumplings from a paper box. It felt like the least complicated hour of my whole week.
            """
        ),
        post(
            "london-layover", .photo, .unitedKingdom,
            "London on a six-hour layover",
            author: .kenji, time: "6h", likes: 388, comments: 16,
            image: "coverLondonPiccadilly", aspect: 1.5,
            summary: "Enough time for a walk, a coffee, and one very disciplined return to the airport.",
            tags: ["London", "Layover"], experience: true,
            body: """
            Six hours sounds generous until you subtract immigration, baggage, transit, and the buffer you need to sleep well that night. I decided to go anyway, with a hard turn-around time written on the back of my hand.

            I took the train into the city, walked without a map for forty minutes, bought a coffee I did not need, and turned around. The whole thing was maybe two hours on the ground. It was a completely unreasonable use of the journey and I would do it again.

            The one thing that saved me was travelling with hand luggage only. I met a couple at the station who were trying to find a left-luggage locker with twenty minutes to spare. We did not see them again, but I hope they made their flight.
            """
        ),
        post(
            "schengen-costs", .guide, .schengen,
            "The honest cost of a two-week Schengen trip",
            author: .lucas, time: "7h", likes: 193, comments: 27,
            tags: ["Budget", "Planning"], read: 9, experience: true,
            body: """
            I kept every receipt for two weeks, which is not normally how I travel. The total was higher than my estimate, mostly because of small things I had not thought to budget for: airport coffee, a taxi when the bus stopped running, a museum I added at the last minute, and one very expensive load of laundry.

            The big numbers were close to what I expected. The apartment was our largest expense, followed by trains. Food was somewhere in the middle, and we did not try to eat cheaply. Buying breakfast at the market each morning saved more than I expected without making the trip feel restrictive.

            If I did it again, I would book fewer cities. Moving every two days adds cost and loses time in a way that never shows up in a daily budget. I would also keep one unplanned day, which is the only line item I never regret.

            I am not going to present this as the cost of a visa application. This was just our holiday. Costs vary wildly by season, city, and appetite.
            """
        ),
        post(
            "ds160-details", .question, .unitedStates,
            "DS-160: the small details that trip people up",
            author: .noor, time: "8h", likes: 154, comments: 36,
            summary: "I keep second-guessing the employment dates and the address history. What did you do about gaps?",
            tags: ["DS-160", "Documents"],
            body: """
            I am working through the form slowly, with my old contracts open beside me. The dates are the hard part. Two jobs overlapped by a week because I was finishing one notice period while starting another, and I cannot decide which version is the "right" one.

            The other thing is the address history. I lived in a sublet for four months that I never changed on my bank details. It was my home, but it is almost invisible in my paperwork. I want the form to be accurate without turning into an autobiography.

            I would love to hear how other people handled this. Not what to write, exactly, but how you decided. I am trying not to let perfect become the enemy of accurate.
            """
        ),
        post(
            "porto-sunday", .photo, .schengen,
            "Porto on a Sunday",
            author: .sofia, time: "9h", likes: 458, comments: 13,
            image: "coverPorto", aspect: 0.8,
            summary: "Closed shutters, a slow river, and the sound of trams echoing uphill.",
            tags: ["Portugal", "Food"],
            body: """
            Sunday in Porto is quiet in the way that a city can only be when half of it is asleep. Some shutters stayed closed all day. The riverfront filled up slowly, then emptied again for lunch.

            We climbed to a viewpoint with no particular reward in mind. A man was playing something on a small guitar, and an old dog slept through the entire performance. We stayed for longer than we meant to.

            I keep coming back to this photo because it has the sound of the afternoon in it, which is not a thing a photograph can have. Still: the light was low, the river was silver, and someone was laughing behind me.
            """
        ),
        post(
            "uk-transit-question", .question, .unitedKingdom,
            "Am I overthinking the UK transit visa question?",
            author: .priya, time: "9h", likes: 88, comments: 31,
            summary: "I am changing planes at Heathrow and staying airside. My itinerary is one ticket, but I would rather ask than assume.",
            tags: ["Transit", "Layover"],
            body: """
            The booking is a single ticket, both legs on the same airline, and the connection is just over two hours. I do not plan to leave the airport. I do not even plan to collect my bag.

            My question is whether there is anything I should be checking that a single-ticket booking does not cover. I have read the airline's page and the airport's page. They both seem clear, but I am aware that my situation might have details the general page does not cover.

            I know the answer depends on nationality and on the specific route. I am mostly looking for the vocabulary to ask a better question when I call the airline. Any pointers welcome.
            """
        ),
        post(
            "uk-student-visa", .guide, .unitedKingdom,
            "What I wish I had organised before my UK student appointment",
            author: .ravi, time: "10h", likes: 263, comments: 34,
            image: "coverLondonAerial", aspect: 1.5,
            summary: "The things I had ready, the things I wish I had printed twice, and the calm-down walk before the door.",
            tags: ["Student visa", "London"], read: 8, experience: true,
            body: """
            I thought I was organised because I had every document. It turns out that "having" and "being able to find" are different skills, especially when someone is waiting.

            What helped: sending myself a single PDF that combined my confirmation, appointment slip, and the relevant pages of my passport. Having a paper copy of that PDF. Keeping the originals in a separate plastic sleeve from the photocopies. And writing the appointment time on a sticky note on the front of the folder, because my phone was about to die and I had started to doubt my own memory.

            What I would do differently: print the bank statements at the bank instead of at home; check that my photograph met the current specification rather than the one I found in an old forum post; and arrive early enough to sit down, breathe, and use the bathroom before the queue.

            The walk I took around the block beforehand was probably the single most useful preparation. I was still nervous, but I was no longer in a hurry. That changed the kind of attention I could give to the person on the other side of the desk.

            What I had with me was based on my own case and the current checklist at the time. Your list may be different. The official guidance for your route is the place to start.
            """
        ),
        post(
            "prague-slower", .guide, .schengen,
            "A slower guide to Prague",
            author: .theo, time: "11h", likes: 316, comments: 21,
            image: "coverPrague", aspect: 0.75,
            summary: "Three days of coffee, courtyards, and leaving the map in my pocket.",
            tags: ["Czechia", "Weekend"], read: 7, experience: true,
            body: """
            Prague is a city that rewards leaving the main road. The famous square is famous for a reason, but my favourite hours were spent in ordinary streets where nobody was performing anything.

            Day one: walk, get lost, end up at a café with one table and a very patient waiter. Day two: cross the river early, before the groups, and follow the quieter bank. Day three: revisit one place instead of adding a new one. That is the entire itinerary.

            A few things I would do again: book a museum for the first slot of the day, carry a small umbrella, and make dinner reservations because the good small places fill up by seven. I would skip the overbooked rooftop bar and choose the plain beer hall around the corner.

            I left with a long list of things I did not do. This time that felt like the point.
            """
        ),
        post(
            "bank-statements", .question, .schengen,
            "Bank statements: stamps, PDFs, or both?",
            author: .aisha, time: "12h", likes: 128, comments: 42,
            summary: "My bank can print a summary, but it is not the same format as my usual statement. What did you end up submitting?",
            tags: ["Finance", "Documents"],
            body: """
            I can download a PDF from my banking app, or I can ask a branch to print and stamp something. These two things do not contain exactly the same information.

            The branch printout has today's date on it, which makes it feel official. The PDF has the full period and my name, but no stamp. I have also read that some offices ask for a letter from the bank while others are happy with the downloaded version.

            I know this is one of those questions where the correct answer changes with the office and the application. I am curious which combination people actually took, and whether anyone was asked for something at the last minute that they had not brought.
            """
        ),
        post(
            "document-organisation", .guide, .schengen,
            "How I keep 60 pages of documents in order",
            author: .daniel, time: "13h", likes: 225, comments: 28,
            image: "coverNotes", aspect: 1.25,
            summary: "A simple tab system, a master index, and the tiny habit that stopped me from reprinting everything.",
            tags: ["Documents", "Organisation"], read: 5, experience: true,
            body: """
            I used to treat documents as a pile. Then I had a 60-page pile, and the pile started to feel like a personality flaw.

            The system that finally stuck was boring. A ring binder. Six coloured tabs. A one-page index with page numbers. Every time I printed something, it went behind a tab immediately, and the index was updated in pencil. Nothing was allowed to "live on the desk for now".

            The second habit was a correction sheet. If a document changed — a new bank statement, a revised hotel booking — I wrote the change and the date on a single sheet at the front. That way I did not have to reprint the whole index every time one page moved.

            None of this gets an application approved. It just makes the thing easier to look at, for you and for whoever has to read it. There is enough to be anxious about without losing page 43.
            """
        ),
        post(
            "venice-november", .photo, .schengen,
            "Venice in November was the reset I needed",
            author: .hana, time: "Yesterday", likes: 536, comments: 20,
            image: "coverVenice", aspect: 1.5,
            summary: "Rain, empty squares, and a hotel room that cost less than my coffee habit at home.",
            tags: ["Italy", "Slow travel"],
            body: """
            I expected grey. I did not expect how much I would like the grey. The water was high in places, the rain came and went, and the city was small enough to walk without a destination.

            We stayed near the Rialto in a hotel that clearly had better rooms in summer. Ours had a window that opened over a narrow canal and a bathroom that made a sound like a small ship. I loved it.

            The photograph is from one of the few dry hours. A boat crossed just as the light found the bridge. We stood there with our umbrellas lowered, absolutely certain we had made the right decision to come in the off-season.
            """
        ),
        post(
            "insurance-question", .question, .schengen,
            "Is travel insurance actually checked at the appointment?",
            author: .fiona, time: "Yesterday", likes: 91, comments: 26,
            summary: "I have the policy printed, but I keep hearing different things about how closely it is reviewed. What was your experience?",
            tags: ["Insurance", "Documents"],
            body: """
            The policy is valid for the dates of my trip and includes coverage that meets the requirements I was given. I have the certificate, the policy wording, and the emergency contact page. I am fairly sure I am prepared.

            What I am not sure about is the practical part. Did anyone look at the document in detail? Did they care about the wording, the dates, or the insurer's name? I would rather carry too much than be asked for something I left at home.

            If you have been through an appointment, I would love to hear what actually happened. This is plain curiosity plus a little bit of first-time nerves.
            """
        ),
        post(
            "honeymoon-timeline", .guide, .schengen,
            "Our honeymoon visa timeline",
            author: .mateo, time: "Yesterday", likes: 186, comments: 33,
            image: "coverParisPont", aspect: 0.75,
            summary: "What we did, when we did it, and the buffer we were glad to have. One couple's experience, not a formula.",
            tags: ["Timeline", "Planning"], read: 6, experience: true,
            body: """
            We started planning the trip before we started thinking about the paperwork. That gave us a clear idea of the invitation, the hotel, and the itinerary, but it also meant we were making bookings without knowing what we would need to prove later.

            The useful part was the buffer. We gave ourselves more time than we thought we needed between the appointment and the flight. It turned out to matter: one document needed a correction and the extra week meant we could fix it without cancelling anything.

            We also made one shared folder and two private folders. Shared for anything that needed both of us; private for personal financial documents. That sounds obvious, but it stopped us emailing scans back and forth at midnight.

            The trip itself was lovely. The paperwork is already a blur. If I were doing it again, I would keep the same buffer, ask for a confirmation in writing wherever possible, and stop trying to memorise the checklist in the final week.
            """
        ),
        post(
            "uk-border-surprise", .question, .unitedKingdom,
            "What surprised you about the UK border?",
            author: .aisha, time: "Yesterday", likes: 176, comments: 49,
            summary: "After months of paperwork, the arrival part felt oddly quiet. Curious what stood out to other people.",
            tags: ["Arrival", "First trip"], experience: true,
            body: """
            I had built the arrival up in my head. I imagined a long interview and a lot of searching through my folder. In reality, the queue moved quickly, the officer asked a couple of ordinary questions, and I was through in a few minutes.

            The surprising part was how much I wanted to keep explaining. I had spent so long preparing every detail that it felt strange to be asked only for the basics. I caught myself over-answering once, then stopped.

            I am curious what other people noticed: the questions, the atmosphere, the small thing that surprised you, or the moment you finally felt like the trip had started. This is one of the few parts of the process that is hard to picture until you are in it.
            """
        ),
        post(
            "three-applications", .guide, .schengen,
            "Two years, three Schengen applications",
            author: .leila, time: "2d", likes: 288, comments: 52,
            image: "coverSigning", aspect: 1.25,
            summary: "The small things I changed between applications, and the parts that were never really in my control.",
            tags: ["Timeline", "Documents"], read: 10, experience: true,
            body: """
            I have now done this three times. The first application was panic with a folder. The second was a self-inflicted bureaucracy project. The third was almost calm, which I did not expect.

            What changed was mostly presentation. I began using a one-page cover sheet that listed the documents in order and noted any dates that needed explanation. I stopped including things "just in case" when they muddied the main story. I made copies of copies and kept them in a separate envelope.

            What did not change: the waiting. There is a point after submission where preparation stops helping. I found it useful to schedule something ordinary for the day I expected to hear back — a long walk, dinner with a friend, a film. Anything to keep the day from becoming a vigil.

            The application itself was never the whole of my life, although it sometimes felt that way. If you are in the middle of your own first application, I hope you can find the boring, steady version of the process sooner than I did. It is a much better place to work from.
            """
        ),
        post(
            "nyc-without-itinerary", .photo, .unitedStates,
            "New York without an itinerary",
            author: .kenji, time: "2d", likes: 391, comments: 15,
            image: "coverNYCStreet", aspect: 0.75,
            summary: "Six days, one borrowed apartment, and a list that I mostly ignored.",
            tags: ["New York", "City walks"],
            body: """
            I arrived with a list of twenty places and left having seen maybe six of them. That sounds like failure. It felt like the best trip I have taken in years.

            The apartment was tiny and on the wrong side of the park, which meant I walked everywhere for the first two days. That accidental walking became the structure of the week. I found a coffee place, a bookstore, a park bench, and a noodle shop that I went back to three times.

            The photograph is from one of those walks. I stopped because the light hit the buildings in a way that looked impossible, then a bus came through and made it worse, and then better. I was late to nothing, because there was nothing to be late for.
            """
        ),
        post(
            "london-saturday", .photo, .unitedKingdom,
            "A slow Saturday in London",
            author: .clara, time: "2d", likes: 274, comments: 11,
            image: "coverLondonWestminster", aspect: 1.5,
            summary: "No museum queue, no checklist. Just a long walk and a sandwich eaten on a bench.",
            tags: ["London", "Weekend"],
            body: """
            I had a free Saturday between work things and decided not to "do" London. I walked from one bridge to another, took the long way around a park, and ate a slightly disappointing sandwich while watching a family argue about which direction the river flowed.

            It was the first time in ages I had looked at this part of the city without trying to photograph it. Then I took my phone out anyway, because the clouds were doing something dramatic behind the tower.

            The thing I like about this picture is that you can hear the traffic in it. It is not a postcard. It is just a normal afternoon in a place that keeps being extraordinary when you stop paying attention.
            """
        ),
        post(
            "us-road-trip", .guide, .unitedStates,
            "A US road trip with room for detours",
            author: .jonah, time: "3d", likes: 241, comments: 19,
            image: "coverUSDesertRoad", aspect: 1.5,
            summary: "A loose route through the desert, built around two fixed nights and a lot of unclaimed daylight.",
            tags: ["Road trip", "National parks"], read: 8, experience: true,
            body: """
            I planned this trip with two anchor bookings and no hourly schedule. Two nights at the first stop, two at the last, and a lot of space in between. It was the opposite of how I usually plan, and it suited the landscape.

            The rule was simple: start driving when we wanted, stop when something looked interesting, and never book accommodation after dark. We broke the last rule once. The motel had a broken ice machine and a very good diner next door, so it worked out.

            Bring more water than feels reasonable. Download the maps before you leave. Keep a paper copy of the route and a spare charger in the glovebox. These are not insights, but they are the things we were glad we had.

            The photograph is from the longest stretch of the drive. We pulled over for the light, not for a viewpoint. That turns out to be where most of the good memories came from.
            """
        ),
        post(
            "rome-no-checklist", .photo, .schengen,
            "Rome, with no checklist",
            author: .noor, time: "3d", likes: 552, comments: 17,
            image: "coverRome", aspect: 1.0,
            summary: "I skipped the line I was supposed to care about and found a quieter version of the city instead.",
            tags: ["Italy", "Rome"],
            body: """
            I had a list. I always have a list. But by the third day I could not face another queue, so I walked in a direction that had nothing marked on it and ended up here.

            The stone was warm from the afternoon. A school group passed through and then disappeared. For ten minutes it was just me, a very tired guard, and a pigeon with an agenda.

            I still think about the lunch I had afterwards: a plate of pasta with tomatoes so simple it tasted like a trick. I wrote two postcards, bought a pen from a machine, and did not cross a single thing off the list.

            I am not saying skip the famous places. I am saying that my favourite hour was not on the list, and that has made me plan differently ever since.
            """
        ),
        post(
            "glacier-meets-sea", .photo, .schengen,
            "Where the glacier meets the sea",
            author: .mira, time: "4d", likes: 761, comments: 23,
            image: "coverIcelandGlacier", aspect: 1.0,
            summary: "Jökulsárlón in soft rain, with icebergs moving so slowly they looked painted on.",
            tags: ["Iceland", "Nature"],
            body: """
            The rain was fine enough that we did not notice it until our jackets were soaked. The lagoon was grey and blue at the same time, filled with icebergs that had come from somewhere we could not see.

            We stood on the bank for a long while. There is something unnerving about watching ice move that slowly. You know it is travelling, but your eyes keep telling you it is still.

            A seal appeared near the far shore, then another. Neither of them cared that we were there. We eventually left because our hands were too cold to hold the camera. In the car, the heater took ten full minutes to make a difference.
            """
        ),
        post(
            "waiting-room-playbook", .question, .schengen,
            "The waiting room playbook",
            author: .priya, time: "4d", likes: 168, comments: 63,
            summary: "What did you bring, read, or do to keep your nerves steady before your appointment? I have one week and zero chill.",
            tags: ["Appointments", "Experiences"], experience: true,
            body: """
            I am not especially good at waiting. I am especially bad at waiting in a room where everyone else also looks nervous and nobody is allowed to say why.

            I have a folder, a book I will probably not read, and a plan to arrive twenty minutes early. Beyond that, I am open to ideas. Did you bring headphones? Did you make a list? Did you talk to anyone, or did you sit quietly and stare at the same notice on the wall?

            I know there is no trick that makes the appointment go faster. I am just looking for the small, practical things that make the waiting feel less endless.
            """
        ),
        post(
            "first-flight-after-approval", .photo, .unitedStates,
            "The first flight after approval",
            author: .amara, time: "5d", likes: 1_462, comments: 57,
            image: "coverAirplaneWing", aspect: 1.0,
            summary: "I kept touching my passport in my jacket pocket like it might disappear.",
            tags: ["First trip", "Flying"], experience: true,
            body: """
            I took my seat, put the folder in the overhead bin, and then immediately took it out again. The passport stayed in my jacket for the entire flight. I cannot explain what I thought would happen.

            The sun was going down somewhere over the Atlantic. I ordered a tiny bottle of wine and a packet of pretzels and felt like a person in a film. The passenger next to me was watching a film. I was watching the wing.

            I had spent so long thinking about whether the trip would happen that I had not spent much time thinking about what it would feel like once it did. Mostly it felt quiet, with a knot in my chest that slowly loosened somewhere over the water.

            The photograph is bad. The light was lovely. I keep it anyway.
            """
        ),
        post(
            "swiss-train", .photo, .schengen,
            "A slow train through Switzerland",
            author: .lucas, time: "5d", likes: 438, comments: 14,
            image: "coverSwissAlps", aspect: 1.5,
            summary: "Four hours of windows, one picnic, and no need to be anywhere else.",
            tags: ["Switzerland", "Rail"],
            body: """
            We took the slower train on purpose. It stopped in towns whose names we could not pronounce and made a sound like it was apologising every time it left.

            I had bought bread, cheese, and a small bag of apricots at the station. We ate them on the left side of the carriage because the lake was on the left, then moved to the right for the mountains, then back again. The woman across from us found this very funny.

            The weather changed three times. Rain on the windows, sun on the seats, cloud on the peaks. I did not finish the book I had brought and could not tell you the plot. The train was the point.
            """
        ),
        post(
            "copenhagen-budget", .photo, .schengen,
            "Copenhagen on a budget",
            author: .mira, time: "6d", likes: 329, comments: 18,
            image: "coverCopenhagen", aspect: 0.8,
            summary: "A little planning, a lot of walking, and the bakery that made the whole trip worth it.",
            tags: ["Denmark", "Budget"],
            body: """
            Copenhagen is not a cheap city, but it is a very walkable one. That combination worked in our favour. We stayed a little further out, bought breakfast at the market, and made lunch the main meal of the day.

            The harbour is free. The parks are free. The light in the late afternoon is free and, honestly, better than most of the things we paid for. We did one museum, one boat ride, and one very good bakery visit per day.

            My advice for a short trip: pick a neighbourhood and learn it rather than trying to see the whole city. We spent our favourite morning in the same three streets, going back to the same bakery twice.
            """
        ),
        post(
            "lake-braies", .photo, .schengen,
            "Lago di Braies before the crowds",
            author: .lucas, time: "6d", likes: 335, comments: 16,
            image: "coverLakeBraies", aspect: 1.5,
            summary: "We arrived early enough to hear the boats being untied. By ten, it was a different lake.",
            tags: ["Italy", "Dolomites"],
            body: """
            The car park was empty when we arrived. A man was hosing down a small wooden boat. The water was so still that the mountains looked duplicated, which is the sort of thing I expected from a postcard and not from real life.

            By nine-thirty the first tour group arrived. By ten there were queues for the boats and a line of people taking the same photograph from the same spot. We left before it got worse, but I am glad we saw the quiet version first.

            We walked around the lake slowly, took a wrong turn, and ended up on a path with no one on it. That was the best part. If you go, go early. And if you can, stay late. The middle of the day belongs to someone else.
            """
        ),
        post(
            "first-solo-trip", .guide, .schengen,
            "My first solo trip, six months after the visa",
            author: .sofia, time: "1w", likes: 243, comments: 29,
            image: "coverTraveler", aspect: 0.75,
            summary: "Small decisions I made to feel steady: a fixed base, a paper map, and permission to do nothing.",
            tags: ["Solo travel", "Portugal"], read: 6, experience: true,
            body: """
            I did not plan a grand solo tour. I booked one apartment for six nights in a city I already knew a little, and I gave myself permission to stay close.

            The first day I was anxious in a way I had not expected. I had the visa, the booking, and the time off; I did not have the feeling that I was allowed to be there. I went to a grocery store, bought breakfast for the next morning, and came back. That was enough for day one.

            The rest of the week settled into a rhythm: coffee, a long walk, a museum if I felt like it, dinner at a normal hour. I carried a paper map, not because my phone would fail, but because looking at a map felt less frantic than following a dot.

            I came home with one small bag of laundry and the feeling that I had done something by myself, on purpose. The visa made the trip possible. The trip was not really about the visa at all.
            """
        ),
        post(
            "edinburgh-weather", .photo, .unitedKingdom,
            "Edinburgh, if the weather lets you",
            author: .fiona, time: "1w", likes: 482, comments: 20,
            image: "coverEdinburgh", aspect: 1.5,
            summary: "Four seasons in one afternoon, and a skyline that made the soaked shoes worth it.",
            tags: ["Scotland", "City walks"], experience: true,
            body: """
            The forecast said rain and then sun and then rain again, which turned out to be exactly right. We walked up to the castle, got blown sideways, found a café, stayed longer than we meant to, and set out again when the clouds lifted.

            This photograph was taken from the wrong side of a hedge, on the way to somewhere else. The light had gone that strange gold it gets just before the rain comes back. I think someone else was standing behind me with the same idea.

            I would tell anyone going to pack layers, bring a waterproof bag, and leave one afternoon free. Edinburgh does not respond well to a tight schedule. It responds very well to a second coffee.
            """
        ),
        post(
            "cinque-terre", .photo, .schengen,
            "Cinque Terre in October",
            author: .theo, time: "1w", likes: 612, comments: 25,
            image: "coverCinqueTerre", aspect: 0.8,
            summary: "The trails were quiet, the light was long, and the villages felt like they exhaled after September.",
            tags: ["Italy", "Coast"],
            body: """
            October felt like the correct answer. The crowds had thinned, the water was still swimmable, and the light lasted long enough to make everything look like a painting.

            We walked between two villages rather than attempting the whole trail. That was the right decision for our knees and our attention spans. There was a bench halfway up with a view that made the climb worth it and a stray cat who apparently agreed.

            The villages are very beautiful and very used to being photographed. What I liked most was the space between them: the terraces, the stone walls, the ordinary work that makes the postcard possible.
            """
        ),
        post(
            "slow-paris", .photo, .schengen,
            "Five slow days in Paris",
            author: .mateo, time: "1w", likes: 823, comments: 32,
            image: "coverParisEiffel", aspect: 0.75,
            summary: "One arrondissement, one museum reservation, and a daily pastry rule we refused to break.",
            tags: ["France", "City walks"],
            body: """
            We chose the sixth because the apartment was affordable and the street was quiet, not because it was on anyone's list. It turned out to be the perfect base for a week of doing less.

            Every morning we picked a direction and walked until lunch. Every afternoon we had a museum or a garden or a nap. Every evening we bought something from a bakery and ate it on the way home. The pastry rule was non-negotiable.

            The photograph is from a walk toward the river that we did not plan. The light went pink, the tower appeared between buildings, and a woman next to us said approximately what we were thinking. We stood there for a while. Nobody minded.
            """
        ),
        post(
            "rothenburg-rain", .photo, .schengen,
            "A rainy afternoon in Rothenburg",
            author: .lucas, time: "2w", likes: 214, comments: 8,
            image: "coverRothenburg", aspect: 0.8,
            summary: "We ducked into a bakery to wait out the rain and stayed until the streetlights came on.",
            tags: ["Germany", "Road trip"],
            body: """
            We had planned two hours in the town and stayed for six. The rain arrived just as we reached the main square, so we bought a pastry and stood under a shop awning like everyone else.

            When the rain stopped, the streets were empty. The stone kept the light. We walked the wall path and looked down at the roofs, which looked even more like a drawing from above.

            The bakery closed at four, so we went back the next morning before leaving. The woman behind the counter remembered us and handed us an extra piece of something warm. I do not know what it was. I would drive back for it.
            """
        ),
        post(
            "visiting-family", .question, .unitedStates,
            "Visiting family: what did you include in your invitation?",
            author: .leila, time: "2w", likes: 132, comments: 30,
            summary: "My aunt is writing an invitation letter for my visit. We are trying to decide between a short letter and a very detailed one.",
            tags: ["Family", "Documents"],
            body: """
            My aunt has very kindly offered to write a letter inviting me to stay with her. We are both trying to work out how much detail is useful: her address, the dates, her relationship to me, a copy of her identification, a promise that she has space for me?

            I have seen examples that are three lines long and examples that read like a short essay. I do not want to overburden her with information that nobody will read, but I also do not want to be the person who left out the one detail that mattered.

            If you have done this before, what did your invitation cover? I know every case is different. I am just trying to find the middle ground.
            """
        ),
        post(
            "uk-visitor-differently", .guide, .unitedKingdom,
            "The UK visitor visa: what I'd organise differently",
            author: .daniel, time: "2w", likes: 247, comments: 35,
            image: "coverLaptopNotes", aspect: 1.5,
            summary: "The second time around I prepared in layers: first facts, then explanations, then everything else.",
            tags: ["Documents", "Planning"], read: 8, experience: true,
            body: """
            The first time, I prepared in order of fear. I started with the documents I was most worried about and worked outward. That meant the core story was buried under everything I had collected just in case.

            The second time, I prepared in three layers. Layer one: the facts of the trip. Dates, booking, money, purpose, return. Layer two: short explanations for anything that could look odd — a gap between jobs, a booking in someone else's name, a payment from a family member. Layer three: context that someone might reasonably want to read if they had a specific question.

            The folder was much thinner than before. The story was easier to follow. I also wrote a short covering note that told the reader where each layer lived. It was not a persuasive essay. It was a map.

            I would do this again for any application. It helped me notice the mismatches before anyone else did, and it made the final review something I could do in minutes rather than a full afternoon of dread.

            Every application has its own requirements and every reviewer has their own process. This is simply how I made my own file easier to read.
            """
        ),
        post(
            "vienna-weekend", .photo, .schengen,
            "Vienna in one long weekend",
            author: .mira, time: "2w", likes: 183, comments: 9,
            image: "coverVienna", aspect: 1.25,
            summary: "Two museums, a lot of walking, and one very good piece of cake.",
            tags: ["Austria", "Weekend"],
            body: """
            We planned this trip badly, in the sense that we only had two full days and a list of five things. We planned it well in the sense that we discarded the list on the first morning.

            The city is generous to walking. Every block has something worth stopping for, whether it is a doorway, a courtyard, a market, or a church you were not looking for. We found a flea market, a very serious chess game in a park, and a café where the waiter corrected my pronunciation twice.

            The photograph was taken from a rooftop at the end of the day. We were tired and a little sunburned and very pleased with the cake. I would go back in winter.
            """
        ),
        post(
            "over-atlantic", .photo, .unitedStates,
            "Over the Atlantic, somewhere new",
            author: .kenji, time: "2w", likes: 326, comments: 12,
            image: "coverClouds", aspect: 1.5,
            summary: "A window seat, ten hours, and a quiet kind of disbelief that the trip was actually starting.",
            tags: ["First trip", "Flying"], experience: true,
            body: """
            I had been awake for a long time before the flight. Not because I was worried, exactly. More because I could not believe the day had arrived and I did not want to miss any of it.

            The clouds below us looked solid enough to walk on. I watched the light change for an hour, then slept for three, then woke up and watched it change again. Somewhere in between, the cabin crew brought a tiny vegetarian meal and a cup of tea.

            I did not take this photograph for anyone else. I took it because I wanted to remember the specific feeling of being between one version of my life and another, with no obligations for a few hours. It is one of my favourite pictures from the whole trip.
            """
        ),
        post(
            "cotswolds-sunday", .photo, .unitedKingdom,
            "A Sunday in the Cotswolds",
            author: .clara, time: "3w", likes: 298, comments: 10,
            image: "coverCotswolds", aspect: 1.5,
            summary: "A village, a pond, and a walk that ended with tea and someone else's dog.",
            tags: ["England", "Weekend"],
            body: """
            We took the train out of London on a Sunday morning with no booking for anything. The village was smaller than the map suggested. The pond was full of ducks. A dog joined us for about ten minutes and then went home.

            The light stayed soft all afternoon. We walked the lane, read the notices on the church door, and had tea in a café that closed at four. I did not take many photographs. This one is from the walk back, when the sky went briefly golden.

            It is easy to treat these places as a backdrop. What I liked most was how ordinary the day was: people washing cars, a child learning to ride a bike, someone calling across the street for a spare key. The village was not performing for visitors. We were just passing through.
            """
        ),
        post(
            "amsterdam-slowly", .photo, .schengen,
            "Amsterdam, slowly",
            author: .priya, time: "3w", likes: 249, comments: 11,
            image: "coverAmsterdam", aspect: 0.75,
            summary: "No bike tour, no museum queue. Just canals, rain, and one excellent bowl of soup.",
            tags: ["Netherlands", "City walks"],
            body: """
            It rained on and off for the first two days, which turned out to be the best possible introduction. The city looks honest in the rain. The bikes get quieter, the cafés get busier, and the waterways turn into long grey mirrors.

            We stayed in a neighbourhood outside the centre and walked in a different direction each morning. We did not rent bikes. We did not stand in line for anything. We found a soup place near the flea market and ate there twice.

            The photograph is from a quiet stretch of canal on the third day. The light was just starting to change, and a boat was coming toward us. I had the camera out for once, and everything lined up for a second.
            """
        ),
        post(
            "onward-travel", .question, .schengen,
            "Proof of onward travel: what did you actually use?",
            author: .priya, time: "3w", likes: 155, comments: 21,
            summary: "My return ticket is booked. Is a confirmation email enough, or did you carry more? I would rather overprepare.",
            tags: ["Planning", "Documents"],
            body: """
            I have a return flight booked and a confirmation email that I can open offline. I also have a train booking within my trip that I could show if it helps. I am not sure what counts as sufficient proof of onward travel, and I would rather ask than improvise at a counter.

            I know this can depend on the country, the officer, and the specifics of the booking. I am not looking for a guarantee. I am mostly wondering whether people carried a printed itinerary, a screenshot, a full reservation, or all three.

            If you have been through it, I would love to hear what you had in hand. My folder has room for one more piece of paper.
            """
        ),
        post(
            "appointment-prep-guide", .guide, .schengen,
            "How I prepared for my first in-person appointment",
            author: .daniel, time: "3w", likes: 198, comments: 26,
            tags: ["Appointments", "Experiences"], read: 5, experience: true,
            body: """
            I prepared the documents first, because that was the part I could control. Then I prepared the morning around them.

            The night before, I put everything in one folder and left it by the door. I wrote the appointment time on a card and put the card in the folder. I checked the route, then checked it again. I set two alarms and did not trust either of them.

            On the day, I arrived twenty minutes early, found a bench around the corner, and sat for a few minutes without looking at my phone. That was the most useful thing I did. It gave my attention somewhere to land before the appointment started.

            I still had the folder open on my lap, still checked the index twice, still forgot the names of the two streets closest to my hotel. None of it mattered. The appointment was a conversation, not an exam. I wish I had known that beforehand.
            """
        )
    ]

    // MARK: - Helper

    private static func post(
        _ id: String,
        _ format: PostFormat,
        _ region: PostRegion,
        _ title: String,
        author: DiscoveryAuthor,
        time: String,
        likes: Int,
        comments: Int = 0,
        image: String? = nil,
        aspect: CGFloat? = nil,
        summary: String? = nil,
        tags: [String] = [],
        read: Int? = nil,
        experience: Bool = false,
        body: String
    ) -> DiscoveryPost {
        DiscoveryPost(
            id: id,
            format: format,
            region: region,
            title: title,
            summary: summary,
            body: body,
            coverImage: image,
            coverAspectRatio: aspect,
            tags: tags,
            author: author,
            timeLabel: time,
            likeCount: likes,
            commentCount: comments,
            readMinutes: read,
            isExperience: experience
        )
    }
}
