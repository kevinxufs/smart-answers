require "test_helper"
require "support/flow_test_helper"

class InheritsSomeoneDiesWithoutWillFlowTest < ActiveSupport::TestCase
  include FlowTestHelper

  setup { testing_flow InheritsSomeoneDiesWithoutWillFlow }

  should "render a start page" do
    assert_rendered_start_page
  end

  context "question: region?" do
    setup { testing_node :region? }

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of partner? for any response" do
        assert_next_node :partner?, for_response: "england-and-wales"
      end
    end
  end

  context "question: partner?" do
    setup do
      testing_node :partner?
      add_responses region?: "england-and-wales"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of estate_over_270000? for a 'yes' if region is england-and-wales" do
        assert_next_node :estate_over_270000?, for_response: "yes"
      end

      should "have a next node of children? for a 'no' if region is england-and-wales" do
        assert_next_node :children?, for_response: "no"
      end

      should "have a next node of estate_over_250000? for a 'yes' if region is northern-ireland" do
        add_responses region?: "northern-ireland"
        assert_next_node :estate_over_250000?, for_response: "yes"
      end

      should "have a next node of children? for a 'no' if region is northern-ireland" do
        add_responses region?: "northern-ireland"
        assert_next_node :children?, for_response: "no"
      end

      should "have a next node of :children? for any response if region is scotland" do
        add_responses region?: "scotland"
        assert_next_node :children?, for_response: "yes"
      end
    end
  end

  context "question: estate_over_250000?" do
    setup do
      testing_node :estate_over_250000?
      add_responses region?: "northern-ireland",
                    partner?: "yes"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of children? for a 'yes' response" do
        assert_next_node :children?, for_response: "yes"
      end

      should "have a next node of outcome_60 for a 'no' response" do
        assert_next_node :outcome_60, for_response: "no"
      end
    end
  end

  context "question: estate_over_270000?" do
    setup do
      testing_node :estate_over_270000?
      add_responses region?: "england-and-wales",
                    partner?: "yes"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of children? for a 'yes' response" do
        assert_next_node :children?, for_response: "yes"
      end

      should "have a next node of outcome_1 for a 'no' response" do
        assert_next_node :outcome_1, for_response: "no"
      end
    end
  end

  context "question: children?" do
    setup do
      testing_node :children?
      add_responses region?: "england-and-wales",
                    partner?: "yes",
                    estate_over_270000?: "yes"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_20 for a 'yes' response if has partner and region is england-and-wales" do
        assert_next_node :outcome_20, for_response: "yes"
      end

      should "have a next node of outcome_1 for a 'no' response if has partner and region is england-and-wales" do
        assert_next_node :outcome_1, for_response: "no"
      end

      should "have a next node of outcome_2 for a 'yes' response if has no partner and region is england-and-wales" do
        add_responses partner?: "no"
        assert_next_node :outcome_2, for_response: "yes"
      end

      should "have a next node of parents? for a 'no' response if has no partner and region is england-and-wales" do
        add_responses partner?: "no"
        assert_next_node :parents?, for_response: "no"
      end

      should "have a next node of outcome_40 for a 'yes' response if has partner and region is scotland" do
        add_responses region?: "scotland"
        assert_next_node :outcome_40, for_response: "yes"
      end

      should "have a next node of parents? for a 'no' response if has partner and region is scotland" do
        add_responses region?: "scotland"
        assert_next_node :parents?, for_response: "no"
      end

      should "have a next node of outcome_2 for a 'yes' response if has no partner and region is scotland" do
        add_responses region?: "scotland",
                      partner?: "no"
        assert_next_node :outcome_2, for_response: "yes"
      end

      should "have a next node of parents? for a 'no' response if has no partner and region is scotland" do
        add_responses region?: "scotland",
                      partner?: "no"
        assert_next_node :parents?, for_response: "no"
      end

      should "have a next node of more_than_one_child? for a 'yes' response if has partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes"
        assert_next_node :more_than_one_child?, for_response: "yes"
      end

      should "have a next node of parents? for a 'no' response if has partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes"
        assert_next_node :parents?, for_response: "no"
      end

      should "have a next node of outcome_66 for a 'yes' response if has no partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      partner?: "no"
        assert_next_node :outcome_66, for_response: "yes"
      end

      should "have a next node of parents? for a 'no' response if has no partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      partner?: "no"
        assert_next_node :parents?, for_response: "no"
      end
    end
  end

  context "question: parents?" do
    setup do
      testing_node :parents?
      add_responses region?: "england-and-wales",
                    partner?: "no",
                    children?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_3 for a 'yes' response if region is england-and-wales" do
        assert_next_node :outcome_3, for_response: "yes"
      end

      should "have a next node of siblings? for a 'no' response if region is england-and-wales" do
        assert_next_node :siblings?, for_response: "no"
      end

      should "have a next node of siblings? for any response if region is scotland" do
        add_responses region?: "scotland"
        assert_next_node :siblings?, for_response: "yes"
      end

      should "have a next node of outcome_63 for a 'yes' response if has a partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      partner?: "yes",
                      estate_over_250000?: "yes"
        assert_next_node :outcome_63, for_response: "yes"
      end

      should "have a next node of siblings_including_mixed_parents? for a 'no' response if has a partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      partner?: "yes",
                      estate_over_250000?: "yes"
        assert_next_node :siblings_including_mixed_parents?, for_response: "no"
      end

      should "have a next node of outcome_3 for a 'yes' response if has no a partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes"
        assert_next_node :outcome_3, for_response: "yes"
      end

      should "have a next node of siblings? for a 'no' response if has no a partner and region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes"
        assert_next_node :siblings?, for_response: "no"
      end
    end
  end

  context "question: siblings?" do
    setup do
      testing_node :siblings?
      add_responses region?: "england-and-wales",
                    partner?: "no",
                    children?: "no",
                    parents?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_4 for a 'yes' response if region is england-and-wales" do
        assert_next_node :outcome_4, for_response: "yes"
      end

      should "have a next node of half_siblings? for a 'no' response if region is england-and-wales" do
        assert_next_node :half_siblings?, for_response: "no"
      end

      should "have a next node of outcome_43 for a 'yes' response if has a parther and parents and region is scotland" do
        add_responses region?: "scotland",
                      partner?: "yes",
                      parents?: "yes"
        assert_next_node :outcome_43, for_response: "yes"
      end

      should "have a next node of outcome_42 for a 'no' response if has a parther and parents and region is scotland" do
        add_responses region?: "scotland",
                      partner?: "yes",
                      parents?: "yes"
        assert_next_node :outcome_42, for_response: "no"
      end

      should "have a next node of outcome_41 for a 'yes' response if has a parther but no parents and region is scotland" do
        add_responses region?: "scotland",
                      partner?: "yes"
        assert_next_node :outcome_41, for_response: "yes"
      end

      should "have a next node of outcome_1 for a 'no' response if has a parther but no parents and region is scotland" do
        add_responses region?: "scotland",
                      partner?: "yes"
        assert_next_node :outcome_1, for_response: "no"
      end

      should "have a next node of outcome_44 for a 'yes' response if has no parther and has parents and region is scotland" do
        add_responses region?: "scotland",
                      parents?: "yes"
        assert_next_node :outcome_44, for_response: "yes"
      end

      should "have a next node of outcome_3 for a 'no' response if has no parther and has parents and region is scotland" do
        add_responses region?: "scotland",
                      parents?: "yes"
        assert_next_node :outcome_3, for_response: "no"
      end

      should "have a next node of outcome_4 for a 'yes' response if has no parther and no parents and region is scotland" do
        add_responses region?: "scotland"
        assert_next_node :outcome_4, for_response: "yes"
      end

      should "have a next node of aunts_or_uncles? for a 'no' response if has no parther and no parents and region is scotland" do
        add_responses region?: "scotland"
        assert_next_node :aunts_or_uncles?, for_response: "no"
      end

      should "have a next node of outcome_4 for a 'yes' response if region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes"
        assert_next_node :outcome_4, for_response: "yes"
      end

      should "have a next node of grandparents? for a 'no' response if region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes"
        assert_next_node :grandparents?, for_response: "no"
      end
    end
  end

  context "question: siblings_including_mixed_parents?" do
    setup do
      testing_node :siblings_including_mixed_parents?
      add_responses region?: "northern-ireland",
                    partner?: "yes",
                    estate_over_250000?: "yes",
                    children?: "no",
                    parents?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_64 for a 'yes' response" do
        assert_next_node :outcome_64, for_response: "yes"
      end

      should "have a next node of outcome_65 for a 'no'" do
        assert_next_node :outcome_65, for_response: "no"
      end
    end
  end

  context "question: grandparents?" do
    setup do
      testing_node :grandparents?
      add_responses region?: "northern-ireland",
                    partner?: "no",
                    children?: "no",
                    parents?: "no",
                    siblings?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_5 for a 'yes' response if region is england-and-wales" do
        add_responses region?: "england-and-wales",
                      estate_over_270000?: "yes",
                      half_siblings?: "no"
        assert_next_node :outcome_5, for_response: "yes"
      end

      should "have a next node of aunts_or_uncles? for a 'no' response if region is england-and-wales" do
        add_responses region?: "england-and-wales",
                      estate_over_270000?: "yes",
                      half_siblings?: "no"
        assert_next_node :aunts_or_uncles?, for_response: "no"
      end

      should "have a next node of outcome_5 for a 'yes' response if region is scotland" do
        add_responses region?: "scotland",
                      aunts_or_uncles?: "no"
        assert_next_node :outcome_5, for_response: "yes"
      end

      should "have a next node of aunts_or_uncles? for a 'no' response if region is scotland" do
        add_responses region?: "scotland",
                      aunts_or_uncles?: "no"
        assert_next_node :great_aunts_or_uncles?, for_response: "no"
      end

      should "have a next node of outcome_5 'yes' response if region is northern-ireland" do
        assert_next_node :outcome_5, for_response: "yes"
      end

      should "have a next node of aunts_or_uncles? 'no' response if region is northern-ireland" do
        assert_next_node :aunts_or_uncles?, for_response: "no"
      end
    end
  end

  context "question: aunts_or_uncles?" do
    setup do
      testing_node :aunts_or_uncles?
      add_responses region?: "scotland",
                    partner?: "no",
                    children?: "no",
                    parents?: "no",
                    siblings?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_6 'yes' response if region is england-and-wales" do
        add_responses region?: "england-and-wales",
                      estate_over_270000?: "yes",
                      half_siblings?: "no",
                      grandparents?: "no"
        assert_next_node :outcome_6, for_response: "yes"
      end

      should "have a next node of half_aunts_or_uncles? 'no' response if region is england-and-wales" do
        add_responses region?: "england-and-wales",
                      estate_over_270000?: "yes",
                      half_siblings?: "no",
                      grandparents?: "no"
        assert_next_node :half_aunts_or_uncles?, for_response: "no"
      end

      should "have a next node of outcome_6 'yes' response if region is scotland" do
        assert_next_node :outcome_6, for_response: "yes"
      end

      should "have a next node of grandparents? 'no' response if region is scotland" do
        assert_next_node :grandparents?, for_response: "no"
      end

      should "have a next node of outcome_6 'yes' response if region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes",
                      grandparents?: "no"
        assert_next_node :outcome_6, for_response: "yes"
      end

      should "have a next node of outcome_67 'no' response if region is northern-ireland" do
        add_responses region?: "northern-ireland",
                      estate_over_250000?: "yes",
                      grandparents?: "no"
        assert_next_node :outcome_67, for_response: "no"
      end
    end
  end

  context "question: half_siblings?" do
    setup do
      testing_node :half_siblings?
      add_responses region?: "england-and-wales",
                    partner?: "no",
                    children?: "no",
                    parents?: "no",
                    siblings?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_23 'yes' response" do
        assert_next_node :outcome_23, for_response: "yes"
      end

      should "have a next node of grandparents? 'no' response" do
        assert_next_node :grandparents?, for_response: "no"
      end
    end
  end

  context "question: half_aunts_or_uncles?" do
    setup do
      testing_node :half_aunts_or_uncles?
      add_responses region?: "england-and-wales",
                    partner?: "no",
                    children?: "no",
                    parents?: "no",
                    siblings?: "no",
                    half_siblings?: "no",
                    grandparents?: "no",
                    aunts_or_uncles?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_24 'yes' response" do
        assert_next_node :outcome_24, for_response: "yes"
      end

      should "have a next node of outcome_25 'no' response" do
        assert_next_node :outcome_25, for_response: "no"
      end
    end
  end

  context "question: great_aunts_or_uncles?" do
    setup do
      testing_node :great_aunts_or_uncles?
      add_responses region?: "scotland",
                    partner?: "no",
                    children?: "no",
                    parents?: "no",
                    siblings?: "no",
                    aunts_or_uncles?: "no",
                    grandparents?: "no"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_45 'yes' response" do
        assert_next_node :outcome_45, for_response: "yes"
      end

      should "have a next node of outcome_46 'no' response" do
        assert_next_node :outcome_46, for_response: "no"
      end
    end
  end

  context "question: more_than_one_child?" do
    setup do
      testing_node :more_than_one_child?
      add_responses region?: "northern-ireland",
                    partner?: "yes",
                    estate_over_250000?: "yes",
                    children?: "yes"
    end

    should "render the question" do
      assert_rendered_question
    end

    context "next_node" do
      should "have a next node of outcome_61 'yes' response" do
        assert_next_node :outcome_61, for_response: "yes"
      end

      should "have a next node of outcome_62 'no' response" do
        assert_next_node :outcome_62, for_response: "no"
      end
    end
  end
end
