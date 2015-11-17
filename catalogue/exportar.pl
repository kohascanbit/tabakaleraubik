#!/usr/bin/perl

use strict;
use warnings;
use C4::Auth;
use C4::Output;  # contains gettemplate
use C4::Biblio;  # GetMarcBiblio GetXmlBiblio
use CGI;
use C4::Koha;    # GetItemTypes
use C4::Branch;  # GetBranches

my $query = new CGI;
my $dbh=C4::Context->dbh;
my $filename="josu.mrc";

$dbh = DBI->connect ("DBI:mysql:dbname=koha","koha","kohakoha",{PrintError => 0, RaiseError => 1});
my $marcflavour = C4::Context->preference("marcflavour");
my @sql_params;




    binmode(STDOUT,":utf8");

    $query =
        "SELECT biblioitems.biblionumber FROM biblioitems where biblionumber <= 20";
    my $sth = $dbh->prepare($query);
    $sth->execute(@sql_params);


    while (my ($biblionumber) = $sth->fetchrow) {
        my $record = eval{ GetMarcBiblio($biblionumber); };
        # FIXME: decide how to handle records GetMarcBiblio can't parse or retrieve
        if ($@) {
            next;
        }
        next if not defined $record;

            print STDOUT $record->as_usmarc();
    }
    exit;


