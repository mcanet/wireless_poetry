#!/usr/bin/env python
import urllib2
import httplib, base64
from httplib2 import Http
from urllib import urlencode

username = "root"
password = ""
auth = base64.encodestring("%s:%s" % (username, password))
headers = {"Authorization" : "Basic %s" % auth}

conn = httplib.HTTPConnection("192.168.11.1")
conn.request("GET", "/wlan_basic.html", headers=headers)
response = conn.getresponse()
data = response.read()
print data
conn.close()