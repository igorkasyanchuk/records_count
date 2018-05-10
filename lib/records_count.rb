require 'colorize'
require 'colorized_string'

module RecordsCount
  class Message
    include ActionView::Helpers::TextHelper

    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def message
      "  --> #{pluralize(payload[:record_count], payload[:class_name].underscore.humanize.downcase)}".colorize(:light_cyan)
    end

    def print
      Rails.logger.debug(message)
    end
  end

  def RecordsCount.do_work!
    ActiveSupport::Notifications.subscribe('instantiation.active_record') do |name, start, finish, id, payload|
      RecordsCount::Message.new(payload).print
    end
  end

end

RecordsCount.do_work!