package C4::Labels::Layout;

use strict;
use warnings;

use base qw(C4::Creators::Layout);

use autouse 'Data::Dumper' => qw(Dumper);

BEGIN {
    use version; our $VERSION = qv('3.07.00.049');
}

__PACKAGE__ =~ m/^C4::(.+)::.+$/;
my $me = $1;

sub new {
    my $self = shift;
    push @_, "creator", $me;
    return $self->SUPER::new(@_);
}

sub save {
    my $self = shift;
    push @_, "creator", $me;
    return $self->SUPER::save(@_);
}

sub retrieve {
    my $self = shift;
    push @_, "creator", $me;
    return $self->SUPER::retrieve(@_);
}

sub delete {
    if (ref($_[0])) {
        my $self = shift;  # check to see if this is a method call
        push @_, "creator", $me;
        return $self->SUPER::delete(@_);
    }
    else {
        push @_, "creator", $me;
        return __PACKAGE__->SUPER::delete(@_); # XXX: is this too hackish?
    }
}

1;
