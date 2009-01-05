#!/usr/bin/perl

package Net::Server::Framework::Crypt;

use strict;
use warnings;
use Carp;
use Switch;
use Crypt::CBC;
use MIME::Base64;
use Digest::MD5 qw(md5_hex);

our ($VERSION) = '1.0';

sub encrypt {
    my ( $message, $key, $type, $ascii ) = @_;

    my $cipher;
    $key = 'CHANGE THIS KEY TO SOMETHING SECRET!'
      unless defined $key;
    $type = 'blowfish' unless defined $type;
    switch ($type) {
        case "blowfish" { $cipher = 'Blowfish'; }
    }
    my $c = Crypt::CBC->new(
        -key    => $key,
        -cipher => $cipher,
    );
    my $enc = $c->encrypt($message);
    return $enc
      unless defined $ascii;
    return encode_base64($enc);

}

sub decrypt {
    my ( $message, $key, $type, $ascii ) = @_;

    my $cipher;
    $type = 'blowfish' unless defined $type;
    $key = 'CHANGE THIS KEY TO SOMETHING SECRET!'
      unless defined $key;
    switch ($type) {
        case "blowfish" { $cipher = 'Blowfish'; }
    }
    my $c = Crypt::CBC->new(
        -key    => $key,
        -cipher => $cipher,
    );
    return $c->decrypt($message)
      unless defined $ascii;
    return $c->decrypt( decode_base64($message) );
}

sub hash {
    my $message = shift;

    return md5_hex($message);
}

1;
