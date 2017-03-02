#!/usr/bin/perl

use strict;
use warnings;
use Net::Ping;


my $timeout = 10;
my $ping = Net::Ping->new("icmp");
$p->port_number("80");

 foreach $host (<DATA>)
    {
        print "$host is ";
        print "NOT " unless $p->ping($host);
        print "reachable.\n";
    }
$p->close();

while (my $host = <DATA>) {
        next if $host =~ /^\s*$/;
        chomp $host;
        if ($ping->ping($host)) {
                push @alive_hosts, $host;
        } else {
                push @dead_hosts, $host;
        }
}

if (@alive_hosts) {
        print "Alive hosts\n" . "-" x 10 . "\n";
        print join ("\n", sort @alive_hosts) . "\n\n"
}

if (@dead_hosts) {
        print "Dead hosts\n" . "-" x 10 . "\n";
        print join ("\n", sort @dead_hosts) . "\n\n";
}

__DATA__
www.cellrenew.in
www.engagedeo.com
www.kwiknic.in
www.kitchensofindia.com
www.mycandymanclub.com
www.sunfeastdarkfantasy.com
www.fiamadiwillsmen.in
www.fiamadiwills.com
mail.echoupal.com
