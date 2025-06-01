use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'SMS::Send::WWW::TelegramBot',
    AUTHOR           => q{Indranil Das Gupta <indradg@l2c2.co.in>},
    VERSION_FROM     => 'lib/SMS/Send/WWW/TelegramBot.pm',
    ABSTRACT_FROM    => 'lib/SMS/Send/WWW/TelegramBot.pm',
    LICENSE          => 'artistic_2',
    MIN_PERL_VERSION => '5.006',
    PREREQ_PM => {
        'SMS::Send'      => '0',
        'LWP::UserAgent' => '0',
        'JSON'           => '0',
        'HTTP::Request'  => '0',
    },
    TEST_REQUIRES => {
        'Test::More'       => '0',
        'Test::MockModule' => '0',
        'HTTP::Response'   => '0',
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/l2c2technologies/sms-send-telegrambot.git',
            },
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'SMS-Send-WWW-TelegramBot-*' },
);
