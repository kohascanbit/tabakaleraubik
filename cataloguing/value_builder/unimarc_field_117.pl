#!/usr/bin/perl


# Copyright 2000-2002 Katipo Communications
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

use strict;
#use warnings; FIXME - Bug 2505
use C4::Auth;
use CGI;
use C4::Context;

use C4::Search;
use C4::Output;

=head1 FUNCTIONS

=head2 plugin_parameters

Other parameters added when the plugin is called by the dopop function

=cut

sub plugin_parameters {
my ($dbh,$record,$tagslib,$i,$tabloop) = @_;
return "";
}

sub plugin_javascript {
my ($dbh,$record,$tagslib,$field_number,$tabloop) = @_;
my $res="
<script>
function Focus$field_number(subfield_managed) {
return 1;
}

function Blur$field_number(subfield_managed) {
	return 1;
}

function Clic$field_number(i) {
	defaultvalue=document.getElementById(\"$field_number\").value;
	newin=window.open(\"../cataloguing/plugin_launcher.pl?plugin_name=unimarc_field_117.pl&index=$field_number&result=\"+defaultvalue,\"unimarc_field_117\",'width=600,height=225,toolbar=false,scrollbars=yes');

}
</script>
";

return ($field_number,$res);
}

sub wrapper {
    my ($char) = @_;
    return "space" if $char eq " ";
    return "dblspace" if $char eq "  ";
    return "pipe" if $char eq "|";
    return "dblpipe" if $char eq "||";
    return $char;
}

sub plugin {
my ($input) = @_;
	my $index= $input->param('index');
	my $result= $input->param('result');

	my $dbh = C4::Context->dbh;
my ($template, $loggedinuser, $cookie)
    = get_template_and_user({template_name => "cataloguing/value_builder/unimarc_field_117.tmpl",
			     query => $input,
			     type => "intranet",
			     authnotrequired => 0,
			     flagsrequired => {editcatalogue => '*'},
			     debug => 1,
			     });
 	my $f1 = substr($result,0,2); $f1 = wrapper( $f1 ) if $f1;
 	my $f2 = substr($result,2,2); $f2 = wrapper( $f2 ) if $f2;
 	my $f3 = substr($result,4,2); $f3 = wrapper( $f3 ) if $f3;
 	my $f4 = substr($result,6,2); $f4 = wrapper( $f4 ) if $f4;

 	my $f5 = substr($result,8,1); $f5 = wrapper( $f5 ) if $f5;

	$template->param(index => $index,
							"f1$f1" => 1,
							"f2$f2" => 1,
							"f3$f3" => 1,
							"f4$f4" => 1,
							"f5$f5" => 1
 );
        output_html_with_http_headers $input, $cookie, $template->output;
}

1;
