# /usr/bin/perl

# Script to scan the network, find the http services, and 
# then puts the results out into a html file to do scanning

#Version 2.1 (March 2017)

print "usage: sudo httpsearch 192.168.1.0/24 1 outputfilename\n";

#set the option to scan which ports, you can if you so desire
#go to the nmap section and enter your own port list.  You can
#even use the -iL option and use an external file for the port
#list.

if($ARGV[1]==1){
  $ports="";
  }
elsif ($ARGV[1]==2){
  $ports="-p1-10000";
  }
elsif ($ARGV[1]==3){
  $ports="-p1-65535";
  }
else {
  print ("You must set the port option as 1, 2, or 3\n");
  exit;
  }

# This runs the nmap command with the list of ports coming from 
# the options above.  To put in a custom range of ports, here is an example
# <If you like this example remove the # from the front of it and put the #
# in front of the bottom one.  Just like any script the bottom one of the same
# command is what runs and is used.

# @a=("nmap -sV 80,443,8000,8443 $ARGV[0] -oX httpsearch_output.xml");

# If you want to use a list of IP addresses to scan instead of a range make the
# use the following command:

# @a=("nmap -sV $ports -iL <YourFile> -ox httpseach_output.xml");

@a=("nmap -sV $ports $ARGV[0] -oX httpsearch_output.xml");

# Here is an example of not using the options but hardcoding what you 
# want to be scanned:

#@a=("nmap -sV -p 80,443,8081 208.254.219.1-62 -oX httpsearch_output.xml");
system(@a);

#Getting ready to dig through the results!
print "Parsing the data\n";
open(INFILE1, "httpsearch_output.xml");
open(OUTFILE1, ">>$ARGV[2].html");
@inpt1=<INFILE1>;
$length1=@inpt1;
$count1=0;

#HTML code that will go at the top of the html results
print OUTFILE1 "<html><body bgcolor='#B4D1B6'>\n";
print OUTFILE1 "<h2><img src='HTTPSearch.png'>HTTPSearch v2.1</h2>\n";
print OUTFILE1 "<table border=1>\n";
print OUTFILE1 "<tr bgcolor='#C0FFEE'>";
print OUTFILE1 "<td>IP Address</td><td>Port</td><td>Reason</td><td>Description</td></tr>\n";

while($count1 < $length1){
  $line1=@inpt1[$count1];
  if($line1 !~ /<\/host>/){
    if($line1 =~ /address addr/ && $line1 !~ (/mac/)){
      @ipa=split(/"/,$line1);
      $IPAddress=$ipa[1];
      }
    if($line1 =~ /http/ && $line1 =~ /open/) {
      @httpa=split(/"/, $line1);
      $port_a=$httpa[3];
      $desc_a=$httpa[13];
      $desc_b=$httpa[15];

#This command uses wget to get the inforamtion.  It is set with tries equal to 3 and a timeout value of 120
#If you want to change this you can, this is set as a best comprimise.
      @b=("wget -t 3 -T 120 $IPAddress:$port_a -O httpsearch_wget.txt");
      system(@b);
#print(@b);
      sleep(1);

      @c=("grep -i -f httpsearch_matches httpsearch_wget.txt -o >httpsearch_grep");
      system(@c);
      sleep(1);
      open(INFILE2,"httpsearch_grep");
      @inpt2=<INFILE2>;
      $grep_results=$inpt2[0];
      
      # This is where we are going to start to build the HTML page for our results
      $bg_color="#DFB0FF";
      if($grep_results =~ /login/i){
	$bg_color="Green";
	}
      if($grep_results =~ /pass/i){
	$bg_color="Green";
	}
      if($grep_results =~ /switch/i){
	$bg_color="#FF4848";
	}
      if($grep_results =~ /router/i){
	$bg_color="#FF4848";
	}
      if($grep_results =~ /wireless/i){
	$bg_color="#3399FF";
	}
      if($grep_results =~ /Index of/i){
	$bg_color="#ffff00";
	}
	
      print OUTFILE1 "<tr bgcolor='#DFB0FF'><td width=150><a href=http://$IPAddress:$port_a>$IPAddress</a></td><td width=75>$port_a</td><td width=100 bgcolor='$bg_color'>$grep_results</td><td width=300>$desc_a $desc_b</td></tr>\n";
    }
  } 
$count1++
} 
print OUTFILE1 "</table>";
print OUTFILE1 "<p>https://sourceforge.net/u/palgye9/wiki/Home/";
print OUTFILE1 "</body></html>";

#Commands to remove the files that are no longer needed
sleep(1);
unlink(httpsearch_wget.txt);
unlink(httpsearch_grep);
exit;

