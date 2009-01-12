use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Net::Server::Framework',
    AUTHOR        => 'Lenz Gschwendtner <lenz@springtimesoft.com>',
    VERSION_FROM  => 'lib/Net/Server/Framework.pm',
    ABSTRACT_FROM => 'lib/Net/Server/Framework.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More'          => 0,
        'Net::Server'         => 0,
        'Crypt::CBC'          => 0,
        'MIME::Base64'        => 0,
        'Digest::MD5'         => 0,
        'DBI'                 => 0,
        'Data::FormValidator' => 0,
        'Data::Serializer'    => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Net-Server-Framework-*' },
);
