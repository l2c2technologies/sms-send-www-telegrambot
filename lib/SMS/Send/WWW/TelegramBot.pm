package SMS::Send::WWW::TelegramBot;

use 5.006;
use strict;
use warnings;
use base 'SMS::Send::Driver';
use LWP::UserAgent;
use JSON;
use HTTP::Request;
use URI::Escape;
use Carp;
# C4::Context is conditionally loaded/used below to avoid dependency issues outside Koha

our $VERSION = '0.01';
our $AUTHORITY = 'cpan:INDRADG';

=head1 NAME

SMS::Send::WWW::TelegramBot - A (dummy regional) SMS::Send driver for sending messages via Telegram Bot API

=head1 VERSION

Version 0.01

=cut

sub new {
    my ($class, %args) = @_;

    my $bot_token = delete $args{_bot_token} || delete $args{bot_token};

    unless (defined $bot_token) {
        # Attempt to load from Koha preferences only if C4::Context is available
        eval {
            require C4::Context; # Try to load C4::Context
            $bot_token = C4::Context->preference('SMSSendUsername');
        };
        # If eval failed or bot_token is still not defined/empty
        unless (defined $bot_token and length $bot_token) {
            Carp::croak "SMS::Send::WWW::TelegramBot requires your Telegram Bot's token. Please provide it via '_bot_token' or 'bot_token' argument, or set the 'SMSSendUsername' system preference in Koha.";
        }
    }

    my $self = bless {
        _bot_token  => $bot_token,
        _parse_mode => delete $args{_parse_mode} || 'HTML',
        _debug      => delete $args{_debug} // 0,
    }, $class;

    $self->{_endpoint} = "https://api.telegram.org/bot$self->{_bot_token}/sendMessage";
    $self->{ua} = LWP::UserAgent->new(
        timeout  => 10,
        ssl_opts => { verify_hostname => 1, SSL_verify_mode => 0x02 },
    );
    $self->{json} = JSON->new->utf8->canonical;

    return $self;
}

sub send_sms {
    my ($self, %args) = @_;

    my $message_text = $args{text} or Carp::croak "Missing 'text' for Telegram message";
    my $telegram_chat_id = $args{to} or Carp::croak "Missing 'to' (Telegram chat_id)"; # Now 'to' is used for chat_id

    my %params = (
        chat_id    => $telegram_chat_id,
        text       => $message_text,
        parse_mode => $self->{_parse_mode},
    );

    return $self->_send_message_to_telegram(%params) ? 1 : 0;
}

sub _send_message_to_telegram {
    my ($self, %params) = @_;

    my $json_payload = $self->{json}->encode(\%params);
    my $req = HTTP::Request->new(
        POST => $self->{_endpoint},
        ['Content-Type' => 'application/json'],
        $json_payload
    );

    print STDERR ">>> API Request: $json_payload\n" if $self->{_debug};

    my $res = eval { $self->{ua}->request($req) };
    if ($@) {
        $self->error("Network error: $@");
        return 0;
    }

    return $self->_handle_telegram_api_response($res);
}

sub _handle_telegram_api_response {
    my ($self, $res) = @_;

    unless ($res->is_success) {
        $self->error("HTTP error: " . $res->status_line);
        return 0;
    }

    my $json_response = eval { $self->{json}->decode($res->content) };
    if ($@) {
        $self->error("JSON parse error: $@");
        return 0;
    }

    unless ($json_response->{ok}) {
        $self->error("Telegram API error: " . ($json_response->{description} || 'Unknown error'));
        return 0;
    }

    return 1;
}

1;

__END__

=head1 SYNOPSIS

    use SMS::Send;
    # If using in Koha, C4::Context will be available.
    # If using standalone, ensure you pass _bot_token or bot_token directly.

    my $bot_token = 'YOUR_BOT_TOKEN'; # For standalone use

    my $sender = SMS::Send->new('WWW::TelegramBot',
        _bot_token => $bot_token # Pass the token directly
    );
    $sender->send_sms(
        to   => 'CHAT_ID',       # 'to' is used for the Telegram chat ID
        text => 'Hello world!'
    );


=head1 INSTALLATION

See L<https://perldoc.perl.org/perlmodinstall> for information and options
on installing Perl modules.


=head1 BUGS AND LIMITATIONS

You can make new bug reports, and view existing ones, through the
web interface at L<http://rt.cpan.org/Public/Dist/Display.html?Name=SMS-Send-TelegramBot>.

=head1 AVAILABILITY

The project homepage is L<https://metacpan.org/release/SMS-Send-TelegramBot>.

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<https://metacpan.org/module/SMS::Send::TelegramBot/>.

Alternatively, you can also visit the GitHub repository for this driver at
L<https://github.com/l2c2technologies/sms-send-telegrambot>

=head1 AUTHOR

Indranil Das Gupta E<lt>indradg@l2c2.co.inE<gt> (on behalf of L2C2 Technologies).

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2025 L2C2 Technologies

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself, or at your option, any
later version of Perl 5 you may have available.

This software comes with no warranty of any kind, including but not limited to
the implied warranty of merchantability.

Your use of this software may result in charges. Please use this software
carefully keeping a close eye on your usage. The author takes no responsibility
for any such charges accrued.

Document published by L2C2 Technologies [ https://www.l2c2.co.in ]

=cut
