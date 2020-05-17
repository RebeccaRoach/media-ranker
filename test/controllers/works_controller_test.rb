require "test_helper"

describe WorksController do
  let(:work) { works(:one) }

  it "should get index" do
    get works_url
    must_respond_with :success
  end

  it "should get new" do
    get new_work_url
    must_respond_with :success
  end

  it "should create work" do
    assert_difference("Work.count") do
      post works_url, params: { work: {  } }
    end

    must_redirect_to work_url(Work.last)
  end

  it "should show work" do
    get work_url(@work)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_work_url(@work)
    must_respond_with :success
  end

  it "should update work" do
    patch work_url(@work), params: { work: {  } }
    must_redirect_to work_url(work)
  end

  it "should destroy work" do
    assert_difference("Work.count", -1) do
      delete work_url(@work)
    end

    must_redirect_to works_url
  end
end
