# SMS::Send::WWW::TelegramBot

A Perl SMS::Send driver for sending messages via Telegram Bot API. This module provides a bridge between the SMS::Send framework and Telegram's Bot API, allowing you to send messages through Telegram bots as if they were SMS messages.

## Description

SMS::Send::WWW::TelegramBot is a driver for the SMS::Send framework that enables sending messages via Telegram Bot API. It's particularly useful for applications that need to send notifications through Telegram instead of traditional SMS services. The module includes special integration support for Koha library management system.

## Features

- Send messages via Telegram Bot API
- Compatible with SMS::Send framework
- Support for HTML and Markdown parse modes
- Debug mode for troubleshooting
- Special integration with Koha library system
- Comprehensive error handling
- SSL/TLS support for secure API communication

## Installation

### From CPAN

```bash
cpan SMS::Send::WWW::TelegramBot
```

### Manual Installation

```bash
perl Makefile.PL
make
make test
make install
```

## Prerequisites

- Perl 5.006 or higher
- SMS::Send
- LWP::UserAgent
- JSON
- HTTP::Request
- URI::Escape

## Setup

### 1. Create a Telegram Bot

1. Start a chat with [@BotFather](https://t.me/botfather) on Telegram
2. Send `/newbot` command
3. Follow the instructions to create your bot
4. Save the bot token provided by BotFather

### 2. Get Chat ID

To send messages, you need the chat ID of the recipient:

1. Add your bot to a chat or group
2. Send a message to the bot
3. Visit `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
4. Look for the `chat.id` in the response

## Usage

### Basic Usage

```perl
use SMS::Send;

# Create sender instance
my $sender = SMS::Send->new('WWW::TelegramBot',
    _bot_token => 'YOUR_BOT_TOKEN'
);

# Send message
$sender->send_sms(
    to   => 'CHAT_ID',        # Telegram chat ID
    text => 'Hello, World!'
);
```

### With Parse Mode

```perl
my $sender = SMS::Send->new('WWW::TelegramBot',
    _bot_token   => 'YOUR_BOT_TOKEN',
    _parse_mode  => 'Markdown'  # or 'HTML'
);

$sender->send_sms(
    to   => 'CHAT_ID',
    text => '*Bold text* and _italic text_'
);
```

### Debug Mode

```perl
my $sender = SMS::Send->new('WWW::TelegramBot',
    _bot_token => 'YOUR_BOT_TOKEN',
    _debug     => 1
);
```

### Koha Integration

When used within Koha library management system, the bot token can be configured via system preferences:

* set-up SMSSendDriver syspref as 'WWW::TelegramBot'}
* set-up SMSSendUsername syspref with the token of your bot

```perl
# Bot token will be automatically loaded from SMSSendUsername preference
my $sender = SMS::Send->new('WWW::TelegramBot');

$sender->send_sms(
    to   => 'CHAT_ID',
    text => 'Your book is ready for pickup!'
);
```

## Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `_bot_token` or `bot_token` | Telegram Bot API token | Required |
| `_parse_mode` | Message formatting mode (`HTML` or `Markdown`) | `HTML` |
| `_debug` | Enable debug output | `0` |

## Error Handling

The module provides comprehensive error handling:

```perl
my $result = $sender->send_sms(
    to   => 'CHAT_ID',
    text => 'Test message'
);

if ($result) {
    print "Message sent successfully!\n";
} else {
    print "Failed to send message\n";
}
```

## Examples

### HTML Formatting

```perl
$sender->send_sms(
    to   => 'CHAT_ID',
    text => '<b>Important:</b> Your reservation expires <i>tomorrow</i>!'
);
```

### Group Messages

```perl
# Send to a group (use group chat ID)
$sender->send_sms(
    to   => '-1001234567890',  # Group chat ID (negative number)
    text => 'Meeting reminder: 3 PM today'
);
```

## Limitations

- This is a "dummy regional" SMS driver - it sends Telegram messages, not actual SMS
- Requires internet connectivity
- Recipients must have Telegram and interact with your bot first
- Rate limits apply as per Telegram Bot API restrictions
- Message length limited to 4096 characters per Telegram's limits

## Troubleshooting

### Common Issues

1. **"Bot token required" error**
   - Ensure you provide `_bot_token` parameter
   - In Koha, set the `SMSSendUsername` system preference

2. **"Chat not found" error**
   - Verify the chat ID is correct
   - Ensure the recipient has started a conversation with your bot

3. **Network errors**
   - Check internet connectivity
   - Verify firewall settings allow HTTPS connections

### Debug Mode

Enable debug mode to see API requests:

```perl
my $sender = SMS::Send->new('WWW::TelegramBot',
    _bot_token => 'YOUR_BOT_TOKEN',
    _debug     => 1
);
```

## Contributing

Contributions are welcome! Please visit the GitHub repository:
https://github.com/l2c2technologies/sms-send-telegrambot

## Support

- Report bugs: http://rt.cpan.org/Public/Dist/Display.html?Name=SMS-Send-TelegramBot
- Documentation: https://metacpan.org/release/SMS-Send-TelegramBot
- Source code: https://github.com/l2c2technologies/sms-send-telegrambot

## Author

Indranil Das Gupta <indradg@l2c2.co.in> (on behalf of L2C2 Technologies)

## License

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself, or at your option, any later version of Perl 5 you may have available.

This software comes with no warranty of any kind. Your use of this software may result in charges through Telegram's services. Please use carefully and monitor your usage.

## Copyright

Copyright (C) 2025 L2C2 Technologies

Document published by L2C2 Technologies [ https://www.l2c2.co.in ]
