require 'rspec/core/formatters/documentation_formatter'

class JiraFormatter < RSpec::Core::Formatters::DocumentationFormatter

  def failed_issues
    @failed_issues ||= failed_examples.map { |example| example.metadata.fetch(:jira, nil) }.uniq.compact
  end

  def pending_issues
    @pending_issues ||= pending_examples.map { |example| example.metadata.fetch(:jira, nil) }.uniq.compact
  end

  def passed_issues
    @passed_issues ||= examples.map { |example| example.metadata.fetch(:jira, nil) }.uniq.compact - failed_issues - pending_issues
  end

  def dump_summary duration, example_count, failure_count, pending_count
    super

    if not(failed_issues.empty?) or not(passed_issues.empty?) or not(failed_issues.empty?)
      output.print "\nJIRA Report:\n"
    end

    unless passed_issues.empty?
      output.print success_color "Passed\t: #{passed_issues.join(', ')}\n"
    end

    unless pending_issues.empty?
      output.print pending_color "Pending\t: #{pending_issues.join(', ')}\n"
    end

    unless failed_issues.empty?
      output.print failure_color "Failed\t: #{failed_issues.join(', ')}\n"
    end

  end
end