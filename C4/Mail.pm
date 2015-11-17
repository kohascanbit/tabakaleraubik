package C4::Mail;

# Copyright 2010 Xercode Media Software S.L.
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

use Mail::Sender;
use C4::Context;
use MIME::Base64;
use Carp;

use vars qw($VERSION @ISA @EXPORT);

BEGIN {
    require Exporter;
    $VERSION = 0.03;
    @ISA = qw(Exporter);
    @EXPORT = qw(
        &SendEmail
    );
}

=head1 NAME

C4::Mail - Functions to work with Mail::Sender class

=head1 SendEmail;

$to 			=> Recipient e-mail
$subject		=> Subject
$message		=> Message or body
@attachments	=> Array that contains the files that will be attached to the email ('/tmp/file1.txt','/tmp/file2.txt') 

}

=cut

sub SendEmail {
	my ($from,$to,$subject,$message,$cc,@attachments)=@_;
	my $sender = new Mail::Sender;
	my $auth = "";

	# if (C4::Context->preference("MailAuthProtocol") eq "NO-AUTH"){
	# 	$auth = "";
	# }else{
	#	$auth = C4::Context->preference("MailAuthProtocol");
	# }
	
	# $sender->Body (0, 0, 'text/plain; charset="UTF-8"');
	
	# croak "From: " . $from . ", to: " . $to . ", subject: " . $subject;
	
	if (scalar(@attachments) == 0){
		if ($sender->MailMsg({
			    smtp 	=>  'mail.tabakalera.eu',
			    from 	=>  $from,
			    to 		=>  $to,
			    cc		=> 	$cc,
			    subject =>  $subject,
			    msg 	=>  $message,
			    ctype   => 	'text/plain; charset=utf-8',
			    auth 	=>  'LOGIN',
			    authid 	=>  'mediateka',
			    authpwd =>  'Arteleku4ever',
			  }) < 0) {
			  	$sender->Close;
			  	warn $sender->{'error'};
			   	return 0;
			}else{
				$sender->Close;
				return 1;
			}
	}else{
		if ($sender->MailFile({
			    smtp 	=>  'mail.tabakalera.eu',
			    from 	=>  $from,
			    to 		=>  $to,
			    cc		=> 	$cc,
			    subject =>  $subject,
			    msg 	=>  $message,
			    ctype   => 	'text/plain; charset=utf-8',
			    auth 	=>  'LOGIN',
			    authid 	=>  'mediateka',
			    authpwd =>  'Arteleku4ever',
			    file	=>  @attachments,
			  }) < 0) {
			  	$sender->Close;
			  	warn $sender->{'error_msg'};
			   	return 0;
			}else{
				$sender->Close;
				return 1;
			}
	}
}
1;
__END__

=head1 NOTES

=head1 AUTHOR

Juan Romay
26/06/2008

=cut
