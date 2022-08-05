require "test_helper"

class JobHazardAnalysesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job_hazard_analysis = job_hazard_analyses(:one)
  end

  test "should get index" do
    get job_hazard_analyses_url, as: :json
    assert_response :success
  end

  test "should create job_hazard_analysis" do
    assert_difference("JobHazardAnalysis.count") do
      post job_hazard_analyses_url, params: { job_hazard_analysis: { author_id: @job_hazard_analysis.author_id, date: @job_hazard_analysis.date, job_id: @job_hazard_analysis.job_id, summary: @job_hazard_analysis.summary, title: @job_hazard_analysis.title } }, as: :json
    end

    assert_response :created
  end

  test "should show job_hazard_analysis" do
    get job_hazard_analysis_url(@job_hazard_analysis), as: :json
    assert_response :success
  end

  test "should update job_hazard_analysis" do
    patch job_hazard_analysis_url(@job_hazard_analysis), params: { job_hazard_analysis: { author_id: @job_hazard_analysis.author_id, date: @job_hazard_analysis.date, job_id: @job_hazard_analysis.job_id, summary: @job_hazard_analysis.summary, title: @job_hazard_analysis.title } }, as: :json
    assert_response :success
  end

  test "should destroy job_hazard_analysis" do
    assert_difference("JobHazardAnalysis.count", -1) do
      delete job_hazard_analysis_url(@job_hazard_analysis), as: :json
    end

    assert_response :no_content
  end
end
