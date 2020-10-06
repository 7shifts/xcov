
module Xcov
  class SlackPoster
    def create_displayable_percent(percent)
      "%.2f%%" % [(percent)]
    end

    def create_displayable_progress_report(progress_percent, current_coverage, target_coverage)
      displayable_progress = create_displayable_percent(progress_percent)
      displayable_current = create_displayable_percent(current_coverage)
      displayable_target = create_displayable_percent(target_coverage)

      message = "Current Coverage: *#{displayable_current}*\n"
      message += "Target Coverage: *#{displayable_target}*\n"
      
      if progress_percent >= 100
        message += ":white_check_mark:"
      elsif progress_percent > 75
        message += ":warning:"
      elsif progress_percent > 50
        message += ":no_entry_sign:"
      else
        message + ":skull:"
      end
      message += " Goal: *#{displayable_progress}* complete\n"
      return message

    end

    def calculate_percent_progress(current, base_coverage, target)
      target_percent = target - base_coverage
      progress = current - base_coverage
      progress_percent = (progress/target_percent * 100)
      return progress_percent
    end

    def create_displayable_target(current_coverage)
      if !Xcov.config[:slack_target_coverage]
        return ""
      end
      base_target_coverage = Xcov.config[:slack_target_coverage_base]
      target_coverage = Xcov.config[:slack_target_coverage]
      
      progress_percent = calculate_percent_progress(
        current_coverage,
        base_target_coverage,
        target_coverage
      )
      return create_displayable_progress_report(
        progress_percent,
        current_coverage,
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

        # if Xcov.config[:slack_target_coverage]
        #   current_coverage = (report.coverage * 100)
        #   append_message = create_displayable_target(current_coverage)
        # end

      end

      
       
     

      begin
        if Xcov.config[:slack_target_coverage]
          current_coverage = (report.coverage * 100)
          append_message = create_displayable_target(current_coverage)
        end
        message = Slack::Notifier::Util::LinkFormatter.format(Xcov.config[:slack_message]) + "\n"+ append_message
        
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
