use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Net::Server::Framework',
    AUTHOR              => 'Lenz Gschwendtner <lenz@springtimesoft.com>',
    VERSION_FROM        => 'lib/Net/Server/Framework.pm',
    ABSTRACT_FROM       => 'lib/Net/Server/Framework.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Net-Server-Framework-*' },
);
