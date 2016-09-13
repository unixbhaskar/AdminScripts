#!/usr/bin/python

"""
sqlin

In some of the work I do, one of the most frequent tasks is pulling out a numeric
identifier column and relating it to another table. This is due to poor database
design that I have nothing to do with, but essentially makes cross-selects
prohibitive. 

Here's what you do as an example, assuming you have a terrible Drupal site and
a view that provides an animal type and breed that relate to specific terms.

$ mysql
mysql> \T /tmp/output.txt
mysql> select vid from fancy_view where type = 'Dog' and breed = 'Chihuahua';
   (you'll see a whole bunch of VID's)
mysql> \! sqlin.py /tmp/output.txt
('10000', '10001', '10002', '10003')

   (this makes it quite easy to copy and paste an IN statement, for example)

mysql> select adoption_code from dogs where vid in <<<PASTE HERE>>>;

"""

import sys

f = open(sys.argv[1], 'r')
lines = f.readlines()

values = []

for line in lines:
    if line[0:2] == '| ':
        # This is a value from SQL
        value = line[2:]
        value = value[0:-4]
        if value.isdigit():
            values.append(value)

sql = ""
for value in values:
    sql += "'" + value + "',"
sql = sql[0:-1]
sql = "(" + sql + ")"

print sql + "\n"

f.close()
