#!/usr/bin/perl -Ilib -w

# a formating lib for response processing

package Net::Server::Framework::Format;

use strict;
use warnings;
use Carp;
use Net::Server::Framework::Errorcodes;

our ($VERSION) = '1.1';

#
# the hash expected looks like that:
# {
#     timing => delta seconds
#     ID => unique hash
#     code => error code
#     data => {
#       key1 => val1
#       key2 => val2
#       ...
#     }
# }
#

sub format {
    my $hash = shift;
    delete $hash->{pass};
    $hash->{meta}->{duration}    = delete $hash->{TIME};
    $hash->{meta}->{transaction} = delete $hash->{ID};
    $hash->{meta}->{code}        = delete $hash->{code};
    $hash->{meta}->{user}        = delete $hash->{user};
    $hash->{meta}->{message}     = c2m( $hash->{meta}->{code} );
    return $hash;
}

sub c2m {
    my $code = shift;
    carp "No error code defined" unless defined $code;

    # find the message
    my $message = Net::Server::Framework::Errorcodes::c2m($code);
    return $message;
}

1;
