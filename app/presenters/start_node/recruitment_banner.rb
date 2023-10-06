module StartNode
  module RecruitmentBanner
    SURVERY_URL = "https://surveys.publishing.service.gov.uk/s/SNFVW1/".freeze
    SURVEY_URLS = {
      "/maternity-paternity-calculator" => SURVERY_URL,
      "/calculate-statutory-sick-pay" => SURVERY_URL,
    }.freeze

    BENEFITS_SURVEY_URL = "https://signup.take-part-in-research.service.gov.uk/home?utm_campaign=Content_History&utm_source=Hold_gov_to_account&utm_medium=gov.uk&t=GDS&id=16".freeze
    BENEFITS_SURVEY_URLS = {
      "/state-pension-age" => BENEFITS_SURVEY_URL,
      "/check-benefits-financial-support" => BENEFITS_SURVEY_URL,
      "/child-benefit-tax-calculator" => BENEFITS_SURVEY_URL,
    }.freeze

    def survey_url(path)
      landing_page?(path) && SURVEY_URLS[base_path]
    end

    def benefits_survey_url(path)
      landing_page?(path) && BENEFITS_SURVEY_URLS[base_path]
    end

  private

    def base_path
      "/#{@flow_presenter.name}"
    end

    def landing_page?(current_path)
      base_path == current_path
    end
  end
end
