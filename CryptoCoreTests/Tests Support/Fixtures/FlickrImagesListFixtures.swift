//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

class FlickrImagesListFixtures {

    static var resultsJson: String {
        return """
        {
            "photos": {
            "page": 1,
            "pages": 2921,
            "perpage": 100,
            "total": "292073",
            "photo": [
              {
                "id": "28033364809",
                "owner": "132791403@N08",
                "secret": "f5a3538047",
                "server": "4614",
                "farm": 5,
                "title": "first image title",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "39102310894",
                "owner": "45737848@N07",
                "secret": "afc23e8e75",
                "server": "4700",
                "farm": 5,
                "title": "Bookshelf - 1 - Version 5",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "39102310244",
                "owner": "45737848@N07",
                "secret": "a3093da313",
                "server": "4710",
                "farm": 5,
                "title": "Bookshelf",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "28033363269",
                "owner": "142419869@N05",
                "secret": "2157146eab",
                "server": "4626",
                "farm": 5,
                "title": "title",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "38913232085",
                "owner": "78826860@N03",
                "secret": "4648db2829",
                "server": "4701",
                "farm": 5,
                "title": "title",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "39780320552",
                "owner": "80048637@N02",
                "secret": "a50bcd6f9e",
                "server": "4632",
                "farm": 5,
                "title": "#Earth Cutthroat Pass, WA North Cascades [1776x1200] [OC]",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "24941851247",
                "owner": "153866415@N06",
                "secret": "26dbfec1cb",
                "server": "4711",
                "farm": 5,
                "title": "Birthday Quotes : H. Joyeux anniversaire Stamp",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              }
            ]
          },
          "stat": "ok"
        }
        """
    }

    static var errorJson: String {
        return """
        {
            "stat": "fail",
            "code": 112,
            "message": "Something went wrong"
        }
        """
    }
}
