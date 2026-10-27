//
//  DiscoveryFixtures.swift
//  VisaDone
//

import SwiftUI

// MARK: - Community members

extension DiscoveryAuthor {
    static let you = DiscoveryAuthor(
        id: "you",
        name: "林晚",
        handle: "@林晚在路上",
        initials: "晚",
        palette: .rose,
        bio: "把签证材料理清楚，再慢慢去看世界。",
        isFollowing: false
    )

    static let mira = DiscoveryAuthor(
        id: "mira",
        name: "许知遥",
        handle: "@知遥慢慢走",
        initials: "遥",
        palette: .tide,
        bio: "喜欢公路、海风，以及不用赶路的清晨。",
        isFollowing: true
    )

    static let daniel = DiscoveryAuthor(
        id: "daniel",
        name: "陈屿",
        handle: "@阿屿的文件夹",
        initials: "屿",
        palette: .clay,
        bio: "整理控。把材料按顺序放好，心就定了一半。",
        isFollowing: true
    )

    static let priya = DiscoveryAuthor(
        id: "priya",
        name: "周可",
        handle: "@周可去远方",
        initials: "可",
        palette: .plum,
        bio: "行程不排太满，留一点时间给意外。",
        isFollowing: false
    )

    static let sofia = DiscoveryAuthor(
        id: "sofia",
        name: "苏禾",
        handle: "@苏禾的散步地图",
        initials: "禾",
        palette: .amber,
        bio: "拍街角和窗边，也记下旅途里的小事。",
        isFollowing: true
    )

    static let theo = DiscoveryAuthor(
        id: "theo",
        name: "陆川",
        handle: "@陆川慢行",
        initials: "川",
        palette: .indigo,
        bio: "在地图之外，找一家能坐很久的咖啡馆。",
        isFollowing: false
    )

    static let hana = DiscoveryAuthor(
        id: "hana",
        name: "沈夏",
        handle: "@小夏靠窗坐",
        initials: "夏",
        palette: .rose,
        bio: "淡季出门爱好者，收藏沿途的窗景。",
        isFollowing: true
    )

    static let lucas = DiscoveryAuthor(
        id: "lucas",
        name: "顾行",
        handle: "@顾行算过了",
        initials: "行",
        palette: .slate,
        bio: "先算预算，再选路线。住得舒服比打卡重要。",
        isFollowing: false
    )

    static let amara = DiscoveryAuthor(
        id: "amara",
        name: "乔宁",
        handle: "@乔宁第一次出发",
        initials: "宁",
        palette: .moss,
        bio: "记录第一次独自办签证和第一次远行。",
        isFollowing: false
    )

    static let elena = DiscoveryAuthor(
        id: "elena",
        name: "程澄",
        handle: "@程澄的周末",
        initials: "澄",
        palette: .indigo,
        bio: "城市散步、老建筑和一顿不赶时间的早餐。",
        isFollowing: false
    )

    static let noor = DiscoveryAuthor(
        id: "noor",
        name: "叶青",
        handle: "@叶青的清单",
        initials: "青",
        palette: .amber,
        bio: "分享申请材料，也分享少走弯路的小办法。",
        isFollowing: false
    )

    static let jonah = DiscoveryAuthor(
        id: "jonah",
        name: "闻舟",
        handle: "@闻舟看云",
        initials: "舟",
        palette: .moss,
        bio: "公路旅行和飞机窗外，有空就拍两张。",
        isFollowing: false
    )

    static let clara = DiscoveryAuthor(
        id: "clara",
        name: "唐栗",
        handle: "@唐栗的手账",
        initials: "栗",
        palette: .rose,
        bio: "用照片和手账，留住一趟旅行的细节。",
        isFollowing: true
    )

    static let mateo = DiscoveryAuthor(
        id: "mateo",
        name: "何遇",
        handle: "@何遇和小满",
        initials: "遇",
        palette: .clay,
        bio: "两个人旅行，一起研究路线和签证。",
        isFollowing: false
    )

    static let aisha = DiscoveryAuthor(
        id: "aisha",
        name: "宋雨",
        handle: "@宋雨出门前",
        initials: "雨",
        palette: .tide,
        bio: "还在准备下一次旅行，先把经验整理出来。",
        isFollowing: false
    )

    static let kenji = DiscoveryAuthor(
        id: "kenji",
        name: "江野",
        handle: "@江野在途中",
        initials: "野",
        palette: .slate,
        bio: "偏爱山路、火车和没有人催的下午。",
        isFollowing: false
    )

    static let fiona = DiscoveryAuthor(
        id: "fiona",
        name: "方晴",
        handle: "@方晴看天气",
        initials: "晴",
        palette: .plum,
        bio: "带一把伞，走走停停，也很好。",
        isFollowing: false
    )

    static let ravi = DiscoveryAuthor(
        id: "ravi",
        name: "简一",
        handle: "@简一的资料夹",
        initials: "一",
        palette: .indigo,
        bio: "材料可以复杂，准备过程尽量简单。",
        isFollowing: true
    )

    static let leila = DiscoveryAuthor(
        id: "leila",
        name: "温然",
        handle: "@温然的旅行页",
        initials: "然",
        palette: .amber,
        bio: "不追求去得多，想把每次出发都记清楚。",
        isFollowing: false
    )
}

// MARK: - Bundled community feed

enum DiscoveryFixtures {
    static let posts: [DiscoveryPost] = [
        post(
            "kirkjufell-morning", .guide, .schengen,
            "冰岛回来后，才懂行程单怎么写",
            author: .sofia, time: "1小时前", likes: 486, comments: 12,
            image: "coverIcelandSkogafoss", aspect: 1.5,
            summary: "把真实路程和住宿衔接补回草稿，给准备递签的人参考。",
            tags: ["冰岛旅游", "行程求审"],
            read: 2, experience: true,
            body: """
            申请时，我先用 AI 起了一份九天行程，后来又按社区建议减少了几个停靠点。真正走完南岸，才发现转城当天留一点余量，会让整个安排更从容。

            回来后重新看那份递签草稿，我补上了每天的过夜城市、主要交通，以及当时还没核实的部分。这次公开的是去掉个人信息和预订编号的版本，不是可以直接照交的模板。

            照片就用来留住这趟旅行，行程单则希望能帮下一位申请者少一点想当然。大家也可以翻到后面的草稿，看看哪些衔接还值得继续讨论。
            """
        ),
        post(
            "iceland-nine-days", .guide, .schengen,
            "住宿订单上的同行人，我补了一次材料",
            author: .mira, time: "18分钟前", likes: 342, comments: 31,
            image: "visaCoverAccommodation", aspect: 1.0,
            summary: "只写了预订人的名字，这次递交被要求补充住客信息。",
            tags: ["冰岛旅游", "住宿证明"], read: 2,
            experience: true,
            body: """
            两个人申请冰岛旅游签证，我打印的住宿订单只显示预订人。现场被要求补一份能对应同行人的说明，当时才发现，自己只核过日期，没有核过住客信息。

            后来联系住宿方，把确认信息和原订单放在一起提交。这里记录的是我这一次递交经历，不能据此说所有申请都必须这样做。

            想给“住宿证明”留一条社区补充经验：先看当前官方说明，再检查订单是否能对应自己的出行安排。遇到不同处理方式的朋友，也欢迎补充申请地和递交时间。
            """
        ),
        post(
            "new-york-finally", .photo, .unitedKingdom,
            "护照拿回来了，补一条英国访客时间线",
            author: .amara, time: "34分钟前", likes: 1_284, comments: 54,
            image: "coverLondonWestminster", aspect: 1.5,
            summary: "日期和申请地点一起报，才方便大家对照自己的情况。",
            tags: ["英国访客", "进度上报"],
            experience: true,
            body: """
            我这次是英国访客签证，上海递交。10 月 14 日完成递交，10 月 24 日收到寄出通知，10 月 26 日签收护照。今天整理出来，供同一时间段的申请者参考。

            查询页面中间有几天没变化，我没有把“没有更新”记成新的处理状态。上面的日期都来自我自己收到的通知和签收记录。

            不同签证类型、服务方式和地点不能直接比较。这是一条个人上报，不是官方处理时间，也不能用来预测下一份申请什么时候有结果。
            """
        ),
        post(
            "cover-letter-detail", .question, .schengen,
            "解释信里，哪些情况值得单独说明？",
            author: .elena, time: "1小时前", likes: 72, comments: 19,
            summary: "不想堆模板，也担心有些信息只看材料读不出来。",
            tags: ["申根旅游", "解释信"],
            body: """
            准备第一次申根申请。行程、工作和费用安排已经各写了一段，现在纠结的是：哪些地方需要解释，哪些只要材料本身就足够？

            我不打算逐笔解释所有流水，想先找出会让读者产生疑问的地方。大家愿意分享一下自己的组织方式吗？请不要贴带姓名、账号或单位信息的原件。
            """
        ),
        post(
            "uk-folder-worked", .guide, .unitedKingdom,
            "英签材料，先分清“要求”和“我的说明”",
            author: .ravi, time: "2小时前", likes: 267, comments: 38,
            image: "coverNotes", aspect: 1.25,
            summary: "官方清单、个人文件、社区提醒，别混成一份必交表。",
            tags: ["英国访客", "材料整理"], read: 2,
            experience: true,
            body: """
            我把资料分成三层：当前申请页面要求的文件、根据个人情况准备的说明、从社区收藏的经验。三者放在不同位置，避免把别人的情况误当成自己的必交材料。

            每项文件旁边只写状态和核对日期。社区帖子里有帮助的部分会记下来，但会保留出处、申请地点和时间，不直接改写官方要求。

            最后一次核对时，先按自己的申请页面走一遍，再看有没有尚未解释清楚的地方。文件夹没有变厚，倒是更容易找到重点了。
            """
        ),
        post(
            "b2-interview", .guide, .unitedStates,
            "美签面谈复盘：我被问到的四个问题",
            author: .jonah, time: "2小时前", likes: 394, comments: 46,
            summary: "旅行目的、停留安排、工作和费用，都是自己的实际情况。",
            tags: ["美国B类", "面谈复盘"], read: 2,
            experience: true,
            body: """
            这次面谈被问到旅行目的、大致停留时间、目前的工作以及费用安排。我按自己的情况回答，没有照着网上的固定句子背。

            准备时，把表格里填过的信息重新读了一遍。知道自己的安排，也知道相关材料放在哪里，比猜“下一题会是什么”更有用。

            这里只是我这一次面谈记录。问题和材料使用情况因人而异，不能当作统一题库或通过承诺。
            """
        ),
        post(
            "santorini-shoulder", .question, .schengen,
            "行程单里，这段换岛安排合理吗？",
            author: .hana, time: "3小时前", likes: 934, comments: 41,
            image: "coverSantorini", aspect: 0.8,
            summary: "先看交通衔接，再决定是不是要多留一个机动日。",
            tags: ["希腊旅游", "行程求审"],
            body: """
            想申请希腊旅游签证，行程里有一次换岛。公开版草稿只保留天数、城市和交通方式，个人信息与预订编号都删掉了。

            AI 给出的安排看起来很满，但我还没有核实那段船班是否适用于计划日期。准备先查可用交通，再反过来调整住宿。

            想请有经验的朋友看看应该先核对哪些衔接点。不需要替我选酒店，只想把路线写得更可执行。
            """
        ),
        post(
            "appointment-slots", .question, .schengen,
            "最近约到递签的朋友，能报一下时间吗？",
            author: .priya, time: "4小时前", likes: 96, comments: 71,
            summary: "一起交流预约过程，别把零散经验说成固定放号规律。",
            tags: ["申根预约", "预约交流"],
            body: """
            这几天在等预约，试过几个时段，还没看到合适日期。网上有人说“凌晨一定会放”，但没有看到能核对的稳定来源。

            最近约到的朋友，方便分享申请国家、预约地点和大致查看时间吗？不需要截图账号或预约编号。

            先把大家实际遇到的情况放在一起，不据此承诺某个时间一定有名额。
            """
        ),
        post(
            "document-organisation", .guide, .schengen,
            "60 页材料，我用一张索引串起来",
            author: .daniel, time: "13小时前", likes: 225, comments: 28,
            image: "coverTravelDesk", aspect: 0.8,
            summary: "纸质版和电子版同一顺序，补说明时也不容易弄乱。",
            tags: ["材料整理", "递签准备"], read: 2,
            experience: true,
            body: """
            我把身份、工作、资金、行程分别分组，在最前面写清文件名、日期和所在页码。说明紧跟对应材料，不再塞进“其他”文件夹。

            电子版与纸质版保持相同顺序。每次替换文件就更新索引，旧版本单独归档，避免递交前又拿错。

            这不是多准备一套要求，只是让自己的现有材料更容易核对和查找。
            """
        ),
        post(
            "us-road-trip", .question, .unitedStates,
            "美西自驾行程求审：每天换城是否太满？",
            author: .jonah, time: "3天前", likes: 241, comments: 19,
            image: "coverUSDesertRoad", aspect: 1.5,
            summary: "先改草稿里的里程和过夜点，再决定要不要保留那段绕路。",
            tags: ["美国旅游", "行程求审"], read: 2,
            body: """
            AI 初稿给两周安排了很多停靠点，几乎每天都要换住处。我把个人信息移除后发上来，想先请大家看看路线是不是太紧。

            目前还没有把草稿中的行车时间当作已核实数据，准备逐段查交通信息。想优先调整过夜城市，避免为了一个景点来回折返。

            如果只能删两处，大家会先删哪段？欢迎说明理由，而不是只给一条看上去更满的新路线。
            """
        ),
        post(
            "bank-statements", .question, .schengen,
            "流水文件怎么整理，才不会越合并越乱？",
            author: .aisha, time: "12小时前", likes: 128, comments: 42,
            summary: "想交流文件顺序，不把别人的提交版本当作统一要求。",
            tags: ["申根旅游", "资金材料"],
            body: """
            已经从自己的申请页面确认了所需材料，现在想把几份文件按时间整理。页数比较多，担心合并后找不到关键位置。

            大家会在首页加索引，还是直接按月份排列？仅参考整理方法；文件形式、时间范围等，仍按我这次的要求准备。
            """
        ),
        post(
            "vestrahorn-edge", .photo, .schengen,
            "从这张风景照，到一份能解释清楚的行程",
            author: .mira, time: "3小时前", likes: 622, comments: 18,
            image: "coverIcelandVestrahorn", aspect: 0.8,
            summary: "想去的地方很多，递签草稿却不必写成景点合集。",
            tags: ["冰岛旅游", "路线取舍"],
            experience: true,
            body: """
            最开始就是被这张山景吸引，才把冰岛放进旅行计划。真正准备申请时，才发现“想去”还需要变成能互相对应的日期、交通和住宿。

            我删掉了几段为了凑景点而增加的往返，每天只保留主要安排。照片还是愿望清单，行程则是这一趟能够说清楚的计划。
            """
        ),
        post(
            "uk-student-visa", .guide, .unitedKingdom,
            "学签准备，我把文件和日期放在一起",
            author: .ravi, time: "10小时前", likes: 263, comments: 34,
            image: "coverLondonAerial", aspect: 1.5,
            summary: "哪些能先做、哪些要等学校文件，一眼就能看到。",
            tags: ["英国学签", "材料清单"], read: 2,
            experience: true,
            body: """
            学校相关文件、个人材料和预约分别有自己的时间线，我把它们整理在同一张清单上。每项只记录来源、准备状态和下一步。

            社区里提到的提醒另放一栏，并保留日期，避免把过期经历当成当前要求。拿不准的问题先去核对对应说明。

            “已备齐”只是我自己的准备标记，不代表签证机构已经审核通过。
            """
        ),
        post(
            "itinerary-template", .guide, .schengen,
            "行程单一页版：先让日期彼此对得上",
            author: .clara, time: "5小时前", likes: 210, comments: 24,
            image: "visaIcelandItinerary", aspect: 0.82,
            summary: "日期、城市、住宿、交通四列，够我完成一次清晰核对。",
            tags: ["申根旅游", "行程单"], read: 2,
            experience: true,
            body: """
            我这份行程单只保留四列：日期、过夜城市、住宿安排和主要交通。景点写到能说明当天计划即可，不细到几点几分。

            核对时从入境那天读到离境那天，检查跨夜交通、连续住宿和航班日期是否衔接。没有确认的安排明确写成计划，不伪装成已预订。

            分享版去掉姓名和订单编号，方便大家只讨论行程本身。最终格式仍按自己的申请要求准备。
            """
        ),
        post(
            "rome-no-checklist", .guide, .schengen,
            "AI 改稿前后：删掉了同一天的三个远点",
            author: .noor, time: "3天前", likes: 552, comments: 17,
            image: "visaItineraryReview", aspect: 0.82,
            summary: "把“看起来丰富”改成“能够走通”，才算完成第一轮审阅。",
            tags: ["意大利旅游", "AI改稿"],
            experience: true,
            body: """
            初稿把三个相距较远的活动排在同一天，看上去很丰富，实际却没有交代中间怎么移动。我先把交通列出来，再删去一个远点。

            随后按社区提醒检查入住时间和活动预约。提醒只是核对入口；具体开放和预订信息还需要查对应来源。

            公开版保留改动理由，不上传姓名、订单或行踪细节。欢迎继续指出不合理的衔接。
            """
        ),
        post(
            "brooklyn-golden-hour", .question, .unitedStates,
            "纽约加波士顿，两城行程要写多细？",
            author: .amara, time: "5小时前", likes: 713, comments: 22,
            summary: "市内活动可以留弹性，跨城和住宿想先交代清楚。",
            tags: ["美国B类", "行程讨论"],
            body: """
            准备美国旅游签证，计划去纽约和波士顿。现在先列两地的停留天数、跨城交通和住宿安排，没有把每天的景点排死。

            想问已经准备过类似行程的朋友：你们会写到哪一层？我主要想让计划前后一致，不是为了编出一份看起来“标准”的路线。
            """
        ),
        post(
            "london-layover", .question, .unitedKingdom,
            "英国转机，先核对哪些个人条件？",
            author: .kenji, time: "6小时前", likes: 388, comments: 16,
            summary: "航班是否联程、是否提行李和是否入境，别省略背景。",
            tags: ["英国过境", "路径确认"],
            body: """
            正在比较两套机票，其中一套需要在英国转机。想把国籍、现有证件、是否更换机场、是否提取行李这些条件列清楚，再去对应官方说明。

            大家整理这类问题时，还有哪些容易遗漏的背景信息？不求一句“需要”或“不需要”，想先学会把问题问完整。
            """
        ),
        post(
            "schengen-costs", .guide, .schengen,
            "资金材料别只看余额，也核对前后一致",
            author: .lucas, time: "7小时前", likes: 193, comments: 27,
            summary: "我做了一张自查表，标出需要自己说明的地方。",
            tags: ["申根旅游", "资金材料"], read: 2,
            experience: true,
            body: """
            整理资金材料时，我先对照自己的工作情况和旅行预算，再检查各份文件里的姓名、日期和币种是否能对应。

            拿不准的地方记成待确认项，不直接套用社区里流传的金额门槛。特别是个人情况不同，别人的数字并不能替我解释自己的安排。

            这张自查表只是整理工具，不判断签证结果。具体材料形式和适用条件，仍回到自己的申请页面核实。
            """
        ),
        post(
            "ds160-details", .guide, .unitedStates,
            "填 DS-160 前，我先整理了这一页信息",
            author: .noor, time: "8小时前", likes: 154, comments: 36,
            summary: "把散落的日期和经历放在一起，少来回改表。",
            tags: ["美国B类", "表格填写"],
            experience: true,
            body: """
            我先在本地整理姓名拼写、过往经历、工作和计划行程，再逐页填写。遇到拿不准的字段，先记下问题，查看官方说明后再继续。

            提交前分两次核对，重点看日期与其他材料是否一致。这里分享的是准备方法，不提供可以直接套用的答案。

            公开笔记已经删掉个人信息。大家交流时也别上传完整表格、确认页编号或护照资料。
            """
        ),
        post(
            "porto-sunday", .guide, .schengen,
            "葡萄牙七天草稿：少换一次住处之后",
            author: .sofia, time: "9小时前", likes: 458, comments: 13,
            summary: "AI 负责起稿，我再按交通和住宿逐项修改。",
            tags: ["葡萄牙旅游", "AI改稿"],
            experience: true,
            body: """
            输入了旅行天数、两个目的地和不自驾的限制后，AI 生成了一版行程。初稿里每天都换住处，我先把相邻两天合并，减少了一次搬行李。

            接着分别核对跨城交通和住宿日期。社区里有关“不要低估换乘时间”的提醒，只当作检查线索，没有直接当成已核实事实。

            修改版比初稿短了不少，安排也更容易解释。公开版只展示天数和城市，欢迎从衔接合理性给建议。
            """
        ),
        post(
            "uk-transit-question", .question, .unitedKingdom,
            "同样是伦敦转机，为什么答案不一样？",
            author: .priya, time: "9小时前", likes: 88, comments: 31,
            summary: "先把自己的条件补齐，再看经验是否真的适用。",
            tags: ["英国过境", "信息核对"],
            body: """
            搜索时看到互相矛盾的说法，后来发现几位作者的证件、转机方式和是否入境都不一样。

            我准备做一张条件对照表，把不确定的部分标出来，再找对应的官方说明。大家收藏转机经验时，会怎么记录它的适用范围？
            """
        ),
        post(
            "prague-slower", .question, .schengen,
            "三座城市塞进六天，行程是不是太赶？",
            author: .theo, time: "11小时前", likes: 316, comments: 21,
            summary: "先把转城当天当作交通日，再决定要删哪一站。",
            tags: ["申根旅游", "行程求审"], read: 2,
            body: """
            目前的公开版草稿是六天去三座城市，主要交通都写了，但还没确认具体班次。AI 初稿把很多活动放在转城当天，我觉得不太踏实。

            想请大家只看安排本身：保留三个城市、减少活动，还是干脆少去一座？个人信息和住宿地址没有公开。
            """
        ),
        post(
            "venice-november", .question, .schengen,
            "跨夜火车那一晚，行程单怎么写清楚？",
            author: .hana, time: "昨天", likes: 536, comments: 20,
            summary: "不想让住宿看起来缺一天，也不想写并不存在的订单。",
            tags: ["意大利旅游", "住宿衔接"],
            body: """
            计划中有一晚坐跨夜火车。按日期填表时，发现那一格没有酒店，不想为了让表格整齐就写一个不存在的住宿安排。

            我目前把它写成夜间交通，并注明次日抵达的城市。想听听大家如何让这种衔接读起来清楚，具体证明形式我还会按申请要求确认。
            """
        ),
        post(
            "insurance-question", .question, .schengen,
            "保单自查：姓名、日期之外还核对什么？",
            author: .fiona, time: "昨天", likes: 91, comments: 26,
            summary: "把“看不懂”标出来，比跟着别人的截图猜更好。",
            tags: ["申根旅游", "旅行保险"],
            body: """
            保单已经下载，姓名和计划日期核对过了。附件里还有一些术语，我准备逐项看官方说明和保险文件，不想只凭别人说“我也买过”。

            大家递签前会如何整理自查记录？分享版请遮住证件号和保单编号，只交流核对方法。
            """
        ),
        post(
            "honeymoon-timeline", .photo, .schengen,
            "两个人同天递交，护照却分两次寄回",
            author: .mateo, time: "昨天", likes: 186, comments: 33,
            image: "coverParisPont", aspect: 0.75,
            summary: "我们把两条时间线分开记，没有把其中一人的状态套给另一人。",
            tags: ["法国旅游", "进度记录"], read: 2,
            experience: true,
            body: """
            我们一起准备法国旅游签证，在同一天完成递交，但收到寄出通知和签收护照的日期不同。于是把两个人的记录分开，按各自通知更新。

            等待时很容易看到同行人的变化就猜自己的结果。后来只记录确定发生的节点，没有把猜测填成状态。

            公开版不包含姓名和申请编号，只用于和相近条件的案例作参考。
            """
        ),
        post(
            "uk-border-surprise", .guide, .unitedKingdom,
            "拿回护照后，先完成这几项核对",
            author: .aisha, time: "昨天", likes: 176, comments: 49,
            summary: "记录自己的申请结果，再整理可回馈社区的经验。",
            tags: ["英国访客", "结果记录"],
            experience: true,
            body: """
            签收后先核对护照和签证页上的个人信息，再把收到护照的日期记进自己的申请记录。没有把快递通知提前当作签证结果。

            准备发经验帖时，只保留递交地点、类别、关键日期和真正有帮助的材料整理方法。姓名、证件号和申请编号都不公开。

            这一步做完，才把本次申请归档，方便下次准备时回看。
            """
        ),
        post(
            "three-applications", .guide, .schengen,
            "同一条住宿经验，三次申请并不完全一样",
            author: .leila, time: "2天前", likes: 288, comments: 52,
            image: "coverSigning", aspect: 1.25,
            summary: "把适用时间和个人条件写出来，比一句“必须”更有参考价值。",
            tags: ["申根旅游", "社区补充"], read: 2,
            experience: true,
            body: """
            翻自己的申请笔记时发现，三次出行的人数、申请地点和住宿安排都不同。关于住客信息的准备方式，也不能简单总结成一条所有人都适用的规则。

            我把经历拆成了“当时怎么准备、现场发生什么、后来补了什么”。没有核实的推测另行标记，不和亲历内容写在一起。

            欢迎有不同经历的朋友补充条件。社区记录可以帮人发现要检查的地方，但不能替代当前官方要求。
            """
        ),
        post(
            "nyc-without-itinerary", .question, .unitedStates,
            "美国两周计划，不想写成一张打卡表",
            author: .kenji, time: "2天前", likes: 391, comments: 15,
            summary: "先说明停留安排，日常活动到底需要细到哪一步？",
            tags: ["美国旅游", "行程讨论"],
            body: """
            这份草稿按城市分段，写了预计停留、跨城方式和住宿安排。市内活动保留弹性，没把每一餐都塞进日程。

            想问有经验的朋友，哪几处信息还不够清楚？我不打算写成确定执行的承诺，只希望计划与自己的其他材料一致。
            """
        ),
        post(
            "london-saturday", .guide, .unitedKingdom,
            "英签递交复盘：我只写了自己的情况",
            author: .clara, time: "2天前", likes: 274, comments: 11,
            summary: "材料来源、整理顺序和实际发生的事，分开记录。",
            tags: ["英国访客", "递交复盘"],
            experience: true,
            body: """
            这次从自己的申请页面开始列清单，社区帖主要用来提醒我发现没想到的问题。遇到别人说“必须交”的项目，会先核对是否适用于我的情况。

            递交后，把现场实际发生的事写下来，再单列出我自己的理解。没有发生过的步骤，不因为别人的经验就补进复盘。

            希望这样的记录能给下一位申请者一个检查思路，而不是另一份看似权威的清单。
            """
        ),
        post(
            "glacier-meets-sea", .question, .schengen,
            "行程写到冰河湖，这天是否该少排一站？",
            author: .mira, time: "4天前", likes: 761, comments: 23,
            image: "coverIcelandGlacier", aspect: 1.0,
            summary: "照片只是目的地参考，想讨论的是交通和住宿怎么接。",
            tags: ["冰岛旅游", "行程求审"],
            body: """
            计划在冰河湖附近停留，但草稿同一天还排了较长的交通。我开始担心只顾着把想去的地方写进去，没有给天气和停靠留余量。

            已移除具体出发日期和住宿地址。希望大家帮忙看当天的结构，尤其是应该删掉活动，还是调整过夜点。
            """
        ),
        post(
            "waiting-room-playbook", .guide, .schengen,
            "递签前一晚，我只做最后一次核对",
            author: .priya, time: "4天前", likes: 168, comments: 63,
            summary: "不再临时堆文件，把证件、预约信息和材料版本理顺。",
            tags: ["递签准备", "材料自查"],
            experience: true,
            body: """
            我把原清单里的未完成项单独列出来，先确认哪些真的需要补，哪些只是自己反复担心。已经核对过的文件不再临时换版本。

            证件和预约信息放在顺手的位置，路线、时间和现场物品要求提前查看。最后再检查电子文件与纸质件是不是同一版。

            这份笔记只是我的出门准备，不代表官方材料审查已经通过。
            """
        ),
        post(
            "first-flight-after-approval", .photo, .unitedStates,
            "11 月要用护照，我开始只看相似案例",
            author: .amara, time: "5天前", likes: 1_462, comments: 57,
            image: "coverAirplaneWing", aspect: 1.0,
            summary: "同国家、同类别、同递交地点，比一句“我十天拿到”有用。",
            tags: ["申根旅游", "进度交流"],
            experience: true,
            body: """
            下月另有安排要用护照，等待时容易被各种“几天拿到”的帖子影响。我现在先看申请类别、递交地点和日期，再决定这条记录能否参考。

            没有更新的案例会单独放着，不把它们都当作仍在处理，也不据此估算自己的结果。

            如果近期收到护照，欢迎补齐实际节点。分享关键日期就够了，不要贴个人申请编号。
            """
        ),
        post(
            "swiss-train", .question, .schengen,
            "不自驾的申根行程，交通怎么写更清楚？",
            author: .lucas, time: "5天前", likes: 438, comments: 14,
            image: "coverSwissAlps", aspect: 1.5,
            summary: "AI 建议的换乘先别照抄，查过能走通再放进草稿。",
            tags: ["申根旅游", "交通核对"],
            body: """
            计划以火车和公共交通为主，AI 给了几个跨城组合，但有些换乘间隔看起来偏紧。我准备先保留出发地和到达地，再逐段核实。

            想请有经验的朋友分享核对交通的方法。未确认的班次会写成计划，不在公开版里伪装成已预订车票。
            """
        ),
        post(
            "copenhagen-budget", .guide, .schengen,
            "行程预算，怎么和自己的材料对应？",
            author: .mira, time: "6天前", likes: 329, comments: 18,
            summary: "不追求一个“标准金额”，先解释这趟旅行的实际安排。",
            tags: ["丹麦旅游", "费用安排"],
            experience: true,
            body: """
            整理预算时，我按住宿、交通和日常支出分组，把已确定和仍在比较的安排分开。先让计划与自己的情况对应，而不是找一个大家都能套用的数字。

            社区经验能提醒我有没有漏项，但不能替我证明资金是否符合自己的申请要求。拿不准的部分，仍需要回到官方说明和个人材料中核实。
            """
        ),
        post(
            "lake-braies", .question, .schengen,
            "换过酒店后，旧订单该怎么处理？",
            author: .lucas, time: "6天前", likes: 335, comments: 16,
            image: "coverLakeBraies", aspect: 1.5,
            summary: "目录已经更新，想避免自己最后递交错版本。",
            tags: ["意大利旅游", "订单核对"],
            body: """
            最近调整了行程，几份旧住宿订单还在下载文件夹里。我已经按日期重排当前安排，准备把失效版本移到归档目录。

            大家会在材料目录里写清最新核对时间吗？主要想参考版本管理办法，具体提交内容仍按自己的要求准备。
            """
        ),
        post(
            "first-solo-trip", .guide, .schengen,
            "第一次独自申请，我先把问题问具体",
            author: .sofia, time: "1周前", likes: 243, comments: 29,
            image: "coverTraveler", aspect: 0.75,
            summary: "国籍、居住地、申请地和类别，少一个条件就可能聊偏。",
            tags: ["首次申请", "提问方法"], read: 2,
            experience: true,
            body: """
            最开始在社区问“我需要交什么”，收到很多互不相同的答案。后来先说明与路径相关的条件，再问某一项材料哪里看不懂，交流才慢慢有了方向。

            公开提问不需要上传整本护照。把必要背景写成文字，隐去证件号、单位和详细住址就够了。

            经验帖是补充线索；自己的官方清单和个人准备记录，仍要分开保存。
            """
        ),
        post(
            "edinburgh-weather", .photo, .unitedKingdom,
            "上海递交英国访客，补一下后续状态",
            author: .fiona, time: "1周前", likes: 482, comments: 20,
            image: "coverEdinburgh", aspect: 1.5,
            summary: "上次发帖时还没收到通知，这次把缺的日期补齐。",
            tags: ["英国访客", "进度补报"],
            experience: true,
            body: """
            前一篇只记录到完成递交，后来忙起来没有及时更新。现在补上自己收到寄出通知和签收护照的日期，避免旧帖一直停在最初状态。

            公开记录不包含收据或申请编号，也不会把别人猜测的状态写进来。请结合签证类别、地点和日期看，不把这一例当作平均等待时间。
            """
        ),
        post(
            "cinque-terre", .question, .schengen,
            "行程求审前，大家会删掉哪些信息？",
            author: .theo, time: "1周前", likes: 612, comments: 25,
            image: "coverCinqueTerre", aspect: 0.8,
            summary: "名字只是第一步，订单号、住宿地址和同行信息也想再查一遍。",
            tags: ["行程求审", "脱敏分享"],
            body: """
            想把自己的意大利行程草稿发到社区，请大家看看转城安排。已经去掉姓名和证件信息，但担心附件里还藏着订单号、邮箱或详细住宿地址。

            准备只保留相对天数、城市和交通方式。大家发公开版前，会用什么顺序做隐私核对？
            """
        ),
        post(
            "slow-paris", .guide, .schengen,
            "住宿证明日期，我这样逐晚对了一遍",
            author: .mateo, time: "1周前", likes: 823, comments: 32,
            image: "coverParisEiffel", aspect: 0.75,
            summary: "先找空档和重叠，再检查是否用了旧版本订单。",
            tags: ["法国旅游", "住宿证明"],
            experience: true,
            body: """
            我把入境到离境的每个夜晚排成一列，再把当前住宿和跨夜交通对应上去。这样比逐个打开订单，更容易看出有没有空档或前后不一致。

            核对只帮助我发现问题，不代表机构一定认可所有文件。具体形式和适用要求，还是以自己的申请说明为准。
            """
        ),
        post(
            "rothenburg-rain", .question, .schengen,
            "同行人改了行程，要从哪些材料重新核对？",
            author: .lucas, time: "2周前", likes: 214, comments: 8,
            summary: "别只改一张行程表，想列出会受影响的关联信息。",
            tags: ["申根旅游", "多人申请"],
            body: """
            同行人最近调整了抵达日期，我们原来的行程表和部分住宿信息都需要重新看。我准备先列“哪里变了”，再逐项检查相关材料。

            有过类似情况的朋友，会从哪些关联信息开始核对？不公开同行人的姓名和订单，只想参考整理顺序。
            """
        ),
        post(
            "visiting-family", .question, .unitedStates,
            "探亲邀请信，怎么和其他材料对应？",
            author: .leila, time: "2周前", likes: 132, comments: 30,
            summary: "不照搬一封万能模板，先把关系、行程和住宿安排讲清楚。",
            tags: ["美国探亲", "邀请说明"],
            body: """
            正在准备探亲行程，想先把拜访对象、停留计划和住宿安排写清楚，再考虑是否还有需要个人说明的地方。

            大家整理时如何避免邀请内容与其他材料的日期不一致？只参考结构，不求可以直接套用的答案。具体要求仍按自己的申请路径核实。
            """
        ),
        post(
            "uk-visitor-differently", .guide, .unitedKingdom,
            "第二次英签，旧材料没有直接照搬",
            author: .daniel, time: "2周前", likes: 247, comments: 35,
            summary: "同一个人再次申请，也需要按这次的情况重新整理。",
            tags: ["英国访客", "再次申请"], read: 2,
            experience: true,
            body: """
            上一次的文件夹很有参考价值，但我先重新读了当前申请页面，再按这次的工作与行程建立清单。旧文件只用来回忆，不直接当作最新版本。

            变化的地方单独标出来，没变化的也重新核对日期。这样做比把整个旧文件夹复制一遍更慢一点，却少了很多模糊地带。
            """
        ),
        post(
            "vienna-weekend", .guide, .schengen,
            "行程审阅，哪条建议最后被我采纳了？",
            author: .mira, time: "2周前", likes: 183, comments: 9,
            image: "coverVienna", aspect: 1.25,
            summary: "一条针对转城日的具体意见，比再加景点更有帮助。",
            tags: ["奥地利旅游", "社区审阅"],
            experience: true,
            body: """
            公开草稿发出后，有人建议把转城当天的预约挪到第二天，并说明了行李和入住可能带来的时间压力。我重新核对安排后，采纳了这条建议。

            其他意见也保留在修改记录里，没有全盘照单全收。行程是自己的决定，社区和 AI 都只是提供检查与讨论的帮助。
            """
        ),
        post(
            "over-atlantic", .photo, .unitedStates,
            "“寄出通知”和“收到护照”，我分开记录",
            author: .kenji, time: "2周前", likes: 326, comments: 12,
            summary: "不把物流节点提前当作最终结果，也不漏掉签收日期。",
            tags: ["美国B类", "状态记录"],
            experience: true,
            body: """
            记录申请进度时，我把通知、寄出和实际签收分成不同节点。收到通知当天没有写“已拿到护照”，更没有提前记录签证结果。

            拿回后再核对文件、补上结果和收到日期。公开版只保留类别、地点与时间线，不展示个人证件或编号。
            """
        ),
        post(
            "cotswolds-sunday", .guide, .unitedKingdom,
            "社区经验过期了吗？收藏时多记两项",
            author: .clara, time: "3周前", likes: 298, comments: 10,
            summary: "留下递交时间和适用条件，下次看才不容易误用。",
            tags: ["社区补充", "经验核对"],
            experience: true,
            body: """
            之前收藏的一条经验看起来很明确，重新看时才发现没有写申请地点和发生时间。我现在会把这两项和适用条件一起记录，缺的信息就标成未知。

            有疑问时先回到当前官方说明，再把帖子当作待核实的补充线索。点赞很多，也不等于这条经验适用于每个人。
            """
        ),
        post(
            "amsterdam-slowly", .question, .schengen,
            "材料检查“未读到”，不一定就是没有吧？",
            author: .priya, time: "3周前", likes: 249, comments: 11,
            summary: "扫描件里明明有日期，想问问大家如何做人工复核。",
            tags: ["材料检查", "人工确认"],
            body: """
            导入一份扫描订单后，检查结果没有识别出日期，但我放大原件能看到。我不想把“没识别到”直接改成“缺少”，准备回到文件逐项确认。

            大家会把这类情况怎么记下来？想区分确实缺失、已经找到和仍无法判断，避免为了把清单全变绿而跳过核对。
            """
        ),
        post(
            "onward-travel", .question, .schengen,
            "行程还没全部预订，怎么把计划说清楚？",
            author: .priya, time: "3周前", likes: 155, comments: 21,
            summary: "已确认和待确认分开写，不用虚构订单填满表格。",
            tags: ["申根旅游", "行程说明"],
            body: """
            目前只有部分行程确定，准备把草稿里的已确认安排和仍在比较的选项分开标注。不想为了表格完整，就填进不存在的预订信息。

            大家怎样让计划的边界读起来清楚？是否需要、如何提供相应证明，仍会按自己的申请要求确认。
            """
        ),
        post(
            "appointment-prep-guide", .guide, .schengen,
            "递交前总检查：别急着把清单全部勾完",
            author: .daniel, time: "3周前", likes: 198, comments: 26,
            image: "visaDocumentChecklist", aspect: 0.82,
            summary: "日期冲突、没读清的字段和个人确认项，最后集中看一次。",
            tags: ["材料总检查", "递签准备"], read: 2,
            experience: true,
            body: """
            我最后一次检查不按文件数量走，而是把还没确认的问题列到一起：日期是否衔接、是否误用了旧订单、哪些字段需要回到原件看。

            文件标成“已备齐”，只是表示我完成了自己的准备，不等于已经得到机构认可。社区提醒与 AI 检查结果也没有替我做这个判断。

            把确定的事项逐项确认，不确定的继续保留。比起一张全绿的清单，我更想知道自己还没弄明白什么。
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
