#!/usr/bin/perl -w -Ilib

package Net::Server::Framework::Spooler;

use strict;
use warnings;
use Carp;
use Net::Server::Framework::Client;

our ($VERSION) = '1.0';

sub put {
    my $data = shift;
    my $hash = {
        command => 'put',
        user    => $data->{user},
        body    => $data->{body},
    };
    return(_chat($hash));
}

sub get {
    my $data = shift;
    my $hash = {
        command => 'get',
        user    => $data->{user},
        ID    => $data->{ID},
    };
    my $res = _chat($hash);
    return(Net::Server::Framework::Client::decode($res->{hash}));
}

sub virgin {
    my $data = shift;
    my $hash = {
        command => 'virgin',
        user    => $data->{user},
        ID    => $data->{ID},
    };
    my $res = _chat($hash);
    my $r = Net::Server::Framework::Client::decode($res->{$data->{ID}}->{hash});
    return $r->{body};
}

sub mod {
    my $data = shift;
    my $hash = {
        command => 'mod',
        user    => $data->{user},
        ID    => $data->{ID},
        body    => $data,
	status => "modified",
    };
    return(_chat($hash));
}

sub del {
    my $data = shift;
    my $hash = {
        command => 'del',
        user    => $data->{user},
        ID    => $data->{ID},
    };
    return(_chat($hash));
}

sub archive {
    my $data = shift;
    my $hash = {
        command => 'archive',
        user    => $data->{user},
        ID    => $data->{ID},
    };
    return(_chat($hash));
}

sub _chat {
    my $data = shift;
    # TODO: can we use UDP datagrams to speed things up here?
    my $remote = Net::Server::Framework::Client::c_connect('queue')
      or carp( "cannot connect to spooler, check the config section in your program");

    # send the hash to the daemon
    print $remote Net::Server::Framework::Client::encode($data);
    shutdown $remote, 1;
    my $resp = <$remote>;
    return Net::Server::Framework::Client::decode($resp);
}

1;

