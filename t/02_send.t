use strict;
use warnings;
use Test::More;
use Test::MockModule;
use SMS::Send::WWW::TelegramBot;

my $mock_ua = Test::MockModule->new('LWP::UserAgent');
my $last_request;

$mock_ua->mock('request', sub {
    my ($self, $request) = @_;
    $last_request = $request;
    return HTTP::Response->new(200, 'OK',
        ['Content-Type' => 'application/json'],
        '{"ok":true,"result":{"message_id":123}}'
    );
});

subtest 'Successful send' => sub {
    my $sender = SMS::Send::WWW::TelegramBot->new(_bot_token => 'test_token');
    ok($sender->send_sms(
        to   => '12345',
        text => 'Test message'
    ), 'Send succeeds');

    my $content = $last_request->content;
    like($content, qr/"chat_id":"12345"/, 'Correct chat_id');
    like($content, qr/"text":"Test message"/, 'Correct text');
};

subtest 'Error conditions' => sub {
    my $sender = SMS::Send::WWW::TelegramBot->new(_bot_token => 'test_token');

    eval { $sender->send_sms(text => 'test') };
    like($@, qr/Missing 'to'/, 'Dies without to');

    eval { $sender->send_sms(to => '123') };
    like($@, qr/Missing 'text'/, 'Dies without text');
};

done_testing();
