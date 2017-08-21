//
//  Config.swift
//  someone
//
//  Created by zxf on 2017/4/25.
//  Copyright © 2017年 zxf. All rights reserved.
//  相关配置

import UIKit

//: 基础动态库(libicucore.tdb,libz.tdb,libstdc++.tdb,JavaScriptCore.framework)
//: ShareSDK 相关 (http://dashboard.mob.com/)
let SHARESDK_APP_KEY = "1d0572a9b388c"
let SHARESDK_APP_SECRET = "52eb18eae68cdccbd8bdd68c626d5fb2"

//: 依赖动态库 (libsqlite3.tdb)
//: QQ 相关 (http://open.qq.com/)
//: URL Schemes QQ41ECF175 转换方法:(echo 'ibase=10obase=161106047349'|bc)
let QQ_APP_ID = "101399014"
let QQ_APP_KEY = "85edc6c98e33071c9ab74d2f5783fec5"

//: 依赖动态库 (libsqlite3.tdb)
//: 微信 相关 (http://open.weixin.qq.com/)
//: 微信开发者平台收费,审核通过
let WX_APP_ID = "wxf9b24d55bdb6901d"
let WX_APP_SECRET = "f3a5e0a5656cae16cc34809d607ceaf8"

//: 依赖动态库 (libsqlite3.tdb,mageIO.framework)
//: Sina微博
let WB_APP_KEY = "2702866808"
let WB_APP_SECRET = "6ced93260cb1da4ea0cd8d932d358d25"
let WB_REDIRECT_URL = "https://www.fuwan369.com"

//: 依赖动态库 (MessageUI.framework)
//: 短信验证

let DOMAIN = "https://www.fuwan369.com/"
let BASE_URL = "https://www.fuwan369.com/index.php"

let WEB_VIEW_CACHE_DB = "webviewCache.db"

let Load_AD_URL=BASE_URL+"/api/ad/indexs/type/"
let BOOT_PAGE_URL=BASE_URL+"/api/ad/index/type/boot_page"
let VERIFY_IMG_CODE=BASE_URL+"/api/checkcode/index/font_size/20/use_curve/0"
let REGISTER_URL=BASE_URL+"/user/index/register/"
let FORGET_PASSWORD_URL=BASE_URL+"/user/index/forget_password/"
let SEARCH_URL=BASE_URL+"/items/category/lists/keyword/"
let MODULE_URL=BASE_URL+"/items/module/index?module="
let LOGIN_URL=BASE_URL+"/api/user/login"
let LOC_URL=BASE_URL+"/api/user/loc"
let AREA_URL=BASE_URL+"/api/city/change"
let SEARCH_PAGE=BASE_URL+"/items/category/search/"
let CATEGORY_URL=BASE_URL+"/items/module/all"
let UCENTER_URL=BASE_URL+"/user/center/index"
let MCENTER_URL=BASE_URL+"/merchant/mcenter/index"
