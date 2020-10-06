
module Xcov
  class SlackPoster
  def create_displayable_target
      if !Xcov.config[:slack_target_coverage]
        return ""
      end
      current_coverage = (report.coverage * 100)
      base_target_coverage = Xcov.config[:slack_target_coverage_base]
      target_coverage = Xcov.config[:slack_target_coverage]
      
      progress_percent = calculate_percent_progress(
        current_coverage,
        base_target_coverage,
        target_coverage
      )
      return create_displayable_progress_report(
        progress_percent,
        base_target_coverage,
        target_coverage
      )

    end
    def run(report)
      return if Xcov.config[:skip_slack]
      return if Xcov.config[:slack_url].to_s.empty?

      require 'slack-notifier'

      url = Xcov.config[:slack_url]
      username = Xcov.config[:slack_username]
      channel = Xcov.config[:slack_channel]
      if channel.to_s.length > 0
        channel = ('#' + channel) unless ['#', '@'].include?(channel[0])
      end

      notifier = Slack::Notifier.new(url, channel: channel, username: username)

      attachments = []

      report.targets.each do |target|
        attachments << {
          text: "#{target.name}: #{target.displayable_coverage}",
          color: target.coverage_color,
          short: true
        }

        if Xcov.config[:slack_target_coverage]
          append_message = create_displayable_target
        end

      end

      
      def calculate_percent_progress(current, base, target)
        target_percent = target - base
        progress = current - base
        progress_percent = (progress/target_percent * 100)
        return progress_percent
      end
      def create_displayable_progress_report(progress_percent, base, target)
        displayable_progress = create_displayable_percent(progress_percent)
        displayable_base = create_displayable_percent(self.base)
        displayable_target = create_displayable_percent(target)

        message = "Current Coverage: *#{displayable_progress}*\n"
        message += "Target Coverage: *#{displayable_target}*\n"
        

        if progress_percent >= 100
          message += "🟢"
        elsif progress_percent > 75
          message += "🟡"
        elsif progress_percent > 50
          message += "🟠"
        else
          message + "🔴"
        end
        message += "Goal: *#{displayable_progress}* complete/n"
        return message

      end
      def create_displayable_percent(percent)
        "%.2f%%" % [(percent)]
      end

      begin
      
        message = Slack::Notifier::Util::LinkFormatter.format(Xcov.config[:slack_message]) + "\n"+ append_message
        if Xcov.config[:slack_target_coverage_base]
          coverage = 
          message += "\nCurrent Coverage *#{report.displayable_coverage}*"
        end
        results = notifier.ping(
          message,
          icon_url: 'https://s3-eu-west-1.amazonaws.com/fastlane.tools/fastlane.png',
          attachments: attachments
        )

        if !results.first.nil? && results.first.code.to_i == 200
          UI.message 'Successfully sent Slack notification'.green
        else
          UI.error "xcov failed to upload results to slack"
        end

      rescue Exception => e
        UI.error "xcov failed to upload results to slack. error: #{e.to_s}"
      end
    end

  end
end
