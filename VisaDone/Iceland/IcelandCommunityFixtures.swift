import SwiftUI

// Appended after the curated Discovery feed, so its first-screen composition stays intact.
enum IcelandCommunityFixtures {
    static let posts:[DiscoveryPost] = [
        .init(id:"supporting-home-ties",format:.guide,region:.schengen,title:"补充材料，我按家庭、工作和居住分了三组",summary:"结婚证、房产资料与社保记录各自说明什么，按自己的情况选择。",body:"我准备补充材料时，没有把能找到的证件全部堆进去，而是按家庭、工作、居住分成三组。已婚就把结婚证放在家庭关系一组；有自己的房产，再放相关产权资料；社保记录则和在职、收入、准假安排一起整理。\n\n我另外核对了休假结束后的返岗日期，让它与行程对应。没有某项资料也不硬凑，选择真正能解释自己情况的文件。\n\n这是个人整理经验，补充资料不等于所有人的统一必交清单。",coverImage:"coverNotes",coverAspectRatio:1.2,tags:["补充材料","整理经验"],author:.daniel,timeLabel:"3天前",likeCount:136,commentCount:18,readMinutes:3,isExperience:true),
        .init(id:"document-copy-folder",format:.guide,region:.schengen,title:"递交当天，我多带了一袋备用复印件",summary:"护照、身份证和户口簿分开装，递交份和自留份各一套。",body:"我把正式递交资料按官方清单排序，另外装了一袋备用复印件：护照信息页多备几份，身份证正反面和户口簿相关页面也各留了一套。\n\n这样现场需要核对时，不用再从订好的整套材料里拆页。离开中心前，我把递交收据和后续领取说明单独放好，回家后也保留了一份扫描件。\n\n备用份数只是我的做法，正式提交的页数和范围仍按自己申请地的清单核对。",coverImage:"coverTravelDesk",coverAspectRatio:1.2,tags:["补充材料","整理经验"],author:.ravi,timeLabel:"3天前",likeCount:136,commentCount:18,readMinutes:3,isExperience:true),
        .init(id:"passport-collection-notes",format:.guide,region:.schengen,title:"护照交出去以后，领取资料我这样留着",summary:"护照复印件、递交收据和领取通知分开保存。",body:"递交后原护照暂时不在手上，我保留了护照信息页复印件和递交收据，收到领取通知后再一起核对。\n\n有人分享过领取时需要出示护照复印件的经历，所以我也额外备了几份。但领取或代领究竟要带哪些证件，还是以自己收到的中心通知为准，复印件不是唯一凭证。\n\n这条是社区中的个人整理样例，方便大家交流领取环节需要保留哪些东西。",coverImage:"coverNotes",coverAspectRatio:1.2,tags:["补充材料","整理经验"],author:.daniel,timeLabel:"3天前",likeCount:136,commentCount:18,readMinutes:3,isExperience:true),
        .init(id:"adult-student-materials",format:.guide,region:.schengen,
              title:"成年学生，我把在读和假期资料放在一组",summary:"在读证明、学籍报告与出行日期一起整理，说明自己的情况。",
              body:"我这次是成年在读学生，和父母一起申请冰岛旅游签证。我把在读证明、学籍报告和出行日期放在一起，另外列了费用由谁承担。\n\n这些是我这次用于解释个人情况的资料，没有把未成年人条款照搬过来。是否需要补充某一份文件，仍按自己的申请条件核对。\n\n公开分享的是整理方法，已删去姓名、学校及证件信息。",
              coverImage:"coverNotes",coverAspectRatio:1.2,tags:["冰岛旅游","成年学生","在读证明"],author:.daniel,timeLabel:"2天前",likeCount:168,commentCount:24,readMinutes:3,isExperience:true),
        .init(id:"parent-sponsored-trip",format:.guide,region:.schengen,
              title:"母亲资助旅行，我补了一页费用说明",summary:"收入、流水与资助关系分开整理，再用一页说明串起来。",
              body:"和父母一起出行，主要费用由母亲承担。我先整理资助人的收入、流水和身份文件，再用一页说明交代费用承担及我们之间的关系。\n\n申请人本人是成年学生，自己的在读情况和已有资金记录也保留。亲属关系资料在这里用来解释资助关系，不是所有成年申请人的统一材料清单。\n\n这是一份个人准备经历，希望大家讨论时也补充身份和申请地。",
              coverImage:"coverTravelDesk",coverAspectRatio:1.3,tags:["冰岛旅游","家庭资助","资金材料"],author:.ravi,timeLabel:"4天前",likeCount:206,commentCount:19,readMinutes:3,isExperience:true)
    ]
}
