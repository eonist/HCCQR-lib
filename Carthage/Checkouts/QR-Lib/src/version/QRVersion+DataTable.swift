import Foundation

/**
 * Data table (Version table)
 */
internal extension QRVersion{
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
 */
private extension QRVersion{
   private static let v1:Version = (numeric:(l:38,m:31,q:24,h:14), alphaNumeric:(l:23,m:18,q:14,h:8), byte:(l:16,m:13,q:10,h:6))
   private static let v2:Version = (numeric:(l:74,m:60,q:45,h:31), alphaNumeric:(l:45,m:36,q:27,h:18), byte:(l:31,m:25,q:19,h:13))
   private static let v3:Version = (numeric:(l:124,m:98,q:74,h:55), alphaNumeric:(l:75,m:59,q:45,h:33), byte:(l:52,m:41,q:31,h:23))
   private static let v4:Version = (numeric:(l:184,m:146,q:108,h:79), alphaNumeric:(l:112,m:88,q:65,h:48), byte:(l:77,m:61,q:45,h:33))
   private static let v5:Version = (numeric:(l:252,m:199,q:141,h:103), alphaNumeric:(l:152,m:120,q:85,h:62), byte:(l:105,m:83,q:59,h:43))
   private static let v6:Version = (numeric:(l:319,m:252,q:175,h:136), alphaNumeric:(l:193,m:152,q:106,h:82), byte:(l:133,m:105,q:73,h:57))
   private static let v7:Version = (numeric:(l:367,m:290,q:204,h:151), alphaNumeric:(l:222,m:176,q:123,h:91), byte:(l:153,m:121,q:85,h:63))
   private static let v8:Version = (numeric:(l:458,m:362,q:256,h:199), alphaNumeric:(l:277,m:219,q:155,h:120), byte:(l:191,m:151,q:107,h:83))
   private static let v9:Version = (numeric:(l:549,m:429,q:309,h:232), alphaNumeric:(l:333,m:260,q:187,h:141), byte:(l:229,m:179,q:129,h:97))
   private static let v10:Version = (numeric:(l:650,m:511,q:362,h:285), alphaNumeric:(l:394,m:309,q:219,h:173), byte:(l:271,m:213,q:151,h:119))
   private static let v11:Version = (numeric:(l:770,m:602,q:424,h:328), alphaNumeric:(l:466,m:365,q:257,h:199), byte:(l:321,m:251,q:177,h:137))
   private static let v12:Version = (numeric:(l:880,m:688,q:487,h:372), alphaNumeric:(l:533,m:417,q:295,h:225), byte:(l:367,m:287,q:203,h:155))
   private static let v13:Version = (numeric:(l:1020,m:794,q:578,h:424), alphaNumeric:(l:618,m:481,q:350,h:257), byte:(l:425,m:331,q:241,h:177))
   private static let v14:Version = (numeric:(l:1099,m:868,q:619,h:465), alphaNumeric:(l:666,m:526,q:375,h:282), byte:(l:458,m:362,q:258,h:194))
   private static let v15:Version = (numeric:(l:1248,m:988,q:700,h:528), alphaNumeric:(l:756,m:599,q:424,h:320), byte:(l:520,m:412,q:292,h:220))
   private static let v16:Version = (numeric:(l:1406,m:1080,q:772,h:600), alphaNumeric:(l:852,m:654,q:468,h:363), byte:(l:586,m:450,q:322,h:250))
   private static let v17:Version = (numeric:(l:1545,m:1209,q:873,h:672), alphaNumeric:(l:936,m:733,q:529,h:407), byte:(l:644,m:504,q:364,h:280))
   private static let v18:Version = (numeric:(l:1723,m:1344,q:945,h:744), alphaNumeric:(l:1044,m:814,q:573,h:450), byte:(l:718,m:560,q:394,h:310))
   private static let v19:Version = (numeric:(l:1900,m:1497,q:1060,h:811), alphaNumeric:(l:1152,m:907,q:642,h:491), byte:(l:792,m:624,q:442,h:338))
   private static let v20:Version = (numeric:(l:2059,m:1598,q:1156,h:916), alphaNumeric:(l:1248,m:968,q:701,h:555), byte:(l:858,m:666,q:482,h:382))
   private static let v21:Version = (numeric:(l:2229,m:1706,q:1221,h:967), alphaNumeric:(l:1351,m:1034,q:740,h:586), byte:(l:929,m:711,q:509,h:403))
   private static let v22:Version = (numeric:(l:2407,m:1869,q:1356,h:1053), alphaNumeric:(l:1458,m:1133,q:821,h:638), byte:(l:1003,m:779,q:565,h:439))
   private static let v23:Version = (numeric:(l:2618,m:2056,q:1466,h:1106), alphaNumeric:(l:1586,m:1246,q:888,h:670), byte:(l:1091,m:857,q:611,h:461))
   private static let v24:Version = (numeric:(l:2810,m:2186,q:1586,h:1226), alphaNumeric:(l:1703,m:1325,q:961,h:743), byte:(l:1171,m:911,q:661,h:511))
   private static let v25:Version = (numeric:(l:3055,m:2392,q:1716,h:1284), alphaNumeric:(l:1851,m:1450,q:1040,h:778), byte:(l:1273,m:997,q:715,h:535))
   private static let v26:Version = (numeric:(l:3280,m:2541,q:1802,h:1423), alphaNumeric:(l:1988,m:1540,q:1092,h:862), byte:(l:1367,m:1059,q:751,h:593))
   private static let v27:Version = (numeric:(l:3516,m:2700,q:1932,h:1500), alphaNumeric:(l:2130,m:1636,q:1170,h:909), byte:(l:1465,m:1125,q:805,h:625))
   private static let v28:Version = (numeric:(l:3667,m:2856,q:2083,h:1579), alphaNumeric:(l:2222,m:1730,q:1262,h:957), byte:(l:1528,m:1190,q:868,h:658))
   private static let v29:Version = (numeric:(l:3907,m:3033,q:2179,h:1675), alphaNumeric:(l:2368,m:1838,q:1320,h:1015), byte:(l:1628,m:1264,q:908,h:698))
   private static let v30:Version = (numeric:(l:4156,m:3288,q:2356,h:1780), alphaNumeric:(l:2519,m:1992,q:1428,h:1079), byte:(l:1732,m:1370,q:982,h:742))
   private static let v31:Version = (numeric:(l:4416,m:3484,q:2472,h:1896), alphaNumeric:(l:2676,m:2112,q:1498,h:1149), byte:(l:1840,m:1452,q:1030,h:790))
   private static let v32:Version = (numeric:(l:4684,m:3691,q:2668,h:2020), alphaNumeric:(l:2839,m:2237,q:1617,h:1224), byte:(l:1952,m:1538,q:1112,h:842))
   private static let v33:Version = (numeric:(l:4963,m:3907,q:2803,h:2155), alphaNumeric:(l:3008,m:2368,q:1698,h:1306), byte:(l:2068,m:1628,q:1168,h:898))
   private static let v34:Version = (numeric:(l:5251,m:4132,q:2947,h:2299), alphaNumeric:(l:3182,m:2504,q:1786,h:1393), byte:(l:2188,m:1722,q:1228,h:958))
   private static let v35:Version = (numeric:(l:5527,m:4341,q:3079,h:2359), alphaNumeric:(l:3349,m:2631,q:1866,h:1429), byte:(l:2303,m:1809,q:1283,h:983))
   private static let v36:Version = (numeric:(l:5834,m:4586,q:3242,h:2522), alphaNumeric:(l:3536,m:2779,q:1965,h:1528), byte:(l:2431,m:1911,q:1351,h:1051))
   private static let v37:Version = (numeric:(l:6151,m:4773,q:3415,h:2623), alphaNumeric:(l:3728,m:2893,q:2069,h:1589), byte:(l:2563,m:1989,q:1423,h:1093))
   private static let v38:Version = (numeric:(l:6477,m:5037,q:3597,h:2733), alphaNumeric:(l:3925,m:3053,q:2180,h:1656), byte:(l:2699,m:2099,q:1499,h:1139))
   private static let v39:Version = (numeric:(l:6741,m:5311,q:3789,h:2925), alphaNumeric:(l:4085,m:3218,q:2296,h:1773), byte:(l:2809,m:2213,q:1579,h:1219))
   private static let v40:Version = (numeric:(l:7087,m:5594,q:3991,h:3055), alphaNumeric:(l:4295,m:3390,q:2418,h:1851), byte:(l:2953,m:2331,q:1663,h:1273))
}
