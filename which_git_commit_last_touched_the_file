#!/usr/bin/perl

my %attributions;
my @files;

open IN, "git ls-tree -r --full-name HEAD |" or die;
while (<IN>) {
	if (/^\S+\s+blob \S+\s+(\S+)$/) {
		push(@files, $1);
		$attributions{$1} = -1;
	}
}
close IN;

my $remaining = $#files + 1;

open IN, "git log -r --root --raw --no-abbrev --pretty=format:%h~%an~%ad~ |" or die;
while (<IN>) {
	if (/^([^:~]+)~(.*)~([^~]+)~$/) {
		($commit, $author, $date) = ($1, $2, $3);
	} elsif (/^:\S+\s+1\S+\s+\S+\s+\S+\s+\S\s+(.*)$/) {
		if ($attributions{$1} == -1) {
			$attributions{$1} = "$author, $date ($commit)";
			$remaining--;
			if ($remaining <= 0) {
				break;
			}
		}
	}
}
close IN;

for $f (@files) {
	print "$f	$attributions{$f}\n";
}