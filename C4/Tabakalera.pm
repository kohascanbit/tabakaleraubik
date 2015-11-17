package C4::Tabakalera;

# Copyright 2014 Scanbit

use strict;
use warnings;
use Carp;

# use utf8;
use MARC::Record;
use MARC::File::USMARC;
use MARC::File::XML;
use POSIX qw(strftime);
use Module::Load::Conditional qw(can_load);

use C4::Koha;
use C4::Dates qw/format_date/;
use C4::Log;    # logaction
use C4::ClassSource;
use C4::Charset;
use C4::Linker;
use C4::OAI::Sets;
use C4::AuthoritiesMarc;

use vars qw($VERSION @ISA @EXPORT);

BEGIN {
    $VERSION = 3.07.00.049;

    require Exporter;
    @ISA = qw( Exporter );

    # to get something
    push @EXPORT, qw(
      &GetOPACMarcNotes
      &GetNormalizedRecordType
      &GetBiblionumberOrigin
      &GetNumDoc
      &GetExtension
      &CargarDatosAutoridad
      &CargarDatosAutoridadyAsociados
      &GetSuggestionList
      &GetColectionList
    );

}

eval {
    if (C4::Context->ismemcached) {
        require Memoize::Memcached;
        import Memoize::Memcached qw(memoize_memcached);

        memoize_memcached( 'GetMarcStructure',
                            memcached => C4::Context->memcached);
    }
};

=head2 GetOPACMarcNotes

  $marcnotesarray = GetOPACMarcNotes( $record, $marcflavour );

Get all notes from the MARC record in the OPAC and returns them in an array.
The note are stored in different fields depending on MARC flavour

=cut

sub GetOPACMarcNotes {
    my ( $record, $marcflavour ) = @_;
    my $scope;
    if ( $marcflavour eq "UNIMARC" ) {
        $scope = '3..';
    } else {    # assume marc21 if not unimarc
        $scope = '5..';
    }
    my @marcnotes;
    my $note = "";
    my $tag  = "";
    my $marcnote;
    my %blacklist = map { $_ => 1 } split(/,/,C4::Context->preference('NotesOPACBlacklist'));
    foreach my $field ( $record->field($scope) ) {
        my $tag = $field->tag();
        if (!$blacklist{$tag}) {
            my $value = $field->as_string();
            if ( $note ne "" ) {
                $marcnote = { marcnote => $note, };
                push @marcnotes, $marcnote;
                $note = $value;
            }
            if ( $note ne $value ) {
                $note = $note . " " . $value;
            }
        }
    }

    if ($note) {
        $marcnote = { marcnote => $note };
        push @marcnotes, $marcnote;    #load last tag into array
    }
    return \@marcnotes;
}    # end GetOPACMarcNotes


sub GetNormalizedRecordType {
    my ($record) = @_;
    my @fields;
    return unless $record;

    # assume marc21 if not unimarc
    my $pos7 = substr $record->leader(), 7, 1;
    my $pos6 = substr $record->leader(), 6, 1;
    if ($pos6 eq 'a'){
    	if ($pos7 eq 'a' || $pos7 eq 'b'){
    		return 'AR';
    	} 
    	elsif ($pos7 eq 'i' || $pos7 eq 's'){
    		return 'SE';
    	} 
    }
    return '';
}

sub GetBiblionumberOrigin{
	my ($biblionumber) = @_;
	my $dbh = C4::Context->dbh;
    my $sth = $dbh->prepare('select ExtractValue(biblioitems.marcxml,\'//datafield[@tag="773"]/subfield[@code="w"]\') from biblioitems where biblionumber = ?');
    $sth->execute($biblionumber);
	return $sth->fetchrow;    		
}

sub GetNumDoc {
	my ( $urldocument ) = @_;
	my @registros = split("documents",$urldocument);
    my $registro = $registros[1]; 
    my @arreglo = split("-",$registro);
    my $num_doc = 1;
    if (scalar(@arreglo) > 1){
    	my $segundo = $arreglo[1];
    	my @arreglo2 = split("\\.",$segundo);
    	$num_doc = $arreglo2[0];
    }
    return $num_doc;
}    # end GetNumDoc

sub GetExtension {
	my ( $urldocument ) = @_;
	my @registros = split("documents",$urldocument);
    my $registro = $registros[1]; 
    my @arreglo = split("-",$registro);
    my $extension = "";
    if (scalar(@arreglo) > 1){
    	my $segundo = $arreglo[1];
    	my @arreglo2 = split("\\.",$segundo);
    	$extension = $arreglo2[1];
    }
    return $extension;
}    # end GetExtension

=head2 CargarDatosAutoridad

    CargarDatosAutoridad($record, $auth_type, $repet, $subfield_loop_ref, $relationship);

Carga en los datos de la autoridad.

=cut

sub CargarDatosAutoridad {
	my ( $record, $auth_type, $repet, $subfield_loop_ref, $relationship ) = @_;
	my @fields = $record->field( $auth_type->{auth_tag_to_report} );
    my $repet2 = ($repet || 1) - 1;
    my $field = $fields[$repet2];

    # Get all values for each distinct subfield
    my %subfields;
    for ( $field->subfields ) {
        next if $_->[0] == "9"; # $9 will be set with authid value
        my $letter = $_->[0];
        next if defined $subfields{$letter};
        my @values = $field->subfield($letter);
        $subfields{$letter} = \@values;
    }

    # Add all subfields to the $subfield_loop_ref
    for( keys %subfields ) {
        my $letter = $_ || '@';
        push( @{$subfield_loop_ref}, {marc_subfield => $letter, marc_values => $subfields{$_}} );
    }

    push( @{$subfield_loop_ref}, { marc_subfield => 'w', marc_values => $relationship } ) if ( $relationship );
    
}

sub CargarDatosAutoridadyAsociados {
	my ( $authid, $auth_type, $repet, $subfield_loop_ref, $tag_loop_ref, $relationship, $tagid ) = @_;
    my $record = C4::AuthoritiesMarc::GetAuthority($authid);
    CargarDatosAutoridad($record, $auth_type, $repet, $subfield_loop_ref, $relationship);
    
    if ($tagid == '650' || $tagid == '651' || $tagid == '655' || $tagid == '600' || $tagid == '610'){
    	my $fieldtag = '750';
	   	foreach ($record->field($fieldtag)) {
	   		my @tag_subfield_loop;
		   	AgregarTagYCargarDatosAutoridad($_, $auth_type, \@tag_subfield_loop);
		   	push( @{$tag_loop_ref}, {tag_subfield_loop => \@tag_subfield_loop, indicator2 => $_->indicator(2)} );
	   	}
	   	$fieldtag = '751';
	   	foreach ($record->field($fieldtag)) {
	   		my @tag_subfield_loop;
		   	AgregarTagYCargarDatosAutoridad($_, $auth_type, \@tag_subfield_loop);
		   	push( @{$tag_loop_ref}, {tag_subfield_loop => \@tag_subfield_loop, indicator2 => $_->indicator(2)} );
	   	}
	   	$fieldtag = '755';
	   	foreach ($record->field($fieldtag)) {
	   		my @tag_subfield_loop;
		   	AgregarTagYCargarDatosAutoridad($_, $auth_type, \@tag_subfield_loop);
		   	push( @{$tag_loop_ref}, {tag_subfield_loop => \@tag_subfield_loop, indicator2 => $_->indicator(2)} );
	   }
	   $fieldtag = '700';
	   	foreach ($record->field($fieldtag)) {
	   		my @tag_subfield_loop;
		   	AgregarTagYCargarDatosAutoridad($_, $auth_type, \@tag_subfield_loop);
		   	push( @{$tag_loop_ref}, {tag_subfield_loop => \@tag_subfield_loop, indicator2 => $_->indicator(2)} );
	   }
	   $fieldtag = '710';
	   	foreach ($record->field($fieldtag)) {
	   		my @tag_subfield_loop;
		   	AgregarTagYCargarDatosAutoridad($_, $auth_type, \@tag_subfield_loop);
		   	push( @{$tag_loop_ref}, {tag_subfield_loop => \@tag_subfield_loop, indicator2 => $_->indicator(2)} );
	   }
    } elsif ($tagid == '110' || $tagid == '920'){
    	my $fieldtag = '710';
	   	foreach ($record->field($fieldtag)) {
	   		my @tag_subfield_loop;
		   	AgregarTagYCargarDatosAutoridad($_, $auth_type, \@tag_subfield_loop);
		   	push( @{$tag_loop_ref}, {tag_subfield_loop => \@tag_subfield_loop, indicator2 => $_->indicator(2)} );
	   	}
    } elsif ($tagid == '111' || $tagid == '921'){
    	my $fieldtag = '711';
	   	foreach ($record->field($fieldtag)) {
	   		my @tag_subfield_loop;
		   	AgregarTagYCargarDatosAutoridad($_, $auth_type, \@tag_subfield_loop);
		   	push( @{$tag_loop_ref}, {tag_subfield_loop => \@tag_subfield_loop, indicator2 => $_->indicator(2)} );
	   	}
    }
}

sub AgregarTagYCargarDatosAutoridad {
	
	my ( $field, $auth_type, $tag_subfield_loop_ref ) = @_;
	
    # Get all values for each distinct subfield
    my %subfields;
    for ( $field->subfields ) {
        my $letter = $_->[0];
        next if defined $subfields{$letter};
        my @values = $field->subfield($letter);
        $subfields{$letter} = \@values;
    }

    # Add all subfields to the $subfield_loop_ref
    for( keys %subfields ) {
        my $letter = $_ || '@';
        push( @{$tag_subfield_loop_ref}, {marc_subfield => $letter, marc_values => $subfields{$_}} );
    }
}

sub GetSuggestionList {
	
	my ( $biblionumber ) = @_;
	
    my $dbh = C4::Context->dbh;
    my $sth = $dbh->prepare("SELECT * FROM items WHERE items.biblioitemnumber = ?") || die $dbh->errstr;
    # Get all items attached to a biblioitem
    my $i = 0;
    my @results; 
    $sth->execute($biblionumber) || die $sth->errstr;
    while ( my $data = $sth->fetchrow_hashref ) {  
        # Foreach item, get circulation information
        my $sth2 = $dbh->prepare( "SELECT distinct biblio.biblionumber, biblio.title, biblio.author 
        		FROM items, biblio WHERE items.ccode = ? and biblio.biblionumber = items.biblionumber and biblio.biblionumber <> ?
        		limit 50"
        );
        $sth2->execute( $data->{'ccode'}, $biblionumber);
        while ( my $data2 = $sth2->fetchrow_hashref ) {
            push @results, $data2;
        }
        if (scalar(@results) >= 50){
        	last;
        }
    } 
    return (\@results); 
}

sub GetCollectionList {
	
	my ( $collection ) = @_;
	
    my $dbh = C4::Context->dbh;
    my $sth = $dbh->prepare("SELECT biblionumber FROM biblioitems WHERE ExtractValue(marcxml,\'//datafield[\@tag=\"953\"]/subfield[\@code=\"a\"]\') = ?") || die $dbh->errstr;
    # Get all items attached to a biblioitem
    my $i = 0;
    my @results; 
    $sth->execute($collection) || die $sth->errstr;
    while ( my $data = $sth->fetchrow_hashref ) {  
        push @results, $data;
    } 
    return (\@results); 
}

1;


__END__

=head1 AUTHOR

Scanbit

=cut
