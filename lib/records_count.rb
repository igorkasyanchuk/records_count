module RecordsCount
  class Colorizer
    class << self
      def red(str); colorize_string(str, "\e[1m\e[31m"); end
      def green(str); colorize_string(str, "\e[1m\e[32m"); end
      def dark_green(str); colorize_string(str, "\e[32m"); end
      def yellow(str); colorize_string(str, "\e[1m\e[33m"); end
      def blue(str); colorize_string(str, "\e[1m\e[34m"); end
      def dark_blue(str); colorize_string(str, "\e[34m"); end
      def pur(str); colorize_string(str, "\e[1m\e[35m"); end
      def colorize_string(text, color_code); "#{color_code}#{text}\e[0m"; end
    end
  end

  class Message
    include ActionView::Helpers::TextHelper

    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def message
      "  --> #{pluralize(payload[:record_count], payload[:class_name].underscore.humanize.downcase)}"
    end

    def format
      -> { Colorizer.dark_green(yield) }
    end

    def print
      Rails.logger.debug(format { message }.call)
    end
  end

  class Warning
    WARNING_TIME = 10 # ms

    attr_reader :duration

    def initialize(start, finish)
      @duration = (finish - start).round(1)
    end

    def format
      -> { Colorizer.yellow(yield) }
    end

    def print
      if duration > WARNING_TIME
        Rails.logger.debug format { "  Warning instantiation time: #{duration}ms" }.call
      end
    end
  end

  def RecordsCount.do_work!
    ActiveSupport::Notifications.subscribe('instantiation.active_record') do |name, start, finish, id, payload|
      RecordsCount::Warning.new(start, finish).print
      RecordsCount::Message.new(payload).print
    end
  end

end

RecordsCount.do_work!