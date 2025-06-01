# SMS::Send::WWW::TelegramBot

A [SMS::Send](https://metacpan.org/pod/SMS::Send) driver for sending messages via the Telegram Bot API.

[![MetaCPAN Link](https://img.shields.io/metacpan/v/SMS-Send-TelegramBot.svg)](https://metacpan.org/pod/SMS::Send::WWW::TelegramBot)
[![Build Status](https://img.shields.io/github/actions/l2c2technologies/sms-send-telegrambot/main)](https://github.com/l2c2technologies/sms-send-telegrambot/actions)
[![Coverage Status](https://img.shields.io/codecov/c/github/l2c2technologies/sms-send-telegrambot)](https://codecov.io/gh/l2c2technologies/sms-send-telegrambot)

## Synopsis

```perl
use SMS::Send;

my $bot_token = 'YOUR_TELEGRAM_BOT_TOKEN';
my $chat_id   = 'YOUR_TELEGRAM_CHAT_ID';
my $message   = 'Hello from Perl via Telegram!';

my $sender = SMS::Send->new('WWW::TelegramBot',
    _bot_token => $bot_token, # Or 'bot_token'
);

my $sent = $sender->send_sms(
    to   => $chat_id,
    text => $message,
);

if ($sent) {
    print "Message sent successfully!\n";
} else {
    warn "Failed to send message: ", $sender->error || "Unknown error", "\n";
}
```

## Description

SMS::Send::WWW::TelegramBot is a driver for the SMS::Send Perl module that allows you to send messages via the Telegram Bot API. By leveraging the SMS::Send API, this module provides a consistent interface for sending messages, abstracting away the specifics of the Telegram API.

This driver is namespaced under WWW:: to indicate that it uses a web-based API, and it's treated as a "(dummy regional)" driver by SMS::Send, allowing the use of non-international phone number formats (in this case, Telegram chat_ids) in the to parameter.

## Installation

You can install this module from CPAN using your preferred CPAN client:

```cpanm SMS::Send::WWW::TelegramBot```

Or manually:

```perl Makefile.PL
make
make install```

Prerequisites

Perl 5.006 or later.

SMS::Send

LWP::UserAgent

JSON

HTTP::Request

These dependencies will be automatically installed if you use a CPAN client like cpanm.

## Configuration

To use this driver, you need a Telegram Bot Token. You can obtain one by talking to BotFather on Telegram.

You also need the chat_id of the user or group you want to send the message to. There are various ways to get this, such as using the getUpdates method of the Telegram Bot API.

When creating the SMS::Send object, you need to provide your bot token, preferably using the _bot_token private parameter or the public bot_token parameter:

```my $sender = SMS::Send->new('WWW::TelegramBot',
    _bot_token => 'YOUR_TELEGRAM_BOT_TOKEN',
);```

## Koha ILS Integration

When used within the Koha ILS, the bot token can also be configured via the SMSSendUsername system preference. The module will attempt to load the token from this preference if _bot_token or bot_token are not provided during object creation.

## Methods

new( $driver, %params )

Creates a new SMS::Send::WWW::TelegramBot object. Requires the _bot_token or bot_token parameter (or the SMSSendUsername Koha preference to be set).

send_sms( %params )

Sends a Telegram message. Takes the following parameters:

to: The Telegram chat_id of the recipient (required).

text: The text content of the message (required).

_parse_mode: (Optional) The parsing mode for the message. Defaults to 'HTML'. See the Telegram Bot API for available modes (e.g., 'Markdown').

## Support

Please report any bugs or feature requests through the GitHub issue tracker:

https://github.com/l2c2technologies/sms-send-telegrambot/issues

## Author

Indranil Das Gupta <indradg@l2c2.co.in> (on behalf of L2C2 Technologies).

## Copyright and License

Copyright (C) 2025 L2C2 Technologies.

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.
