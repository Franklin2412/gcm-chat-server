class GcmController < ApplicationController

  skip_before_action :verify_authenticity_token

  def send_notification

    # lets find the sender, receiver.

    if (sender = User.find_by_email params[:sender]) && (receiver = User.find_by_email params[:receiver] )

      if sender.messages.create notification_params


        uri = URI('https://android.googleapis.com/gcm/send')

        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        post_data = ActiveSupport::JSON.encode({ to: receiver.gcm_id, data: {message: params[:content]}})

        headers = {
            'Authorization' => 'key=AIzaSyDdXKKKmhYJeOAMK8ejqkbgrWVPs9Pq4Po',
            'Content-Type' => 'application/json'
        }
        resp, data = https.post(uri.path, post_data, headers)

      end
    end

    render json: collect_messages

  end

  def get_messages
    render json:  collect_messages
  end

  private

  def notification_params
    params.permit(:sender, :content, :receiver)
  end

  def get_messages_param
    params.permit(:sender, :receiver)
  end

  def collect_messages
    result = {}
    messages = Message.where("sender = ? AND receiver = ? OR sender = ? AND receiver = ?", params[:sender], params[:receiver], params[:receiver], params[:sender]).pluck(:content, :sender).last(20)
    if messages
      result[:status] = 0
      result[:messages] = messages
    else
      result[:status] = 1
      result[:messages] = 'Could not found any messages.'
    end
    result
  end

end
