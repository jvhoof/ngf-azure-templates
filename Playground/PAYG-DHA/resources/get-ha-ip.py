import os
import logging
import re
import ConfigParser
import json
import commands
import time

logger = logging.getLogger(__name__)

#Parsing config files for the NGF network needs to only read the boxnet configuration
def read_boxnet(filename,confsec):
	import StringIO
	boxnet = StringIO.StringIO()

	boxnet.write("["+confsec+"]\n")
	try:
		with open(filename) as infile:
			copy = False
			for line in infile:
				if line.strip() == "["+confsec+"]":
					copy = True
				elif line.strip() == "":
					copy = False
				elif copy:
					boxnet.write(str(line))
	except IOError:
		logging.warning("Unable to open config file" + filename)
		exit()

	boxnet.seek(0, os.SEEK_SET)
	#print boxnet.getvalue()
	return boxnet

def get_boxip(confpath, conffile,section='boxnet'):

	boxconf = ConfigParser.ConfigParser()
	boxconf.readfp(read_boxnet(confpath + conffile,section))
	foundip = boxconf.get(section,'IP')
	logger.info("Collecting the box IP from: " + conffile + " from section: " + section + " and IP found is: " + foundip)

	return foundip

def main():

	confpath = "/opt/phion/config/active/"

	#The boxip is the IP taken from the ha network config file. Clusters reverse this pair of files so this should be the other box.
	haip = get_boxip(confpath,'boxnetha.conf')

	if len(haip) < 5:
		logger.warning("Wasn't able to collect HA boxip from " + confpath)
		exit()

	print haip

if __name__=="__main__":
	exit(main())