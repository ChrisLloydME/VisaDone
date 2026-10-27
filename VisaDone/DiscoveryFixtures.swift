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
            "iceland-nine-days", .guide, .schengen,
            "冰岛九天，把行程留白一点",
            author: .mira, time: "18分钟前", likes: 342, comments: 31,
            image: "coverIcelandSkogafoss", aspect: 1.5,
            summary: "沿着南岸慢慢开，住三个地方，给天气和偶遇各留一天。",
            tags: ["冰岛", "行程安排"], read: 8, experience: true,
            body: """
            最初的行程表塞了十一个景点。后来删掉一半，才有了这趟真正舒服的冰岛旅行。九天只换三次住处，沿南岸开，不用每天早起收行李。

            出发前我把住宿、租车和每天的里程放在同一张表里，办签证时也直接用它核对日期。纸质行程放在副驾驶，订单另存一份离线文件。

            预留的空白日遇上了大风，我们索性换成泡温泉和吃热汤。少去一个景点，并没有少掉什么。
            """
        ),
        post(
            "new-york-finally", .photo, .unitedStates,
            "终于，到了纽约",
            author: .amara, time: "34分钟前", likes: 1_284, comments: 54,
            image: "coverNYCEmpire", aspect: 0.8,
            summary: "走出地铁就是帝国大厦，地图上的地点忽然变得真实。",
            tags: ["纽约", "初次出行"], experience: true,
            body: """
            落地后的第一站不是景点，而是酒店楼下的贝果店。热咖啡和有点吵的街道，让漫长的飞行慢慢有了实感。

            面签、等护照、订机票，准备时觉得每一步都很长。真的站在纽约街头，反而只想先好好走一段路。
            """
        ),
        post(
            "cover-letter-detail", .question, .schengen,
            "解释信到底写多细才合适？",
            author: .elena, time: "1小时前", likes: 72, comments: 19,
            summary: "一页能说清的事，有必要再附一封补充说明吗？",
            tags: ["解释信", "材料整理"],
            body: """
            准备第一次申根申请，行程、工作和资金来源已经写了一页。现在纠结要不要解释每一笔转账，怕太少说不清，太多又找不到重点。

            大家当时是按问题分段，还是按时间顺序写？想参考实际准备过的结构，不求万能模板。
            """
        ),
        post(
            "kirkjufell-morning", .photo, .schengen,
            "教会山藏进云里的那天",
            author: .sofia, time: "1小时前", likes: 486, comments: 12,
            image: "coverIcelandKirkjufell", aspect: 1.5,
            summary: "等了一个早晨，山没有出现，倒是记住了风的声音。",
            tags: ["冰岛", "摄影"],
            body: """
            到停车场时，山顶已经被云盖住。原本想等一张明信片里的照片，最后只在车里喝了两杯热茶。

            离开前云散开了一小会儿，没有拍到全貌。但比起照片，我更记得那一段没有赶时间的等待。
            """
        ),
        post(
            "uk-folder-worked", .guide, .unitedKingdom,
            "英签材料，我这样装进一个文件夹",
            author: .ravi, time: "2小时前", likes: 267, comments: 38,
            image: "coverTravelDesk", aspect: 0.8,
            summary: "目录、文件名和时间线统一之后，准备过程终于不再混乱。",
            tags: ["访客签证", "材料整理"], read: 7, experience: true,
            body: """
            最开始，材料散在邮箱、微信和下载文件夹里。我后来只做了三件事：列一张目录、统一日期格式、按主题建立文件夹。

            身份、工作、资金和行程各放一组。需要解释的地方，说明页就放在对应材料后面，不再另建一个“其他”目录。

            这是我的整理习惯，不是官方材料清单。最后仍按申请页面逐项核对了一遍。
            """
        ),
        post(
            "b2-interview", .guide, .unitedStates,
            "美签面谈，从排队到结束",
            author: .jonah, time: "2小时前", likes: 394, comments: 46,
            tags: ["面谈", "行前准备"], read: 7, experience: true,
            body: """
            预约当天比约定时间早到了一会儿。进场后跟着工作人员的指引走，排队时把行程和工作情况在心里过了一遍。

            我被问到旅行目的、预计天数和目前的工作。准备的材料没有全部用上，但知道它们在哪里，回答时就没那么紧张。

            这里只记录我这一次面谈。不同人的情况和问题可能完全不同。
            """
        ),
        post(
            "santorini-shoulder", .photo, .schengen,
            "淡季的圣托里尼，刚刚好",
            author: .hana, time: "3小时前", likes: 934, comments: 41,
            image: "coverSantorini", aspect: 0.8,
            summary: "不用排队等日落，沿着海边走到天黑就很好。",
            tags: ["希腊", "海岛"],
            body: """
            我们选了旅游旺季前的一周。海边还有点凉，巷子却安静得可以听见咖啡杯落在桌上的声音。

            没有把每一处蓝顶都圈进地图。下午沿着悬崖慢慢走，遇到喜欢的风景就停下，最后在一家小店等到了日落。
            """
        ),
        post(
            "vestrahorn-edge", .photo, .schengen,
            "开到蝙蝠山，路就安静了",
            author: .mira, time: "3小时前", likes: 622, comments: 18,
            image: "coverIcelandVestrahorn", aspect: 0.8,
            summary: "黑沙、海水和低低的云，是那天全部的颜色。",
            tags: ["冰岛", "南岸"],
            body: """
            最后一段路比地图上看起来更慢。风很大，我们把车停好，沿着浅水边走，没有急着找机位。

            回去的路上吃了一碗热汤。照片里没有那种终于暖过来的感觉，但我到现在还记得。
            """
        ),
        post(
            "appointment-slots", .question, .schengen,
            "预约名额真的会在凌晨放出吗？",
            author: .priya, time: "4小时前", likes: 96, comments: 71,
            summary: "刷了几天都没结果，想问问大家是怎么等到预约的。",
            tags: ["预约", "出行准备"],
            body: """
            计划两个月后出发，现在卡在预约这一步。试过不同时间登录，也设置了提醒，但还没看到合适日期。

            网上说法很多，不太想继续熬夜碰运气。最近预约过的朋友，可以分享一下自己的时间线吗？
            """
        ),
        post(
            "itinerary-template", .guide, .schengen,
            "一页行程单，比十张截图好用",
            author: .clara, time: "5小时前", likes: 210, comments: 24,
            tags: ["行程安排", "材料整理"], read: 6, experience: true,
            body: """
            我把行程单缩成了四列：日期、过夜城市、主要安排和住宿。不写精确到小时的计划，只保留能互相核对的信息。

            每次改订单，就顺手更新同一份表。提交前从第一天读到最后一天，检查有没有空档、跨夜交通或前后不一致的日期。
            """
        ),
        post(
            "brooklyn-golden-hour", .photo, .unitedStates,
            "在布鲁克林大桥等一束晚光",
            author: .amara, time: "5小时前", likes: 713, comments: 22,
            image: "coverNYCBrooklyn", aspect: 1.5,
            summary: "走到桥中央时，整座城市刚好亮起来。",
            tags: ["纽约", "城市漫步"],
            body: """
            下午从布鲁克林出发，原本只想散步到桥下。看见光线变暖，又多走了一段。

            桥上人很多，走慢一点反而能找到自己的节奏。回程坐地铁，照片在手机里看了一路。
            """
        ),
        post(
            "london-layover", .photo, .unitedKingdom,
            "伦敦转机的六小时",
            author: .kenji, time: "6小时前", likes: 388, comments: 16,
            image: "coverLondonPiccadilly", aspect: 1.5,
            summary: "少安排一站，多留一点回机场的余量。",
            tags: ["伦敦", "转机"], experience: true,
            body: """
            这次转机时间比较宽裕，我们提前确认了入境和交通安排，只选一个街区走走。没有把“六小时”全部算成游览时间。

            一杯咖啡、一段步行，再提前回机场。对于转机旅行，能从容坐上下一班飞机，比多去一个地方重要。
            """
        ),
        post(
            "schengen-costs", .guide, .schengen,
            "欧洲两周，我实际花了多少钱",
            author: .lucas, time: "7小时前", likes: 193, comments: 27,
            tags: ["旅行预算", "出行准备"], read: 9, experience: true,
            body: """
            回家后整理了两周的账单，最明显的差别来自住宿和换城市的频率。多住一晚的小镇，比每天赶车轻松，也少花了不少钱。

            预算表里我单独留了交通、餐饮和机动支出。做行程时先想清楚哪些体验值得花钱，剩下的就不必样样都安排。
            """
        ),
        post(
            "ds160-details", .question, .unitedStates,
            "填 DS-160 时，我反复核对的细节",
            author: .noor, time: "8小时前", likes: 154, comments: 36,
            summary: "不是填得快，而是让每处信息都对得上。",
            tags: ["DS-160", "材料整理"],
            body: """
            第一次填写时，我把能确认的信息先整理在一份文档里，再逐页录入。姓名拼写、日期和工作信息是我回头检查最多的地方。

            提交前没有一口气往下点，而是分两次核对。拿不准的项目先查看官方说明，避免只按别人的答案套用。
            """
        ),
        post(
            "porto-sunday", .photo, .schengen,
            "波尔图的周日，从一顿早餐开始",
            author: .sofia, time: "9小时前", likes: 458, comments: 13,
            image: "coverPorto", aspect: 0.8,
            summary: "沿着坡路往河边走，整天都不需要一张打卡表。",
            tags: ["葡萄牙", "吃吃喝喝"],
            body: """
            早餐店的面包刚出炉，窗外的电车慢慢经过。我们吃完才打开地图，决定沿着河走。

            下午下了一阵雨，就在屋檐下多坐了一会儿。没有完成什么清单，却觉得这一天很完整。
            """
        ),
        post(
            "uk-transit-question", .question, .unitedKingdom,
            "英国转机，这个情况该怎么确认？",
            author: .priya, time: "9小时前", likes: 88, comments: 31,
            summary: "两段航班不是联程，越查越怕漏掉自己的具体条件。",
            tags: ["过境", "转机"],
            body: """
            正在比较两套机票，其中一套需要在英国转机。想先把是否换航站楼、是否提取行李这些条件弄清楚，再查对应要求。

            大家整理转机信息时会先看哪些官方页面？求一个核对思路，避免漏项。
            """
        ),
        post(
            "uk-student-visa", .guide, .unitedKingdom,
            "英国学签，早点整理会轻松很多",
            author: .ravi, time: "10小时前", likes: 263, comments: 34,
            image: "coverLondonAerial", aspect: 1.5,
            summary: "学校文件、资金证明和预约日期，最好放在同一条时间线上。",
            tags: ["学生签证", "伦敦"], read: 8, experience: true,
            body: """
            拿到学校文件后，我先把各项准备时间写在日历上。能提前做的就提前做，必须等文件的部分单独标出来。

            扫描件按用途命名，纸质件按提交顺序放好。出门前再按预约页面核对，不必靠记忆猜自己带齐了没有。
            """
        ),
        post(
            "prague-slower", .guide, .schengen,
            "布拉格，不赶路的两天",
            author: .theo, time: "11小时前", likes: 316, comments: 21,
            image: "coverPrague", aspect: 0.75,
            summary: "清晨去河边，下午在旧城找一家能久坐的咖啡馆。",
            tags: ["捷克", "周末"], read: 7, experience: true,
            body: """
            第一次到布拉格，没有给自己安排完整的景点路线。上午沿河散步，中午回住处歇一会儿，傍晚再出门。

            错开最热闹的时间后，熟悉的广场也安静下来。对我来说，这比多爬一座塔更值得。
            """
        ),
        post(
            "bank-statements", .question, .schengen,
            "银行流水，大家最后交了什么版本？",
            author: .aisha, time: "12小时前", likes: 128, comments: 42,
            summary: "纸质盖章和电子文件都准备了，想确认怎么整理更清楚。",
            tags: ["资金材料", "材料整理"],
            body: """
            目前手上有银行下载的文件，也能去柜台打印。两份信息一致，只是页数和展示方式不一样。

            想听听大家如何命名、合并和核对这些文件。具体提交要求我会再按自己的申请页面确认。
            """
        ),
        post(
            "document-organisation", .guide, .schengen,
            "60 页材料，也能一眼找到",
            author: .daniel, time: "13小时前", likes: 225, comments: 28,
            image: "coverNotes", aspect: 1.25,
            summary: "一张索引、几组标签，让最后一次核对不再手忙脚乱。",
            tags: ["材料整理", "文件管理"], read: 5, experience: true,
            body: """
            我的材料有六十多页。真正帮上忙的不是换文件夹，而是在最前面加了一张索引，写清名称、日期和所在页码。

            同类材料挨着放，说明紧跟相关文件。电子版和纸质版保持同一顺序，遇到问题时不用在两个系统里重新找。
            """
        ),
        post(
            "venice-november", .photo, .schengen,
            "十一月的威尼斯，慢一点更好",
            author: .hana, time: "昨天", likes: 536, comments: 20,
            image: "coverVenice", aspect: 1.5,
            summary: "雨后的石板路、安静的运河，还有一杯站着喝的咖啡。",
            tags: ["意大利", "慢旅行"],
            body: """
            早晨的雾很重，出门时看不清运河另一边。我们没有急着去主广场，先在街角吃了早餐。

            后来沿着窄巷随便走，走错了也没关系。能听见船经过的声音，就是这趟旅行最好的背景。
            """
        ),
        post(
            "insurance-question", .question, .schengen,
            "旅行保险，递签前该核对哪些信息？",
            author: .fiona, time: "昨天", likes: 91, comments: 26,
            summary: "保单已经买好，想做一次提交前的自查。",
            tags: ["旅行保险", "材料整理"],
            body: """
            日期、目的地和姓名都核过了，但保单附件比较多，不确定怎样整理才方便阅读。

            想请教大家是保留完整文件，还是另做目录？我会以当前官方要求为准，只想参考整理方法。
            """
        ),
        post(
            "honeymoon-timeline", .guide, .schengen,
            "蜜月旅行，我们的签证时间线",
            author: .mateo, time: "昨天", likes: 186, comments: 33,
            image: "coverParisPont", aspect: 0.75,
            summary: "从准备材料到拿回护照，每一步都记下来就没那么慌。",
            tags: ["时间线", "出行准备"], read: 6, experience: true,
            body: """
            两个人的材料放在一起后，比想象中容易漏掉细节。我们用一张共享清单标记谁负责什么，每晚只花十分钟核对进度。

            收到护照后，先确认信息，再补订还没确定的行程。最轻松的一刻不是去机场，而是终于把清单最后一项划掉。
            """
        ),
        post(
            "uk-border-surprise", .question, .unitedKingdom,
            "第一次入境英国，你遇到了什么？",
            author: .aisha, time: "昨天", likes: 176, comments: 49,
            summary: "想听听真实的到达流程，给第一次出行留一点心理准备。",
            tags: ["抵达", "初次出行"], experience: true,
            body: """
            马上要出发，机票和住宿都整理好了。现在比较想知道下飞机后的节奏：排队、交通，以及容易忘在行李里的小东西。

            不求标准答案，每个人的经历都可能不同。能分享一两个自己记得的细节就很有帮助。
            """
        ),
        post(
            "three-applications", .guide, .schengen,
            "两年三次申根申请，我改了什么",
            author: .leila, time: "2天前", likes: 288, comments: 52,
            image: "coverSigning", aspect: 1.25,
            summary: "模板越用越短，自己的情况反而说得越来越清楚。",
            tags: ["时间线", "材料整理"], read: 10, experience: true,
            body: """
            前两次准备时，我总觉得材料越多越安心。第三次重新读自己的文件，才发现有些内容只是重复，关键日期却不够醒目。

            后来保留一张总清单，每次按新行程重新核对。旧文件只作参考，不再直接沿用没确认过的信息。
            """
        ),
        post(
            "nyc-without-itinerary", .photo, .unitedStates,
            "在纽约，把一天交给步行",
            author: .kenji, time: "2天前", likes: 391, comments: 15,
            image: "coverNYCStreet", aspect: 0.75,
            summary: "没有提前预约的下午，也会遇见喜欢的地方。",
            tags: ["纽约", "城市漫步"],
            body: """
            从住处出发后，我们只决定往南走。中间买了咖啡，逛了书店，在公园里吃完午餐。

            真正喜欢上的不是某个著名路口，而是城市里很多普通的十分钟。回去才发现，一整天都没有看过时间表。
            """
        ),
        post(
            "london-saturday", .photo, .unitedKingdom,
            "伦敦的周六，只做三件事",
            author: .clara, time: "2天前", likes: 274, comments: 11,
            image: "coverLondonWestminster", aspect: 1.5,
            summary: "逛市场、沿河走走，再找个地方吃晚饭。",
            tags: ["伦敦", "周末"],
            body: """
            上午去了住处附近的市场，买一份热食，边走边吃。午后沿河散步，看到有空位的长椅就坐下来。

            出发前准备了很多地图收藏，最后只用了其中两个。留着，下次还有理由再来。
            """
        ),
        post(
            "us-road-trip", .guide, .unitedStates,
            "美国公路旅行，给绕路留点时间",
            author: .jonah, time: "3天前", likes: 241, comments: 19,
            image: "coverUSDesertRoad", aspect: 1.5,
            summary: "不追每天开多远，路边停下来的半小时也算行程。",
            tags: ["自驾", "国家公园"], read: 8, experience: true,
            body: """
            路线从一开始就没有排满。每天只定一个大方向，尽量在天黑前到住处，剩下的时间交给路上的停靠点。

            一次临时绕路让我们错过了预定的晚餐，却看到了整片山谷的落日。后来想起来，那才是最值得留下的一段。
            """
        ),
        post(
            "rome-no-checklist", .photo, .schengen,
            "罗马，不带清单也很好",
            author: .noor, time: "3天前", likes: 552, comments: 17,
            image: "coverRome", aspect: 1.0,
            summary: "把午饭吃慢一点，再沿着有阴影的小路走。",
            tags: ["意大利", "罗马"],
            body: """
            原本只安排了一个上午的参观。结束后没有继续赶路，而是在附近找了家小餐馆，坐到午后的太阳没那么晒。

            城市里的旧墙、街角和餐桌，都值得留一点注意力。少看几处景点，也没有觉得遗憾。
            """
        ),
        post(
            "glacier-meets-sea", .photo, .schengen,
            "在冰川和海之间停一会儿",
            author: .mira, time: "4天前", likes: 761, comments: 23,
            image: "coverIcelandGlacier", aspect: 1.0,
            summary: "灰蓝色的天，漂浮的冰，以及一段很安静的路。",
            tags: ["冰岛", "自然"],
            body: """
            那天一直有细雨，湖边的颜色比照片里更淡。我们沿着岸边走，看到一块冰慢慢转向海的方向。

            出发前只把这里当作行程中的一站，到了之后反而不想再加别的安排。
            """
        ),
        post(
            "waiting-room-playbook", .question, .schengen,
            "候签时，我给自己留的几个提醒",
            author: .priya, time: "4天前", likes: 168, comments: 63,
            summary: "材料放顺手，手机充好电，再把回程交通提前看一眼。",
            tags: ["预约", "申请经历"], experience: true,
            body: """
            预约前一晚没有再大改材料，只把目录读了一遍。证件和预约信息单独放，水、充电线和回程路线也一起准备好。

            到现场后，跟着工作人员的指引走。紧张的时候先呼吸，不急着在脑子里重演所有问题。
            """
        ),
        post(
            "first-flight-after-approval", .photo, .unitedStates,
            "拿到签证后的第一段飞行",
            author: .amara, time: "5天前", likes: 1_462, comments: 57,
            image: "coverAirplaneWing", aspect: 1.0,
            summary: "终于不用再刷进度，可以认真看一会儿窗外了。",
            tags: ["初次出行", "飞行"], experience: true,
            body: """
            登机时还习惯性地检查了一遍护照。直到飞机开始滑行，才想起准备了那么久的旅行真的要开始了。

            窗外是很普通的一层云。我却拍了好几张，想留住那种终于出发的感觉。
            """
        ),
        post(
            "swiss-train", .photo, .schengen,
            "坐一段慢火车，穿过瑞士",
            author: .lucas, time: "5天前", likes: 438, comments: 14,
            image: "coverSwissAlps", aspect: 1.5,
            summary: "窗边坐着就很好，不需要每一站都下车。",
            tags: ["瑞士", "铁路"],
            body: """
            提前留了一天给铁路。只带轻便的包，不赶下一场预约，看到沿途的湖和村庄就多看一会儿。

            有一段没有拍照。回去后才觉得，能把手机放下也是旅行的一部分。
            """
        ),
        post(
            "copenhagen-budget", .photo, .schengen,
            "哥本哈根，预算有限也能慢慢玩",
            author: .mira, time: "6天前", likes: 329, comments: 18,
            image: "coverCopenhagen", aspect: 0.8,
            summary: "把钱留给早餐和一张交通卡，其余时间走着看。",
            tags: ["丹麦", "旅行预算"],
            body: """
            这次没有每天都进博物馆。上午去街区散步，中午在市场吃饭，下午找一个临水的地方休息。

            预算里最舍得花的是早餐。少换几次住处，也比到处找便宜一晚更省心。
            """
        ),
        post(
            "lake-braies", .photo, .schengen,
            "布莱埃斯湖，要早一点，也别太急",
            author: .lucas, time: "6天前", likes: 335, comments: 16,
            image: "coverLakeBraies", aspect: 1.5,
            summary: "在第一批人到来之前，沿湖走一段安静的路。",
            tags: ["意大利", "多洛米蒂"],
            body: """
            起得比平时早，但没有一路赶时间。到了湖边先喝热茶，再沿着步道慢慢走。

            水面很静，拍完第一张就把相机放回包里。还有很多风景，不必全部带走。
            """
        ),
        post(
            "first-solo-trip", .guide, .schengen,
            "第一次独自出国，我学会了慢一点",
            author: .sofia, time: "1周前", likes: 243, comments: 29,
            image: "coverTraveler", aspect: 0.75,
            summary: "签证是开始，真正的练习是一个人做每个小决定。",
            tags: ["独自旅行", "葡萄牙"], read: 6, experience: true,
            body: """
            第一天连进餐馆都要犹豫。后来发现不用把一整趟旅行安排得很厉害，每天找到住处、吃好饭就已经不错。

            把证件和重要地址离线存好，剩下的可以边走边学。这是我第一次觉得，自己也能照顾好一段远行。
            """
        ),
        post(
            "edinburgh-weather", .photo, .unitedKingdom,
            "爱丁堡，带把伞再出门",
            author: .fiona, time: "1周前", likes: 482, comments: 20,
            image: "coverEdinburgh", aspect: 1.5,
            summary: "等雨停的那一小会儿，城市会换一种颜色。",
            tags: ["苏格兰", "城市漫步"], experience: true,
            body: """
            上午下雨，我们就在窗边坐着。雨势小了再出去，街上的石头和屋顶都亮了一点。

            没有赶上所有想去的地方，却遇到了一家会想再去的书店。天气改了计划，也不全是坏事。
            """
        ),
        post(
            "cinque-terre", .photo, .schengen,
            "十月的五渔村，走一段就休息",
            author: .theo, time: "1周前", likes: 612, comments: 25,
            image: "coverCinqueTerre", aspect: 0.8,
            summary: "火车、海边和一顿午饭，已经足够填满一天。",
            tags: ["意大利", "海岸"],
            body: """
            我们没有一天走完所有村子。先选一处下车，沿着小路往海边走，走累了就坐下来。

            回程火车晚了一点，刚好多看一会儿海。把计划放松以后，这样的小事也变得可爱。
            """
        ),
        post(
            "slow-paris", .photo, .schengen,
            "在巴黎住五天，不急着去下一站",
            author: .mateo, time: "1周前", likes: 823, comments: 32,
            image: "coverParisEiffel", aspect: 0.75,
            summary: "把一家面包店走成熟路，也是一种旅行。",
            tags: ["法国", "城市漫步"],
            body: """
            每天早晨先去同一家面包店，再决定今天往哪个方向走。住得久一点，连地铁口都开始熟悉。

            想去的地方还是很多，但不必这次全部去完。我们把最后一晚留给河边，没有再补任何行程。
            """
        ),
        post(
            "rothenburg-rain", .photo, .schengen,
            "罗滕堡的一个雨天",
            author: .lucas, time: "2周前", likes: 214, comments: 8,
            image: "coverRothenburg", aspect: 0.8,
            summary: "雨伞收起又打开，小城适合这样慢慢逛。",
            tags: ["德国", "自驾"],
            body: """
            午后到城里时开始下雨。我们沿着有屋檐的街边走，临时进了一间不在收藏夹里的小店。

            雨停以后再去城墙边看看。原本只有半天的安排，最后成了这趟路上很喜欢的一站。
            """
        ),
        post(
            "visiting-family", .question, .unitedStates,
            "探亲邀请信，怎么把关系说清楚？",
            author: .leila, time: "2周前", likes: 132, comments: 30,
            summary: "不想照搬模板，想知道大家如何组织自己的情况。",
            tags: ["探亲", "材料整理"],
            body: """
            正在准备探亲行程，已经列出了拜访对象、预计时间和住处。想让邀请信和其他材料自然对应，不写成一封很长的解释。

            大家当时会单独附关系说明吗？只参考整理结构，具体要求仍会按官方页面确认。
            """
        ),
        post(
            "uk-visitor-differently", .guide, .unitedKingdom,
            "第二次办英签，我不再堆材料",
            author: .daniel, time: "2周前", likes: 247, comments: 35,
            image: "coverLaptopNotes", aspect: 1.5,
            summary: "先讲清行程和自己的情况，再决定需要哪些说明。",
            tags: ["材料整理", "出行准备"], read: 8, experience: true,
            body: """
            第一次准备时，我几乎把能想到的文件都放进去了。第二次先列问题：为什么去、去多久、费用怎么安排、回来继续做什么。

            围绕这些问题整理文件后，目录短了很多。提交前仍逐项对照要求，但不再用页数安慰自己。
            """
        ),
        post(
            "vienna-weekend", .photo, .schengen,
            "维也纳的周末，留半天给咖啡馆",
            author: .mira, time: "2周前", likes: 183, comments: 9,
            image: "coverVienna", aspect: 1.25,
            summary: "听一场音乐会，也认真吃一块蛋糕。",
            tags: ["奥地利", "周末"],
            body: """
            这趟只预订了一场演出。其余时间在市中心步行，路过喜欢的店就进去看看。

            周日下午下了雨，我们在咖啡馆坐到傍晚。没赶最后一处景点，反而很满足。
            """
        ),
        post(
            "over-atlantic", .photo, .unitedStates,
            "飞越大西洋，去一个新地方",
            author: .kenji, time: "2周前", likes: 326, comments: 12,
            image: "coverClouds", aspect: 1.5,
            summary: "落地前的那一小时，期待终于盖过了困意。",
            tags: ["初次出行", "飞行"], experience: true,
            body: """
            长途飞行大部分时间都很普通：吃饭、睡觉、再看一次航线。窗外开始亮起来时，才真正意识到已经离家很远。

            护照和住宿地址都放在随身的小包里。准备好这些之后，可以放心地看着飞机一点点接近目的地。
            """
        ),
        post(
            "cotswolds-sunday", .photo, .unitedKingdom,
            "科茨沃尔德的周日，不赶末班日落",
            author: .clara, time: "3周前", likes: 298, comments: 10,
            image: "coverCotswolds", aspect: 1.5,
            summary: "在村子里走走，再找一家还开着的茶室。",
            tags: ["英格兰", "周末"],
            body: """
            我们提前查好了回程交通，所以在村里不用一直盯着时间。沿着小河走，走到觉得够了就回头。

            下午在茶室坐了很久。对于周末短途，一点熟悉的秩序，反而能换来更多放松。
            """
        ),
        post(
            "amsterdam-slowly", .photo, .schengen,
            "阿姆斯特丹，沿运河慢慢走",
            author: .priya, time: "3周前", likes: 249, comments: 11,
            image: "coverAmsterdam", aspect: 0.75,
            summary: "不租车、不赶路，用步行把街区连起来。",
            tags: ["荷兰", "城市漫步"],
            body: """
            住处离运河很近，每次出门都先绕一小段。慢慢认得了附近的桥、超市和卖花的店。

            这次没有骑自行车。走得慢也很好，能看见门口的花和窗里的猫。
            """
        ),
        post(
            "onward-travel", .question, .schengen,
            "后续行程证明，大家怎么整理？",
            author: .priya, time: "3周前", likes: 155, comments: 21,
            summary: "交通方式有好几种，想让整条路线读起来更清楚。",
            tags: ["出行准备", "材料整理"],
            body: """
            目前确定了去程和回程，中间有一段可能坐火车。准备把已确认的订单和计划中的安排分开写，避免让人看不明白。

            大家会在行程单里加备注吗？欢迎分享版式，我会再按自己的申请要求核对。
            """
        ),
        post(
            "appointment-prep-guide", .guide, .schengen,
            "第一次线下递签，我的准备清单",
            author: .daniel, time: "3周前", likes: 198, comments: 26,
            tags: ["预约", "申请经历"], read: 5, experience: true,
            body: """
            前一晚只做最后核对，不再反复重写说明。证件、预约信息和材料目录放在最容易拿到的位置，其他物品按现场要求准备。

            路线和预计出门时间提前看好，到现场后按指引办理。把能准备的做好，其余事情就一步一步来。
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
