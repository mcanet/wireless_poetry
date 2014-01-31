// ***************************************************************************************
// Script to phantomjs
// Date creation: February 5, 2013 (Seoul)
// Author: Mar Canet (mar.canet@gmail.com) and Varvara Guljajeva (varvarag@gmail.com)
// Authentification to router: BUFFALO M150
// ***************************************************************************************

// Script use: phantomjs router.js wifiName1 wifiName2 wifiName3 wifiName4

var page = require('webpage').create(),
    //system = require('system'),
    t, address;
var system = require('system');
var wifiNames = [];
if (system.args.length >= 1){
	wifiNames[0] = system.args[1];
}else{
	wifiNames[0] = '';
}
if (system.args.length >= 2){
	wifiNames[1] = system.args[2];
}else{
	wifiNames[1] = '';
}
if (system.args.length >= 3){
	wifiNames[2] = system.args[3];
}else{
	wifiNames[2] = '';
}
if (system.args.length >= 4){
	wifiNames[3] = system.args[4];
}else{
	wifiNames[3] = '';
}

function setGlobal(page, name, data) {
    var json = JSON.stringify(data);
    var fn = 'return window[' + JSON.stringify(name) + ']=' + json + ';';
    return page.evaluate(new Function(fn));
}

page.settings.userName = 'root';
page.settings.password = '';

page.onLoadStarted = function() {
  loadInProgress = true;
  console.log("load started");
};

page.onLoadFinished = function() {
  loadInProgress = false;
  console.log("load finished");
};

t = Date.now();
address = 'http://192.168.11.1/wlan_basic.html#'+wifiNames[0]+'|'+wifiNames[1]+'|'+wifiNames[2]+'|'+wifiNames[3];
page.open(address, function (status) {
    if (status !== 'success') {
        console.log('FAIL to load the address');
    } else {
    	
        t = Date.now() - t;
        console.log(page.evaluate(function () {      	
    	
    	var arWifiNames = (document.URL.split("#"))[1].split("%7C")
		
        // STEP1 : FILL FORM 
        var input1 = document.getElementById('id_WIFISsid0');
        var input1Str = arWifiNames[0].replace(/_/g," ");
        input1.value = input1Str; 
        var input2 = document.getElementById('id_WIFISsid1');
        var input2Str = arWifiNames[1].replace(/_/g," ");
        input2.value = input2Str; 
        var input3 = document.getElementById('id_WIFISsid2');
        var input3Str = arWifiNames[2].replace(/_/g," ");
        input3.value = input3Str; 
        var input4 = document.getElementById('id_WIFISsid3');
        var input4Str = arWifiNames[3].replace(/_/g," ");
        input4.value = input4Str;
      	
      	// STEP2 : SEND FORM
      	apply(); // apply is method in the page of the router
      	
        return "exit";
        }));
        
        console.log('Page title is ' + page.evaluate(function () {
            return document.title;
        }));
        console.log('Loading time ' + t + ' msec');
        
    }
    //phantom.exit();
});

var time = 20,
interval = setInterval(function(){
	if ( time > 0 ) {
    	time-=1;
		console.log(time);
	}else{
		console.log("BLAST OFF!");
    	phantom.exit();
	}
}, 1000);	