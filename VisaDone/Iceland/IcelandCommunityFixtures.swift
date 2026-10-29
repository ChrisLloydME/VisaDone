import SwiftUI

// Appended after the curated Discovery feed, so its first-screen composition stays intact.
enum IcelandCommunityFixtures {
    static let posts:[DiscoveryPost] = [
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
