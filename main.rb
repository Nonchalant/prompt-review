require 'octokit'
require 'slack-ruby-client'
require 'yaml'

conf = ARGV[0]

unless conf != nil then
    puts('conf.yml cannot be load')
    exit(1)
end

client = nil
repositories = []

channel = nil
icon_emoji = nil
username = nil

ids = {}

File.open(conf) do |file|
    yaml = YAML.load(file.read)
    
    github = yaml['github']
    client = Octokit::Client.new(:access_token => github['token'])
    repositories = github['repositories']

    slack = yaml['slack']
    Slack.configure do |config|
        config.token = slack['token']
    end
    
    channel = slack['channel']
    icon_emoji = slack['icon_emoji']
    username = slack['username']

    ids = yaml['ids']
end

pull_requests = repositories
    .map { |repo|
        client
            .pull_requests(repo, :state => 'opened')
            .select { |item| !item.title.include?('WIP') }
            .select { |item| !item.requested_reviewers.empty? }
    }
    .flatten

reviews = Hash.new
pull_requests.each { |pr|
    pr.requested_reviewers.each { |reviewer|
        reviews[reviewer.login] = reviews[reviewer.login].nil? ? pr.html_url : reviews[reviewer.login].to_s + '\r' + pr.html_url
    }
}

attachments = reviews
    .select { |key, value| 
        !ids.select { |item| item["author"] == key }.nil?
    }
    .map { |key, value|
        {   
            pretext: "<@#{ids.select { |item| item["author"] == key }.first["member_id"]}>",
            color: '#7CD197',
            fields: [{
                value: value
            }]
        }
    }

client = Slack::Web::Client.new
client.chat_postMessage(
    username: username,
    icon_emoji: icon_emoji,
    channel: channel,
    attachments: attachments.to_json
)
