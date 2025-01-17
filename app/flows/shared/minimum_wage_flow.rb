class MinimumWageFlow < SmartAnswer::Flow
  def define
    # Q1
    radio :what_would_you_like_to_check? do
      option "current_payment"
      option "past_payment"

      on_response do |response|
        self.calculator = SmartAnswer::Calculators::MinimumWageCalculator.new
        calculator.date = calculator.previous_period_start_date if response == "past_payment"
        self.accommodation_charge = nil
      end

      next_node do |response|
        case response
        when "current_payment"
          question :are_you_an_apprentice?
        when "past_payment"
          question :were_you_an_apprentice?
        end
      end
    end

    # Q2
    radio :are_you_an_apprentice? do
      option "not_an_apprentice"
      option "apprentice_under_19"
      option "apprentice_over_19_first_year"
      option "apprentice_over_19_second_year_onwards"

      next_node do |response|
        case response
        when "not_an_apprentice", "apprentice_over_19_second_year_onwards"
          calculator.is_apprentice = false
          question :how_old_are_you?
        when "apprentice_under_19", "apprentice_over_19_first_year"
          calculator.is_apprentice = true
          question :how_often_do_you_get_paid?
        end
      end
    end

    # Q2 Past
    radio :were_you_an_apprentice? do
      option "no"
      option "apprentice_under_19"
      option "apprentice_over_19"

      next_node do |response|
        case response
        when "no"
          calculator.is_apprentice = false
          question :how_old_were_you?
        else
          calculator.is_apprentice = true
          question :how_often_did_you_get_paid?
        end
      end
    end

    # Q3
    value_question :how_old_are_you?, parse: Integer do
      validate do |response|
        calculator.valid_age?(response)
      end

      next_node do |response|
        calculator.age = response
        if calculator.under_school_leaving_age?
          outcome :under_school_leaving_age
        else
          question :how_often_do_you_get_paid?
        end
      end
    end

    # Q3 Past
    value_question :how_old_were_you?, parse: Integer do
      validate do |response|
        calculator.valid_age?(response)
      end

      next_node do |response|
        calculator.age = response
        if calculator.under_school_leaving_age?
          outcome :under_school_leaving_age_past
        else
          question :how_often_did_you_get_paid?
        end
      end
    end

    # Q4
    value_question :how_often_do_you_get_paid?, parse: :to_i do
      validate do |response|
        calculator.valid_pay_frequency?(response)
      end

      next_node do |response|
        calculator.pay_frequency = response
        question :how_many_hours_do_you_work?
      end
    end

    # Q4 Past
    value_question :how_often_did_you_get_paid?, parse: :to_i do
      validate do |response|
        calculator.valid_pay_frequency?(response)
      end

      next_node do |response|
        calculator.pay_frequency = response
        question :how_many_hours_did_you_work?
      end
    end

    # Q5
    value_question :how_many_hours_do_you_work?, parse: Float do
      validate(:error_hours) do |response|
        calculator.valid_hours_worked?(response)
      end

      next_node do |response|
        calculator.basic_hours = response
        question :how_much_are_you_paid_during_pay_period?
      end
    end

    # Q5 Past
    value_question :how_many_hours_did_you_work?, parse: Float do
      validate(:error_hours) do |response|
        calculator.valid_hours_worked?(response)
      end

      next_node do |response|
        calculator.basic_hours = response
        question :how_much_were_you_paid_during_pay_period?
      end
    end

    # Q6
    money_question :how_much_are_you_paid_during_pay_period? do
      next_node do |response|
        calculator.basic_pay = Float(response)
        question :is_provided_with_accommodation?
      end
    end

    # Q6 Past
    money_question :how_much_were_you_paid_during_pay_period? do
      next_node do |response|
        calculator.basic_pay = Float(response)
        question :was_provided_with_accommodation?
      end
    end

    # Q7
    radio :is_provided_with_accommodation? do
      option "no"
      option "yes_free"
      option "yes_charged"

      next_node do |response|
        case response
        when "yes_free"
          question :current_accommodation_usage?
        when "yes_charged"
          question :current_accommodation_charge?
        else
          question :does_employer_charge_for_job_requirements?
        end
      end
    end

    # Q7 Past
    radio :was_provided_with_accommodation? do
      option "no"
      option "yes_free"
      option "yes_charged"

      next_node do |response|
        case response
        when "yes_free"
          question :past_accommodation_usage?
        when "yes_charged"
          question :past_accommodation_charge?
        else
          question :did_employer_charge_for_job_requirements?
        end
      end
    end

    # Q7a
    money_question :current_accommodation_charge? do
      validate do |response|
        calculator.valid_accommodation_charge?(response)
      end

      on_response do |response|
        self.accommodation_charge = response
      end

      next_node do
        question :current_accommodation_usage?
      end
    end

    # Q7a Past
    money_question :past_accommodation_charge? do
      validate do |response|
        calculator.valid_accommodation_charge?(response)
      end

      on_response do |response|
        self.accommodation_charge = response
      end

      next_node do
        question :past_accommodation_usage?
      end
    end

    # Q7b
    value_question :current_accommodation_usage?, parse: Integer do
      validate do |response|
        calculator.valid_accommodation_usage?(response)
      end

      next_node do |response|
        calculator.accommodation_adjustment(accommodation_charge, response)
        question :does_employer_charge_for_job_requirements?
      end
    end

    # Q7b Past
    value_question :past_accommodation_usage?, parse: Integer do
      validate do |response|
        calculator.valid_accommodation_usage?(response)
      end

      next_node do |response|
        calculator.accommodation_adjustment(accommodation_charge, response)
        question :did_employer_charge_for_job_requirements?
      end
    end

    # Q8
    radio :does_employer_charge_for_job_requirements? do
      option "yes"
      option "no"

      next_node do |response|
        calculator.job_requirements_charge = true if response == "yes"
        question :current_additional_work_outside_shift?
      end
    end

    # Q8 past
    radio :did_employer_charge_for_job_requirements? do
      option "yes"
      option "no"

      next_node do |response|
        calculator.job_requirements_charge = true if response == "yes"
        question :past_additional_work_outside_shift?
      end
    end

    # Q9
    radio :current_additional_work_outside_shift? do
      option "yes"
      option "no"

      next_node do |response|
        case response
        when "yes"
          question :current_paid_for_work_outside_shift?
        when "no"
          if calculator.minimum_wage_or_above?
            outcome :current_payment_above
          else
            outcome :current_payment_below
          end
        end
      end
    end

    # Q9 past
    radio :past_additional_work_outside_shift? do
      option "yes"
      option "no"

      next_node do |response|
        case response
        when "yes"
          question :past_paid_for_work_outside_shift?
        when "no"
          if calculator.minimum_wage_or_above?
            outcome :past_payment_above
          else
            outcome :past_payment_below
          end
        end
      end
    end

    # Q9a
    radio :current_paid_for_work_outside_shift? do
      option "yes"
      option "no"

      next_node do |response|
        case response
        when "no"
          calculator.unpaid_additional_hours = true
        end

        if calculator.minimum_wage_or_above?
          outcome :current_payment_above
        else
          outcome :current_payment_below
        end
      end
    end

    # Q9a past
    radio :past_paid_for_work_outside_shift? do
      option "yes"
      option "no"

      next_node do |response|
        case response
        when "no"
          calculator.unpaid_additional_hours = true
        end

        if calculator.minimum_wage_or_above?
          outcome :past_payment_above
        else
          outcome :past_payment_below
        end
      end
    end

    outcome :current_payment_above
    outcome :current_payment_below

    outcome :past_payment_above
    outcome :past_payment_below

    outcome :under_school_leaving_age
    outcome :under_school_leaving_age_past
  end
end
