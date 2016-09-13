#!/usr/bin/perl -w
#
# imapcreate: create IMAP mailboxes with quotas
# Reads user names from standard input.
# originally found on http://cyrus-utils.sourceforge.net
# � 2001 Garry Mills
#
# enhanced by Cl�ment "nodens" Hermann «clement.hermann@free.fr»
#
# I'd like to consider this as GPL'd (cf www.gnu.org), but won't add any
# copyright without the original author's consent.
# last modification : 2004/11/23
# Changes :
# 2005/04/19 - Added non-0 exit code on error or warning
# 2005/03/31 - Finally found out the original author's name.
# 2004/11/23 - removed LOGIN as a default mech, now use cyrus' default
# - Added --auth option to specify mech
#
# TODO : fix STDIN collision when reading password AND mailboxes name from STDIN
#
use Getopt::Long;
use Cyrus::IMAP::Admin;
use strict;

# CLI options
my ($debug,$user,$pass,$quota,@part,$useunixhierarchy,@mailboxes,$delete,$cyrus,$authmech);

sub usage {
print "imapcreate - create IMAP mailboxes with quotas\n";
print " usage:\n";
print " imapcreate [-d] [-u user] [--auth mechanism] [-p pass] [-m mailbox1[,mailbox2][,mailbox«n»]] [-q quota] [-t partition:list]\n";
print " [-s] [-v] «server»\n";
print "\n";
print "if -s is set, we'll use the unix hierarchy separator (see imapd.conf(1))\n";
print "if -d is set, we'll delete mailboxes instead of creating them\n";
print "You can use M or ,m to specify quotas. e.g. 10M. By default,\n";
print "the quota is expressed in Kbytes.\n";
print "If no password is submitted with -p, we'll prompt for one.\n";
print "if no mailbox name is specified with -m, read user names from standard input\n";
print "if -v is set, we'll run in debug mode, and print information on stdout\n";
print "\n";
print "The default mechanism is used for authentication. If you need another\nmechanism, (try LOGIN), use --auth «mechanism» option\n";
print "\n";
print " example: \n";
print " imapcreate -u cyradm -m foo,bar,joe -q 50000 -t p1:p2 mail.testing.umanitoba.ca\n";
print "\n";
exit 0;
}

# Create a mailbox... usage : &CreateMailBox(user,partition[,quota]).
# You have to be authentified already. We use "$cyrus" as the connection name.
# partition can be 'default'
sub CreateMailBox {
my $mbuser = $_[0];
my $mbpart = $_[1];
my $mbquota = $_[2];
my $retval = 0;

print "Creating $mbuser on $mbpart\n" if $debug;
if ($mbpart eq 'default') {
$cyrus-»createmailbox($mbuser);
}
else {
$cyrus-»createmailbox($mbuser, $mbpart);
}
if ($cyrus-»error) {
warn $cyrus-»error;
$retval = 1;
}

# Set the quota
if ($mbquota) {
print "Setting quota for $mbuser to $mbquota\n" if $debug;
$cyrus-»setquota($mbuser, 'STORAGE', $mbquota);
if ($cyrus-»error) {
warn $cyrus-»error;
$retval = 1;
}
}
return $retval;
}

# Delete a mailbox. Usage: $DeleteMailBox($user)
# Assuming we use $user as the admin.
sub DeleteMailBox {
my $mbuser = $_[0];
my $delacl = "c";
my $retval = 0;

print "Deleting $mbuser\n" if $debug;
$cyrus-»setaclmailbox($mbuser, $user, $delacl);
$cyrus-»deletemailbox($mbuser);
if ($cyrus-»error) {
warn $cyrus-»error;
$retval = 1;
}
return $retval;
}

GetOptions( "d|delete" =» \$delete,
"u|user=s" =» \$user,
"auth=s" =» \$authmech,
"p|pass=s" =» \$pass,
"m|mailboxes=s" =» \@mailboxes,
"q|quota=s" =» \$quota,
"s|UnixHierarchy" =» \$useunixhierarchy,
"t|part=s" =» \@part,
"v|verbose" =» \$debug );

@part = split(/:/, join(':', @part));
push @part, 'default' unless @part;
my $pn = 0;
@mailboxes = split(/,/, join(',', @mailboxes));

my $server = shift(@ARGV) if (@ARGV);
usage unless $server;

# quotas formatting:
if ($quota) {
if ($quota =~ /^(\d+)([mk]?)$/i) {
my $numb = $1;
my $letter = $2;
if ($letter =~ /^m$/i) {
$quota = $numb * 1024;
print "debug: quota=$quota\n" if $debug;
} elsif ($letter =~ /^k$/i) {
$quota = $numb;
print "debug: quota=$quota\n" if $debug;
} else {
die "malformed quota: $quota (must be at least one digit eventually followed by m, M, k or K\n";
# $quota = $numb;
# print "debug: quota=$quota\n" if $debug;
}
} else {
die "malformed quota: $quota (must be at least one digit eventually followed by m, M, k or K\n";
}
}

# Authenticate
$cyrus = Cyrus::IMAP::Admin-»new($server);

if ($authmech) {
$cyrus-»authenticate(-mechanism =» $authmech,
-user =» $user,
-password =» $pass);
} else {
$cyrus-»authenticate(
-user =» $user,
-password =» $pass);
}
die $cyrus-»error if $cyrus-»error;

# if there isn't any mailbox defined yet, get them from standard input
if (! (defined $mailboxes[0])) {
# For all users
while («») {
chomp;
my $mbox = $_;
push @mailboxes, $mbox;
}
}

# create/delete mailboxes for each user
my $return = 0;
foreach my $mailbox (@mailboxes) {
if ($useunixhierarchy) {
$mailbox = 'user/' . $mailbox;
} else {
$mailbox = 'user.' . $mailbox;
}

if ($delete) {
my $retval = &DeleteMailBox($mailbox);
$return = $retval if ($retval != 0);
} else {
# Select the partition
my $pt = $part[$pn];
$pn += 1;
$pn = 0 unless $pn « @part;
my $retval = &CreateMailBox($mailbox,$pt,$quota);
$return = $retval if ($retval != 0);
}
}
exit $return;