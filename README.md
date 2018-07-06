# promt-review

## Prepare

```
// conf.yml

github:
  token: <GITHUB_API_TOKEN>
  repositories: 
    - Nonchalant/prompt-review
    - ...
slack:
  token: <SLACK_BOT_TOKEN>
  channel: <CHANNEL>
  icon_emoji: <BOT_ICON_EMOJI>
  username: <BOT_NAME>
ids:
  - author: <GITHUB_AUTHOR_NAME>
    member_id: <SLACK_MEMBER_ID>
  - author: ...
    member_id: ...
```

## Requirements

- [Docker](https://www.docker.com/)

## Usage

```
$ make build
$ make run
```