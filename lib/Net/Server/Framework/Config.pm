#!/usr/bin/perl

package Net::Server::Framework::Config;

use strict;
use warnings;
use Carp;

our ($VERSION) = '1.3';

sub file2hash {
    my $file = shift;

    open( my $FILE, q{<}, $file ) or croak "Could not open $file: $!";
    my $hash;
    while (<$FILE>) {
        if (
            my ( $key, $value ) =
            $_ =~ m{\A                  # beginning of string
                       ^\s*             # trailing spaces are ignored
                       ([^#/]           # match any string
                       \S+)             # not starting with # or /
                                        # and not beeing a space
                      \s+               # any number of spaces
                      (.*)              # any character
                      \n                # newlines at end of line 
                      \z                # end of string
                    }sxm
          )
        {
            $hash->{$key} = $value;
        }
    }
    return $hash;
}

1;
