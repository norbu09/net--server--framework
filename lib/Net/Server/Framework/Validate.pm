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

=head1 NAME

<Validate> - <One-line description of module's purpose>


=head1 VERSION

This documentation refers to <Validate> version 0.1.


=head1 SYNOPSIS

    use <Validate>;
    
# Brief but working code example(s) here showing the most common usage(s)

    # This section will be as far as many users bother reading,
    # so make it as educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.
May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

A separate section listing the public components of the module's interface.
These normally consist of either subroutines that may be exported, or methods
that may be called on objects belonging to the classes that the module provides.
Name the section accordingly.

In an object-oriented module, this section should begin with a sentence of the
form "An object of this class represents...", to give the reader a high-level
context to help them understand the methods that are subsequently described.


=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate
(even the ones that will "never happen"), with a full explanation of each
problem, one or more likely causes, and any suggested remedies.
(See also "Documenting Errors" in Chapter 13.)

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module,
including the names and locations of any configuration files, and the
meaning of any environment variables or properties that can be set. These
descriptions must also include details of any configuration language used.
(See also "Configuration Files" in Chapter 19.)


=head1 DEPENDENCIES

A list of all the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules are
part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.


=head1 INCOMPATIBILITIES

There are no known incompatibilities to date. Feel free to report any problems
you encounter to the author.

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.
Please report problems to 
Lenz Gschwendtner ( <lenz@springtimesoft.com> )
Patches are welcome.

=head1 AUTHOR

Lenz Gschwendtner ( <lenz@springtimesoft.com> )



=head1 LICENCE AND COPYRIGHT

Copyright (c) 
2007 Lenz Gschwerndtner ( <lenz@springtimesoft.comn> )
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


