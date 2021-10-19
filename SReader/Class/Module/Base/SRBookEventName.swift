//
//  SRBookEventName.swift
//  SReader
//
//  Created by JunMing on 2020/4/18.
//  Copyright © 2020 JunMing. All rights reserved.
//

import Foundation

// 宽度
public let kWidth = UIScreen.main.bounds.size.width
// 高度
public let kHeight = UIScreen.main.bounds.size.height

// 存储下载次数key
public let downCount = "count_key"
public let downTime = "time_key"
/// 校验购买Key
public let verify = "verify".localKey

public let kBookEventSwitchDomanAction = "kBookEventSwitchDomanAction"
/// 🈳️白占位
public let kBookEventEmptyTableView = "kBookEventEmptyTableView"

/// 🈳️白占位
public let kBookEventShareBkgColor = "kBookEventShareBkgColor"
public let kBookEventShareSaveToLib = "kBookEventShareSaveToLib"
public let kBookEventShareToWeChat = "kBookEventShareToWeChat"

// 顶部header每个Item的eventName
public let kBookEventClassify = "kBookEventClassify"
public let kBookEventSubject = "kBookEventSubject"
public let kBookEventWishList = "kBookEventWishList"
public let kBookEventRankList = "kBookEventRankList"
public let kBookEventNewBooks = "kBookEventNewBooks"

public let kBookEvent_Index_one = "kBookEventTopScroll_Index_one"
public let kBookEvent_index_two = "kBookEventTopScroll_index_two"
public let kBookEvent_index_thr = "kBookEventTopScroll_index_thr"
public let kBookEvent_index_four = "kBookEventTopScroll_index_four"

// 控制器cell的eventName
public let kBookEventDidSelect = "kBookEventDidSelect"
// 转跳Detail控制器
public let kBookEventNameJumpDetail = "kBookEventNameJumpDetail"
// 分类消息
public let kBookEventNameClassifyAction = "kBookEventNameClassifyAction"
// 专题消息
public let kBookEventNameSubjectAction = "kBookEventNameSubjectAction"
// 点击心愿单
public let kBookEventNameWishlistAction = "kBookEventNameWishlistAction"
/// 根据作者查询
public let kBookEventQueryAuthor = "kBookEventQueryAuthor"
/// 根据图书类型查询
public let kBookEventQueryBookType = "kBookEventQueryBookType"
/// 根据图书标题查询
public let kBookEventQueryBookTitle = "kBookEventQueryBookTitle"
// 广告
public let kBookEventADSelect = "kBookEventADSelect"
// 目录
public let kBookEventContentSelect = "kBookEventContentSelect"
// 点击更多
public let kBookEventNameMoreAction = "kBookEventNameMoreAction"
public let kBookEventChange = "kBookEventChange"
// 设置控制器
public let kBookEventLogIn_Out = "kBookEventLogIn_Out"
public let kBookEventMyReader = "kBookEventMyReader"
public let kBookEventCleanCache = "kBookEventCleanCache"
public let kBookEventRecoFriend = "kBookEventRecommFriend"
public let kBookEventCommentToAppstore = "kBookEventCommentToAppstore"
public let kBookEventMySave = "kBookEventMySave"
public let kBookEventFeedBack = "kBookEventFeedBack"
public let kBookEventMyDownload = "kBookEventMyDownload"
public let kBookEventSetSign = "kBookEventSetSign"
public let kBookEventAboutUs = "kBookEventAboutUs"

public let kBookEventMyCharge = "kBookEventMyCharge"
public let kBookEventMyHasbuy = "kBookEventMyHasbuy"
public let kBookEventSetting = "kBookEventSetting"

// 登录按钮消息
public let kBookEventLogInAction = "kBookEventLogInAction"

// 移除alertView的消息
public let kBookEventRemove_ALERT = "kBookEventRemove_ALERT"
/// 展示购买页面
public let kBookEvent_ALERT_SHOW_BUY = "kBookEvent_ALERT_SHOW_BUY"
/// 开始购买
public let kBookEvent_ALERT_START_BUY = "kBookEvent_ALERT_START_BUY"
/// 展示特权
public let kBookEvent_ALERT_SHOW_INFO = "kBookEvent_ALERT_SHOW_INFO"

/// 分享到微信
public let kBookEventALERT_SHARE_INFO = "kBookEventALERT_SHARE_INFO"
/// 专题点击Cell转跳
public let kBookEventTopicContent = "kBookEventTopicContent"
/// 移除PickerView
public let kBookEventPickerViewSelect = "kBookEventPickerViewSelect"


// ------- SRBookDetailController -------
// 控制器cell的eventName
public let kBookEventDetailCharpter = "kBookEventDetailCharpter"
// 控制器cell的eventName
public let kBookEventDetailComment = "kBookEventDetailComment"
// 控制器cell的eventName
public let kBookEventDetailReward = "kBookEventDetailReward"
/// 展示作者信息
public let kBookEventAuthorInfo = "kBookEventAuthorInfo"
// 详情页面打开图书
public let kBookEventDetailOpenBook = "kBookEventDetailOpenBook"
// 查看章节目录
public let kBookEventChapterUpdate = "kBookEventChapterUpdate"
// 写评论
public let kBookEventWriteComment = "kBookEventWriteComment"
// 查看所有评论评论
public let kBookEventJumpCommentPage = "kBookEventJumpCommentPage"
// 打赏按钮
public let kBookEventShowReward = "kBookEventShowReward"
// 打赏按钮
public let kBookEventJumpRewardPage = "kBookEventJumpRewardPage"
// 开始打赏
public let kBookEventStartReward = "kBookEventStartReward"
// 开始充值
public let kBookEventStartCharge = "kBookEventStartCharge"

// ------- SRChapterController -------
// 排序
public let kBookEventSortCharpters = "kBookEventSortCharpters"
// 打开章节
public let kBookEventOpenBookByCharpter = "kBookEventOpenBookByCharpter"

// ------- SRBookShelfController -------
// 书架页面选中图书
public let kBookEventShelfSelectBook = "kBookEventShelfSelectBook"
// 书架页点击cell
public let kBookEventSheftOpenBook = "kBookEventSheftOpenBook"


// ------- SRBookSetController -------
/// 我的阅读
public let kBookEventGoMyRead = "kBookEventGoMyRead"
/// 下载历史
public let kBookEventGoDownloadHistory = "kBookEventGoDownloadHistory"
/// wifi传书
public let kBookEventGoWifiBook = "kBookEventGoWifiBook"
/// 关于我们
public let kBookEventGoAboutUs = "kBookEventGoAboutUs"
/// 用户反馈
public let kBookEventGoFeedback = "kBookEventGoFeedback"
/// 清空缓存
public let kBookEventClearnCache = "kBookEventClearnCache"
/// 推荐好友
public let kBookEventRecomment = "kBookEventRecomment"
/// 好评支持一下
public let kBookEventGoAppstore = "kBookEventGoAppstore"
/// 每日阅读任务
public let kBookEventTodayRead = "kBookEventTodayRead"
/// 看广告
public let kBookEventWatchGoogleAd = "kBookEventWatchGoogleAd"
/// 签到
public let kBookEventTodaySign = "kBookEventTodaySign"
/// 去书城
public let kBookEventGotoBookCity = "kBookEventGotoBookCity"
/// 去听书
public let kBookEventGotoListenBook = "kBookEventGotoListenBook"
/// 分享好友
public let kBookEventShareFriends = "kBookEventShareFriends"
/// 去充值
public let kBookEventGotoCharge = "kBookEventGotoCharge"
/// 去评论
public let kBookEventGotoComment = "kBookEventGotoComment"
/// 点击金币按钮
public let kBookEventClickAllCoins = "kBookEventClickAllCoins"
/// 去签到
public let kBookEventEveydaySigns = "kBookEventEveydaySigns"
public let kBookEventGoComment = "kBookEventGoComment"
public let kBookEventGoReward = "kBookEventGoReward"

// ------- SRBookSetController -------
public let kBookEventSearchDidSelect = "kBookEventSearchDidSelect"
public let kBookEventHotSearchDidSelect = "kBookEventHotSearchDidSelect"
/// 管理续费
public let kBookEventManagerVip = "kBookEventManagerVip"
/// 转跳隐私等
public let kBookEventJumpYinSi = "kBookEventJumpYinSi"
/// 同意隐私
public let kBookEventTongYiYinSi = "kBookEventTongYiYinSi"
/// 不同意隐私
public let kBookEventBuTongYiYinSi = "kBookEventBuTongYiYinSi"
