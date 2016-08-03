#EOM Version 0.1 by Bruno Rocha

message(“Hello World”)

warn "PR is classed as Work in Progress" if (github.pr_title + github.pr_body).include?("WIP")

#Force a CHANGELOG entry unless it's trivial
declared_trivial = (github.pr_title + github.pr_body).include?("TRIVIAL")
if !git.modified_files.include?("CHANGELOG.md") && !declared_trivial
fail("Please include a CHANGELOG entry. Add [TRIVIAL] to your PR's title if you believe your changes do not need to be documented.")
end

# Don’t allow use_frameworks!
diff = git.diff_for_file["Podfile"]
if diff && diff.patch =~ "use_frameworks!"
  fail('Consider using Carthage instead of use_frameworks! on CocoaPods.')
end

# Ensure summary
if github.pr_body.length < 5 && !declared_trivial
    fail("Please provide a summary in the Pull Request description")
end

# Merge warning
can_merge = github.pr_json["mergeable"]
warn("This PR cannot be merged yet.", sticky: false) unless can_merge

#Pods/Carthage/Gem/Danger Warning
pods = "Podfile"
carthage = "Cartfile"
gem = "Gemfile"
danger = "Dangerfile"
warn "#{github.html_link(pods)} was edited." if git.modified_files.include? pods
warn "#{github.html_link(carthage)} was edited." if git.modified_files.include? carthage
warn "#{github.html_link(gem)} was edited." if git.modified_files.include? gem
warn "#{github.html_link(danger)} was edited." if git.modified_files.include? danger
