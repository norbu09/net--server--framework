#!/usr/bin/perl -w

package Net::Server::Framework;

use strict;
use warnings;
use Carp;
use Data::Serializer;
use Net::Server::Framework::DB;
use Net::Server::Framework::Crypt;
use Net::Server::Framework::Auth;
use Net::Server::Framework::Format;
use base qw/Exporter Net::Server::PreFork/;
use vars qw(@EXPORT $VERSION);

our ($VERSION) = '1.0';
@EXPORT = qw/options encode decode register/;

sub options {
    my $self     = shift;
    my $prop     = $self->{server};
    my $template = shift;

    $self->SUPER::options($template);
    $prop->{daemon_name} ||= undef;
    $template->{daemon_name} = \$prop->{daemon_name};
    $prop->{node_name} ||= undef;
    $template->{node_name} = \$prop->{node_name};
}

sub encode {
    my ( $self, $data ) = @_;
    my $s = Data::Serializer->new( compress => '1' );
    return $s->serialize($data);
}

sub decode {
    my ( $self, $data ) = @_;
    my $s = Data::Serializer->new( compress => '1' );
    return $s->deserialize($data);
}

sub register {
    my $self  = shift;
    my $dereg = shift;
    my $status;
    if (defined $dereg) {
        $status = $dereg;
    } else {
        $status = 'running';
    }
    my $dbh   = Net::Server::Framework::DB::dbconnect('registry');
    my ( $host, $port );
    foreach my $p ( @{ $self->{server}->{port} } ) {
        $port .= $p . ',';
    }
    $port =~ s/,$//;
    foreach my $h ( @{ $self->{server}->{host} } ) {
        $host .= $h . ',';
    }
    $host =~ s/,$//;
    my $data = {
        service   => $self->{server}->{daemon_name},
        port      => $port,
        host      => $host,
        lastcheck => time(),
        startup   => time(),
        status    => $status,
    };
    Net::Server::Framework::DB::put( { dbh => $dbh, data => $data, table => 'services' , replace_into => 'true'} );
    $self->log(2,"Registered successfuly\n");
}


1;

=head1 NAME

Net::Server::Framework - a small framework arounf the famous Net::Server libs


=head1 VERSION

This documentation refers to Net::Server::Framework version 1.0.


=head1 SYNOPSIS

    use Net::Server::Framework;
    
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


