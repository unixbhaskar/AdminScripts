#!/usr/bin/python
import sys
import subprocess
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication

f = open('/tmp/wgetfile', 'w')

sender = ""
url = ""
sender_header = "From: "
url_header = "Subject: "

for line in sys.stdin:
	sender_pos = line.find(sender_header)
	url_pos = line.find(url_header)
	if sender_pos > -1:
		sender_pos += len(sender_header)
		sender = line[sender_pos:-1]
	if url_pos > -1:
		url_pos += len(url_header)
		url = line[url_pos:-1]

f.write("Found sender " + sender)
f.write("Found URL " + url)

subprocess.call(["rm", "-r", "-f", "/tmp/wgetout"])
# subprocess.call(["/usr/local/bin/wget", "-E", "-H", "-k", "-K", "-p", "-P", "/tmp/wgetout", url])
subprocess.call(["/usr/local/bin/wget", "--page-requisites", "--convert-links", "--no-directories", "--span-hosts", "-T", "5", "-t", "1", "-P", "/tmp/wgetout", url])
subprocess.call(["zip", "-m", "-r", "wget.zip", ".", "-i", "*"], cwd="/tmp/wgetout/")

msg = MIMEMultipart()
msg['Subject'] = "Your requested page " + url
part = MIMEApplication(file("/tmp/wgetout/wget.zip").read())
part.add_header("Content-Disposition", "attachment", filename="wget.zip")
msg.attach(part)

server = smtplib.SMTP('localhost')
server.sendmail("wget@linode.ev98.ca", sender, msg.as_string())
server.quit()
