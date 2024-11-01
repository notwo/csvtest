require 'csv'

class EstimateRequestsController < ApplicationController
  CSV_AU_COLUMN = 48

  def index
    estimates = Estimate.all
    page = params[:page].to_i rescue 1
    @list = estimates.page(page).reverse_order.per(10)
  end

  def create
    if params.key?(:request_number)
      proceed_single_number(params[:request_number].to_i)
    elsif params.key?(:request_number_csv)
      proceed_multple_numbers(params[:request_number_csv])
    end

    redirect_to :estimate_requests
  end

  private

  def proceed_single_number(request_number)
    Estimate.create!(request_number: request_number)
    flash[:success] = "番号#{request_number}をリクエストしました"

    # delayedjobに登録
    RecordRequestJob.perform_later [request_number]
  end

  def proceed_multple_numbers(request_number_csv)
    if request_number_csv.content_type != "text/csv"
      flash[:fail] = "ファイル形式が異なります。CSVファイルを選択してください。"
      return
    end

    file = request_number_csv.tempfile
    request_numbers = []
    CSV.foreach(file) do |row|
      request_numbers.push row[CSV_AU_COLUMN-1]
    end

    estimates = request_numbers.uniq.map { |request_number| { request_number: request_number, created_at: Time.current, updated_at: Time.current } }
    Estimate.insert_all estimates

    # delayedjobに登録
    RecordRequestJob.perform_later request_numbers

    flash[:success] = "csvファイル「#{request_number_csv.original_filename}」記載の番号をリクエストしました"
  end
end
