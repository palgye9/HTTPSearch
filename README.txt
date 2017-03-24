NAME
	httpsearch - Search and find http servers and webpages on your network

SYNOPSIS
	httpsearch.pl [IP Address] [Option-ports] [results name]

DESCRIPTION
Simple perl script to search for and find http servers and find some interesting pages if possible.

The script uses nmap in the default mode except with version detection enabled.  So it will be a noisy scan on the network.  It then parses through the nmap information and puts the results into an HTML file you can then use to manually browse to the ones that interest you.

PORT OPTION
Your current options are 1, 2, or 3.
	1 - Default nmap port scan
	2 - Ports 1-10000
	3 - All ports

Additionally if you want you can manually modify the script.  There is a command that is commented out @a that you can modify as you see fit, just don't change the httpsearch_output.xml.  Also to make sure your result file is output, put in some "garbage" into the command so that the argument will find your ouput choice.

DOWNLOAD
There are two files that you will need (both included in the httpsearch.tar.gz file), httpsearch.pl and httpsearch_match.

DOWNLOAD DESCRIPTION
httpsearch.pl contains the perl code.

Within httpsearch_match is a few options at this time:
	login
	pass
	router
	switch
	wireless
	Index of
	slogin

We use grep to search through the web pages so you can use any regular expression you want, one per line. 
