use Test::More;
use SMS::Send::WWW::TelegramBot;

subtest 'Successful creation' => sub {
    my $sender = eval {
        SMS::Send::WWW::TelegramBot->new(_bot_token => 'test_token')
    };
    is($@, '', 'Creates with token');
    isa_ok($sender, 'SMS::Send::WWW::TelegramBot');
};

subtest 'Missing token' => sub {
    eval { SMS::Send::WWW::TelegramBot->new() };
    like($@, qr/_bot_token/, 'Dies without token');
};

done_testing();
