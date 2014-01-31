#!/usr/bin/env python
import urllib2
import httplib, base64
from httplib2 import Http
from urllib import urlencode

username = "root"
password = ""
auth = base64.encodestring("%s:%s" % (username, password))
headers = {"Authorization" : "Basic %s" % auth}
headers_form = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain","Authorization" : "Basic %s" % auth }

conn = httplib.HTTPConnection("192.168.11.1")
post_urlencode = "WIFISecMode=2&WIFIModuleEnable=1&WIFIChannel=0&WIFIHTBW=0&WIFIHideSSID1=0&WIFISsid0Enable=1&WIFIGuestPort0=0&nosave_usessid0=1&WIFISsid0=i_em_cansa_molt_el_cami_que_no_f&WIFIAuthType0=OPEN&WIFIEncrypType0=NONE&WIFISsid1Enable=1&WIFIGuestPort1=0&nosave_usessid1=1&WIFISsid1=i_la_incertesa_estulta_de_les_ho&WIFIAuthType1=OPEN&WIFIEncrypType1=NONE&WIFISsid2Enable=1&WIFIAuthType2=WPAPSK&WIFIEncrypType2=AES&WIFIGuestPort2=0&nosave_usessid2=1&WIFISsid2=-&WIFISsid3Enable=1&WIFIAuthType3=OPEN&WIFIEncrypType3=WEP&WIFIGuestPort3=0&nosave_usessid3=1&WIFISsid3=Fragil%2C_el_temps_se_m%27esmenussa_&nosave_WIFIWEPKey1Type_S3=H10&WIFIWEPKeyIndex3=1&WIFIWEPKey2_S3=&WIFIWEPKey3_S3=&WIFIWEPKey4_S3=&WIFIRekeyInterval=60"
#conn.request("/GET", "/wlan_basic.html", headers=headers)
conn.request("GET", "/wlan_basic.html",post_urlencode, headers=headers_form)
response = conn.getresponse()
data = response.read()
print data
conn.close()


