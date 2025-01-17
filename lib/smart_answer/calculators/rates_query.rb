module SmartAnswer::Calculators
  class RatesQuery
    def self.from_file(rates_filename, load_path: "config/smart_answers/rates")
      rates_data_path = Rails.root.join(load_path, "#{rates_filename}.yml")
      rates_yaml = YAML.load_file(rates_data_path, permitted_classes: [Date, Symbol])
      rates_data = rates_yaml.map(&:with_indifferent_access)
      new(rates_data)
    end

    attr_reader :data

    def initialize(rates_data)
      @data = rates_data
    end

    def previous_period(date: nil)
      date ||= SmartAnswer::DateHelper.current_day
      previous_period = nil
      data.each do |rates_hash|
        break if rates_hash[:start_date] <= date && rates_hash[:end_date] >= date

        previous_period = rates_hash
      end
      previous_period
    end

    def rates(date = nil)
      date ||= SmartAnswer::DateHelper.current_day
      relevant_rates = data.find do |rates_hash|
        rates_hash[:start_date] <= date && rates_hash[:end_date] >= date
      end
      relevant_rates ||= data.last

      OpenStruct.new(relevant_rates)
    end
  end
end
