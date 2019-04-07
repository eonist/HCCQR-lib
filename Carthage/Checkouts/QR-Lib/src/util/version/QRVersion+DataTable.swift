import Foundation
/**
 * Data table (Version table)
 */
extension QRVersion{
   /**
    * - Note: This is stored once
    */
   internal static let versions:[Version] = {
      return [
         v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,
         v11,v12,v13,v14,v15,v16,v17,v18,v19,v20,
         v21,v22,v23,v24,v25,v26,v27,v28,v29,v30,
         v31,v32,v33,v34,v35,v36,v37,v38,v39,v40
      ]
   }()
}
/**
 * DataTable
 * - TODO: ⚠️️ v 7,8,0 for byte .l seems to have problems (figure it out)
 */
private extension QRVersion{
   private static let v1:Version = (numeric:(l:41,m:34,q:27,h:17), alphaNumeric:(l:25,m:20,q:16,h:10), byte:(l:17,m:14,q:11,h:7))
   private static let v2:Version = (numeric:(l:77,m:63,q:48,h:34), alphaNumeric:(l:47,m:38,q:29,h:20), byte:(l:32,m:26,q:20,h:14))
   private static let v3:Version = (numeric:(l:127,m:101,q:77,h:58), alphaNumeric:(l:77,m:61,q:47,h:35), byte:(l:53,m:42,q:32,h:24))
   private static let v4:Version = (numeric:(l:187,m:149,q:111,h:82), alphaNumeric:(l:114,m:90,q:67,h:50), byte:(l:78,m:62,q:46,h:34))
   private static let v5:Version = (numeric:(l:255,m:202,q:144,h:106), alphaNumeric:(l:154,m:122,q:87,h:64), byte:(l:106,m:84,q:60,h:44))
   private static let v6:Version = (numeric:(l:322,m:255,q:178,h:139), alphaNumeric:(l:195,m:154,q:108,h:84), byte:(l:134,m:106,q:74,h:58))
   private static let v7:Version = (numeric:(l:370,m:293,q:207,h:154), alphaNumeric:(l:224,m:178,q:125,h:93), byte:(l:154,m:122,q:86,h:64))
   private static let v8:Version = (numeric:(l:461,m:365,q:259,h:202), alphaNumeric:(l:279,m:221,q:157,h:122), byte:(l:192,m:152,q:108,h:84))
   private static let v9:Version = (numeric:(l:552,m:432,q:312,h:235), alphaNumeric:(l:335,m:262,q:189,h:143), byte:(l:230,m:180,q:130,h:98))
   private static let v10:Version = (numeric:(l:652,m:513,q:364,h:288), alphaNumeric:(l:395,m:311,q:221,h:174), byte:(l:271,m:213,q:151,h:119))
   private static let v11:Version = (numeric:(l:772,m:604,q:427,h:331), alphaNumeric:(l:468,m:366,q:259,h:200), byte:(l:321,m:251,q:177,h:137))
   private static let v12:Version = (numeric:(l:883,m:691,q:489,h:374), alphaNumeric:(l:535,m:419,q:296,h:227), byte:(l:367,m:287,q:203,h:155))
   private static let v13:Version = (numeric:(l:1022,m:796,q:580,h:427), alphaNumeric:(l:619,m:483,q:352,h:259), byte:(l:425,m:331,q:241,h:177))
   private static let v14:Version = (numeric:(l:1101,m:871,q:621,h:468), alphaNumeric:(l:667,m:528,q:376,h:283), byte:(l:458,m:362,q:258,h:194))
   private static let v15:Version = (numeric:(l:1250,m:991,q:703,h:530), alphaNumeric:(l:758,m:600,q:426,h:321), byte:(l:520,m:412,q:292,h:220))
   private static let v16:Version = (numeric:(l:1408,m:1082,q:775,h:602), alphaNumeric:(l:854,m:656,q:470,h:365), byte:(l:586,m:450,q:322,h:250))
   private static let v17:Version = (numeric:(l:1548,m:1212,q:876,h:674), alphaNumeric:(l:938,m:734,q:531,h:408), byte:(l:644,m:504,q:364,h:280))
   private static let v18:Version = (numeric:(l:1725,m:1346,q:948,h:746), alphaNumeric:(l:1046,m:816,q:574,h:452), byte:(l:718,m:560,q:394,h:310))
   private static let v19:Version = (numeric:(l:1903,m:1500,q:1063,h:813), alphaNumeric:(l:1153,m:909,q:644,h:493), byte:(l:792,m:624,q:442,h:338))
   private static let v20:Version = (numeric:(l:2061,m:1600,q:1159,h:919), alphaNumeric:(l:1249,m:970,q:702,h:557), byte:(l:858,m:666,q:482,h:382))
   private static let v21:Version = (numeric:(l:2232,m:1708,q:1224,h:969), alphaNumeric:(l:1352,m:1035,q:742,h:587), byte:(l:929,m:711,q:509,h:403))
   private static let v22:Version = (numeric:(l:2409,m:1872,q:1358,h:1056), alphaNumeric:(l:1460,m:1134,q:823,h:640), byte:(l:1003,m:779,q:565,h:439))
   private static let v23:Version = (numeric:(l:2620,m:2059,q:1468,h:1108), alphaNumeric:(l:1588,m:1248,q:890,h:672), byte:(l:1091,m:857,q:611,h:461))
   private static let v24:Version = (numeric:(l:2812,m:2188,q:1588,h:1228), alphaNumeric:(l:1704,m:1326,q:963,h:744), byte:(l:1171,m:911,q:661,h:511))
   private static let v25:Version = (numeric:(l:3057,m:2395,q:1718,h:1286), alphaNumeric:(l:1853,m:1451,q:1041,h:779), byte:(l:1273,m:997,q:715,h:535))
   private static let v26:Version = (numeric:(l:3283,m:2544,q:1804,h:1425), alphaNumeric:(l:1990,m:1542,q:1094,h:864), byte:(l:1367,m:1059,q:751,h:593))
   private static let v27:Version = (numeric:(l:3517,m:2701,q:1933,h:1501), alphaNumeric:(l:2132,m:1637,q:1172,h:910), byte:(l:1465,m:1125,q:805,h:625))
   private static let v28:Version = (numeric:(l:3669,m:2857,q:2085,h:1581), alphaNumeric:(l:2223,m:1732,q:1263,h:958), byte:(l:1528,m:1190,q:868,h:658))
   private static let v29:Version = (numeric:(l:3909,m:3035,q:2181,h:1677), alphaNumeric:(l:2369,m:1839,q:1322,h:1016), byte:(l:1628,m:1264,q:908,h:698))
   private static let v30:Version = (numeric:(l:4158,m:3289,q:2358,h:1782), alphaNumeric:(l:2520,m:1994,q:1429,h:1080), byte:(l:1732,m:1370,q:982,h:742))
   private static let v31:Version = (numeric:(l:4417,m:3486,q:2473,h:1897), alphaNumeric:(l:2677,m:2113,q:1499,h:1150), byte:(l:1840,m:1452,q:1030,h:790))
   private static let v32:Version = (numeric:(l:4686,m:3693,q:2670,h:2022), alphaNumeric:(l:2840,m:2238,q:1618,h:1226), byte:(l:1952,m:1538,q:1112,h:842))
   private static let v33:Version = (numeric:(l:4965,m:3909,q:2805,h:2157), alphaNumeric:(l:3009,m:2369,q:1700,h:1307), byte:(l:2068,m:1628,q:1168,h:898))
   private static let v34:Version = (numeric:(l:5253,m:4134,q:2949,h:2301), alphaNumeric:(l:3183,m:2506,q:1787,h:1394), byte:(l:2188,m:1722,q:1228,h:958))
   private static let v35:Version = (numeric:(l:5529,m:4343,q:3081,h:2361), alphaNumeric:(l:3351,m:2632,q:1867,h:1431), byte:(l:2303,m:1809,q:1283,h:983))
   private static let v36:Version = (numeric:(l:5836,m:4588,q:3244,h:2524), alphaNumeric:(l:3537,m:2780,q:1966,h:1530), byte:(l:2431,m:1911,q:1351,h:1051))
   private static let v37:Version = (numeric:(l:6153,m:4775,q:3417,h:2625), alphaNumeric:(l:3729,m:2894,q:2071,h:1591), byte:(l:2563,m:1989,q:1423,h:1093))
   private static let v38:Version = (numeric:(l:6479,m:5039,q:3599,h:2735), alphaNumeric:(l:3927,m:3054,q:2181,h:1658), byte:(l:2699,m:2099,q:1499,h:1139))
   private static let v39:Version = (numeric:(l:6743,m:5313,q:3791,h:2927), alphaNumeric:(l:4087,m:3220,q:2298,h:1774), byte:(l:2809,m:2213,q:1579,h:1219))
   private static let v40:Version = (numeric:(l:7089,m:5596,q:3993,h:3057), alphaNumeric:(l:4296,m:3391,q:2420,h:1852), byte:(l:2953,m:2331,q:1663,h:1273))
}

