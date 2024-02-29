require "cucumber/formatter/pretty"

module TestCatalogFormatter
  # Custom formatters allow for different ways do display test results
  # Whole formatter system is event-based, and allows to either expand on
  # existing formatters, or write a completely new one.
  # Also, check the html formatter, it looks really nice in my opinion
  class Formatter < Cucumber::Formatter::Pretty
    def initialize(config)
      @points_total = 0
      @points_success = 0
      super
    end

    def print_comments(up_to_line, indent_amount)
      # Override the print_comments method to do nothing
    end

    def on_test_case_finished(event)
      points = event.test_case.tags.map do |tag|
        match = /@points-(\d+)/.match(tag.name)
        match ? match[1].to_i : 0
      end.sum
      if event.result.passed?
        @points_success += points
        @points_total += points
      elsif event.result.failed?
        @points_total += points
      end
      super
    end

    def on_test_run_finished(event)
      super
      @io.puts("Points: #{@points_success}/#{@points_total}")
    end

    def scenario_result(keyword, scenario_or_scenario_outline, step_count, status, duration, exception)
      if status == :passed
        # Extract points from scenario tags
        points = scenario_or_scenario_outline.tags.map do |tag|
          match = /@points-(\d+)/.match(tag.name)
          match ? match[1].to_i : 0
        end.sum
        @points_sum += points
      end
      super
    end

    def after_features(features)
      super
      puts "\nTotal points for successful scenarios: #{@points_sum}"
    end
  end
end