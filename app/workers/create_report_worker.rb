class CreateReportWorker
  include Sidekiq::Worker

  def perform(user_id, params)
    create_report(user_id, params)
  end

  def create_report(user, params)
    sleep 10
    user_id = User.find_by_id(user)
    report = Report.new(user_id: user)
    client = HTTPClient.new
    response = client.request(:get, 'http://report_serv:5679/', params.to_json)
    answer = JSON.parse(response.body)
    report.text = answer
    report.save
  end
end
