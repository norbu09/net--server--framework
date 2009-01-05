#!/usr/bin/perl -Ilib -w

package Net::Server::Framework::Auth;

use strict;
use warnings;
use Carp;
use Switch;
use Net::Server::Framework::DB;
use Net::Server::Framework::Crypt;

our ($VERSION) = '1.0';

sub authenticate {
    my ( $user, $token, $mode ) = @_;
    switch ($mode) {
        case /client/i { return ( _token( $user, $token ) ); }
        case /server/i { return ( _check( $user, $token ) ); }
        case /userpass/i { return ( _userpass( $user, $token ) ); }
        else { carp "2003"; }
    }
}

sub make_pass {
    my $pass = shift;
    return Net::Server::Framework::Crypt::hash($pass);
}

sub _check {
    my ( $user, $token ) = @_;
    my $dbh = Net::Server::Framework::DB::dbconnect('cloud');
    my $res = Net::Server::Framework::DB::get( { dbh => $dbh, key => 'auth', term => $user } );
    if ( my $pass = $res->{$user}->{password} ) {
        my $string = Net::Server::Framework::Crypt::decrypt( $token, $pass, 'blowfish', 'a' );
        print STDERR "DEBUG: $pass - $string\n";
        my ( $u, $time ) = split( /-/, $string, 2 );
        print STDERR "DEBUG: $u, $time\n";
        if ( $u eq $user ) {

            # more than one day time difference is too much
            if (    ( ( $time + 86400 ) gt time )
                and ( time gt( $time - 86400 ) ) )
            {
                return;
            }
        }
    }
    return 2200;
}

sub _token {
    my ( $user, $pass ) = @_;

    my $string = $user . "-" . time;
    my $token = Net::Server::Framework::Crypt::encrypt( $string, $pass, 'blowfish', 'a' );
    chomp($token);
    return $token;
}

sub _userpass {
    my ( $user, $token ) = @_;
    my $dbh = Net::Server::Framework::DB::dbconnect('cloud');
    my $res = Net::Server::Framework::DB::get( { dbh => $dbh, key => 'auth', term => $user } );
    if ( my $pass = $res->{$user}->{password} ) {
        if ( $token eq $pass ) {
            return;
        }
    }
    return 2200;
}

1;

=head1 NAME

<Net::Server::Framework::Auth> - <One-line description of module's purpose>


=head1 VERSION

This documentation refers to <Net::Server::Framework::Auth> version 0.1.


=head1 SYNOPSIS

    use <Net::Server::Framework::Auth>;
    
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


