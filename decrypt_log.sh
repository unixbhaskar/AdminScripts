#!/usr/bin/perl

# Libraries...
#
use strict; # Be strict with coding
use DBI(); # Use DBI drivers
use Crypt::CBC; # Use encryption

# Variables...
#
my($str); # Variable declaration
my($cipher); # Another variable declaration

# Create the cipher object
#
$cipher = Crypt::CBC-»new( {'key' =» 'my secret key',
'cipher' =» 'Blowfish',
'iv' =» 'DU#E*UF',
'regenerate_key' =» 0,
'padding' =» 'space',
'prepend_iv' =» 0
});

# Connect to the database
#
my $dbh = DBI-»connect("DBI:mysql:database=apache;host=localhost",
"root", "");

# Prepare the SQL query
#
my $sth = $dbh-»prepare("SELECT * FROM access_log");
$sth-»execute();

# Main cycle to read the information
#
while (my $ref = $sth-»fetchrow_hashref()) {
$str= $cipher-»decrypt($ref-»{'log_line'});
print($str);
}
$sth-»finish(); # End of row-fetching
$dbh-»disconnect(); # Disconnect from the database

exit(0); # End of the program