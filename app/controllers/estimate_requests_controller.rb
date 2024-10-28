require 'csv'

class EstimateRequestsController < ApplicationController
  def index
    estimates = Estimate.all
    page = params[:page].to_i rescue 1
    @list = estimates.page(page).reverse_order.per(10)
  end

  def create
    #raise params.inspect

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

    # csv出力
    # delayedjobに登録
  end

  def proceed_multple_numbers(request_number_csv)
    if request_number_csv.content_type != "text/csv"
      flash[:fail] = "ファイル形式が異なります。CSVファイルを選択してください。"
      return
    end

    file = request_number_csv.tempfile
    rows = []
    CSV.foreach(file) do |row|
      rows.push row
    end
    raise rows.inspect
    #data = request_number_csv.read.split(/\r|\n|\r\n/)
    raise data.inspect
    # csv出力
    # delayedjobに登録
    # dbに登録
  end
end
