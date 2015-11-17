#!/usr/bin/perl

# Copyright 2010-2011 Spanish Minister of Culture 
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Koha; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


use CGI;
use strict;

use C4::Biblio;
use C4::Context;
use C4::FileLocalRepository;
use C4::Tabakalera;

my $query = new CGI;
my $strXml = '<?xml version="1.0" ?>';
$strXml .= '<Root>';


if ($query->request_method() eq "POST" && $query->param('biblionumber')) {
    my $biblionumber = $query->param('biblionumber');
    my $itemnumber = $query->param('itemnumber');
    my $type = $query->param('type');
    my $dir = C4::Context->preference("dirFileLocalRepository");
    my $urldocument = $query->param('urldocument');
    my $id;
    if ($dir && -d $dir) {
        $dir .= '/' unless ($dir =~ /\/$/);
        if ($type eq 'cover') {
            $id = $biblionumber;
            $dir .= 'covers/';
            deleteFileLR($dir, 'Thumb_' . $biblionumber);
        } elsif ($type eq 'document') {
            
            if ($urldocument =~ /private/){
            	$dir .= 'documents_private/';
            } else{
            	$dir .= 'documents/';
            }
            
            my $frameworkcode = &GetFrameworkCode($biblionumber);
            my $record = GetMarcBiblio($biblionumber);
            if ($record) {
                unless ($itemnumber) {
                    
		            if ($urldocument =~ /-/){
		              	my $num_doc = GetNumDoc($urldocument);
		              	if ($num_doc > 1){
		              		$id =  $biblionumber . '-' . $num_doc;
		              	} else{
		              		$id =  $biblionumber;
		              	}
	                } else{
	            	  	$id = $biblionumber;
	                }
	               # my $extension = GetExtension($urldocument);
                   # my @sc_fields = $record->field(856);
                   # foreach my $sc_field (@sc_fields) {
				   # 	my $u = $sc_field->subfield('u');
				   # 	my $id856 = $id . "." . $extension;
				   # 	if ($u =~ $id856){
				   # 			$record->delete_fields($sc_field);
				   # 		 last;
				   # 		}
				   # }
                    
                    
                    ModBiblio( $record, $biblionumber, $frameworkcode );
                } else {
                    $id = $biblionumber . '_' . $itemnumber;
                    foreach my $field ($record->field('952')) {
                        if ($field->subfield('9') == $itemnumber) {
                            if ($field->subfield('u')) {
                                $field->update('u' => '');
                            }
                            updateUriItemDBLR($itemnumber, '');
                            ModBiblioMarc($record, $biblionumber, $frameworkcode);
                            last;
                        }
                    }
                }
            }
        }
        deleteFileLR($dir, $id) if ($id);
        $strXml .= '<Error>1,' . $type . ',' . $urldocument . '</Error>';
    }
} else {
    $strXml .= '<Error>2</Error>';
}
$strXml .= '</Root>';
print "Content-type: application/xml\n\n";
#print "Content-type: text/html\n\n";
print $strXml;