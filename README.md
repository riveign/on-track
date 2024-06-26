# On Track

## Description
On Track is a Ruby on Rails application designed to assist users in building and maintaining daily habits. It provides a user-friendly platform for tracking daily activities, ensuring users stay on track with their personal development goals.

## Installation
To set up On Track locally, follow these steps:

### Pre-requisites

1. PostgreSQL database
2. Update Database.yml file with your PostgreSQL username and password
3. gem install bundler
4. gem install rails

### Telegram Bot Setup

1. Create a new Telegram bot using BotFather
2. Update the Telegram bot token in the environment .env file

### Updating Telegram Bot Token

1. Create a new Telegram bot using BotFather
2. Update the Telegram bot token in the environment credentials
3. For production update the webhook configuration running the following command

```bash
rake telegram:bot:set_webhook RAILS_ENV=production
```

### Installation

1. Bundle install
2. Rails db:create
3. Rails de:migrate
4. Bin/dev
5. Bin/rake telegram:bot:poller for Telegram bot

## Contributing
Contributions to On Track are greatly appreciated. If you have ideas for improvement or encounter any issues, feel free to open an issue or submit a pull request.

## License
On Track is open-source software licensed under the MIT License. See the `LICENSE` file for more details.

## Contact
Project Maintainer: [Riveign] - [riveign@gmail.com](mailto:riveign@gmail.com)

## Acknowledgments
- The Ruby on Rails Community for their invaluable resources
- All contributors and users of the On Track application