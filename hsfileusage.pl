#! /usr/bin/perl
#
# hsfileusage 2013-05-20
#
# hsfileusage v1.0
#
# Script to search and list most disk space consumed files
#
# It uses find command to do the search
#
# This program is free software: and released under the terms of the
# GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  Please refer <http://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------------
# Created date 2013-05-22
# Written by Ajoy Bharath


use strict;
use Getopt::Long qw(:config no_ignore_case);
use warnings;
use File::Find;

if ( $< != 0 ) {
print "This program must be run as root\n";
exit (0);
}

# Generic variables
my $progversion = "1";
my $progrevision = "0";
my $prog_name = "hsfileusage";

# Programing variables
my $filenos = "";
my $dir = "";
my %size;
my $help;
my $version;

# Sub Routines
sub print_usage() {
        print "ERROR: Unknown option: @_\n" if ( @_ );
        print "Usage: $prog_name -n|--number <number of files to display> -d|--disk <directory to search>\n";
        print "Eg:- $prog_name -n 20 -d /var\n";
		print "\n";
		print "Eg:- $prog_name --number 20 --disk /var\n";
        print "This will search /var directory including the sub directories and display 20 files with highest disk usage.\n";
        exit;
}

sub print_version() {
        print "$prog_name : $progversion.$progrevision\n";
        exit;
}

sub print_help () {
        print "$prog_name : $progversion.$progrevision";
        print "\n";
        print "Usage: $prog_name -n|--number <number of files to display> -d|--disk <directory to search>\n";
        print "\n";
        print "-n|--number <number of files to display> = Number of files with highest disk usage to be displayed in the output.\n";
        print "-d|--disk <directory to search> = The directory/partition you wish to search\n";
        print "-v|--version = Version.\n";
        print "-h|--help = This screen.\n\n";
        print "Eg:- $prog_name -n 20 -d /var\n";
        print "\n";
        print "This will search /var directory including the sub directories and display 20 files with highest disk usage.\n";
        print "\n";
        print "Eg:- $prog_name -n 100 -d /usr/share\n";
        print "\n";
        print "This will search /usr/share directory including the sub directories and display 100 files with highest disk usage.\n";
    exit;
}

# Assigning the options for the program
print_usage() if ( @ARGV < 1 or
          ! GetOptions('n|number=i' => \$filenos,
                        'd|disk=s' => \$dir,
                        'v|version' => \$version,
                        'h|help' => \$help));
print_help() if ($help);
print_version() if ($version);

# Syntax check of your specified options
if ($filenos eq "") {
        print "ERROR: Please specify the number of files you want to display in the output with the option -n or --number\n";
        print "\n";
        print_usage();
}
if ($dir eq "") {
        print "ERROR: Please specify the absolute path of the partion or the directory you want to check the disk usage with the option -d or --disk\n";
        print "\n";
        print_usage();
}
chomp ($filenos);
chomp ($dir);

if (! -d "$dir") {
        print "ERROR: Please specify a valid directory or make sure the directory/partition you specifies exists..!!\n";
        print "\n";
        print_usage();
}

if ($filenos >= 500) {
        print "ERROR: Please specify an integer less than 500..!!\n";
        print "\n";
        print_usage();
}
# Main process done here

find(sub {$size{$File::Find::name} = -s if -f;}, $dir);
my @sorted = sort {$size{$b} <=> $size{$a}} keys %size;

splice @sorted, $filenos if @sorted > $filenos;

printf "%15s %30s\n", "Size in Bytes", "File Name";
printf "%15s\n", "-" x 75;
foreach (@sorted)
{
    printf "%10d %s\n", $size{$_}, $_;
}