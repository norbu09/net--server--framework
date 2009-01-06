#!/usr/bin/perl
# this defines all the valid commands for the frontend spooler. if you
# add more commands you have to define them in _is_valid_command

package Net::Server::Framework::Validate;

use strict;
use warnings;
use Carp;
use Data::FormValidator;
use Data::Dumper;

sub verify_command {
    my $data = shift;

    my $rules = {
        required    => [qw/command user pass/],
        optional    => [qw/data format options/],
        filters     => ['trim'],
        constraints => {
            'command' => \&_is_valid_command,
            'user'    => qr/^[\w-]{3,100}/,
            'format'  => qr/^[yaml|xml|json]/,
            'pass'    => qr/^[\w]{10,100}$/,
        },

    };

    my $dfv = Data::FormValidator->check( $data, $rules );
    #print STDERR Dumper($dfv);
    if ( $dfv->has_unknown ) {
        return 2306;
    }
    elsif ( $dfv->has_missing ) {
        return 2003;
    }
    elsif ( $dfv->has_invalid ) {
        if ( defined $dfv->{invalid}->{command} ) {
            return 2000;
        }
        else {
            return 2005;
        }
    }
    return $dfv->valid;
}

sub _is_valid_command {
    my $command  = pop;
    $command = lc($command);
    # add your commands below to enable them in the frontend spooler
    my @commands = qw{login};
    if ( my $hit = grep( /$command/, @commands ) ) {
        return 1;
    }
    return 0;
}

1;

