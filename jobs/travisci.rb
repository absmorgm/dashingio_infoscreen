require 'travis'
require 'travis/pro'

def update_builds(repository, branch, config)
  builds = []
  repo = nil

  if config["type"] == "pro"
    Travis::Pro.access_token = config["auth_token"]
    repo = Travis::Pro::Repository.find(repository)
  else  # Standard namespace
    Travis.access_token = config["auth_token"]
    repo = Travis::Repository.find(repository)
  end

  build = repo.branches[branch]

  build_info = {
    label: "Build #{build.number}",
    value: "[#{build.branch_info}], #{build.state} in #{build.duration}s",
    state: build.state
  }
  builds << build_info

  builds
end

config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/travisci.yml'
config = YAML::load(File.open(config_file))


SCHEDULER.every('2m', first_in: '1s') {
  config.each do |type, type_config|
    type_config["repositories"].each do |data_id, repo_data|
      repo = repo_data["repository"]
      branch = repo_data["branch"]
      send_event(data_id, { items: update_builds(repo, branch, type_config) })
    end
  end
}
