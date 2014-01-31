#!/usr/bin/env python
import os
import time
import unicodedata
import string

class wifiPoem:
	def __init__(self):
		# this could change depending router
		self.totalWifiHospots = 4
		# Create a list for all poetry lines
		self.poemArByLines = list()
		self.currentpoemLines = list()
		# File for the poetry
		txtFile ='poems.txt'
		# Open poetry file  
		f = open(txtFile)
		for line in f:
			# Get read of accents
			lineClean = self.remove_accents(line.rstrip())
			# Get read of spaces
			lineClean = lineClean.rstrip().replace(" ", '_').replace('"', "'")
			if lineClean=="":
				lineClean = "-"
			if len(lineClean)>32:
				lineClean = lineClean[0:32]
			self.poemArByLines.append(lineClean)
		f.close()
		# Variable for revolving lines to show poetry
		self.iline = -1
		# Start process
		self.run()
		
	def remove_accents(self,data):
		dataU = unicode(data, 'utf8')
		return ''.join((c for c in unicodedata.normalize('NFD', dataU) if unicodedata.category(c) != 'Mn'))
		
	
	def indexTestLine(self):
		iTestline =1+self.iline
		if iTestline>=len(self.poemArByLines):
			iTestline = 0
		return iTestline
    
	def indexLine(self):
		self.iline +=1
		if self.iline>=len(self.poemArByLines):
			self.iline = 0
		return self.iline	
		
	def run(self):
		while True:
			path = "/Users/mcanet/Dropbox/wifiNames/scriptRouter/"
			self.currentpoemLines = list()
			for i in range(0,self.totalWifiHospots):
				#self.isRepitedLine()
				#if not self.repeatedLine:
				self.currentpoemLines.append(self.poemArByLines[self.indexLine()])
				#else:
				#	break
				
			command = "phantomjs "+path+"router.js \""+self.currentpoemLines[0]+"\" \""+self.currentpoemLines[1]+"\" \""+self.currentpoemLines[2]+"\" \""+self.currentpoemLines[3]+"\""
			print command 
			retvalue = os.system(command)
			print retvalue
			time.sleep(120)
			
	def isRepitedLine(self):
		self.repeatedLine = False 
		i = self.indexTestLine()
		print self.poemArByLines[i]
		newLine = self.poemArByLines[i]
		for i in range(0,len(self.currentpoemLines)):
			if self.currentpoemLines[i]==newLine:
				self.repeatedLine = True
				break
		if self.repeatedLine:
			print "have one repited"
			for i in range(len(self.currentpoemLines),self.totalWifiHospots):
				if i==1:
					self.currentpoemLines.append("-")
				if i==2:
					self.currentpoemLines.append("--")
				if i==3:
					self.currentpoemLines.append("---")

if __name__ == "__main__":
	w = wifiPoem()