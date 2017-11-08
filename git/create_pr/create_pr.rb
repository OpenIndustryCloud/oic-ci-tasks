#!/usr/bin/ruby

require 'octokit'
Octokit.access_token = ENV['GITHUB_ACCESS_TOKEN']

repo_name = ENV['REPO_NAME'] || 'jtarchie/pullrequest-resource'
base_branch = ENV['BASE_BRANCH'] || 'test-merge'
test_branch = "test-merge-#{Time.now.to_i}"
sha = Octokit.ref(repo_name, "heads/#{base_branch}").object.sha

Octokit.create_ref(repo_name, "heads/#{test_branch}", sha)

blob_sha = Octokit.contents(
  repo_name,
  path: 'LAST_MERGE.md',
  ref: test_branch
).sha

Octokit.update_contents(
  repo_name,
  'LAST_MERGE.md',
  'Updating content',
  blob_sha,
  "File content #{Time.now.to_s}",
  branch: test_branch
)

Octokit.create_pull_request(
  repo_name,
  base_branch,
  test_branch,
  'testing the latest build',
  'testing the latest build'
)