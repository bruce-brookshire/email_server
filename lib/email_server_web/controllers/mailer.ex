
defmodule EmailServerWeb.Mailer do
    use EmailServerWeb, :controller

    def send_mail(conn, params) do
        IO.inspect params

        if !Map.has_key?(params, "to") do 
            conn 
                |> put_status(:unprocessable_entity)
                |> json(%{ "error" =>  "missing field, :to"}) 
        end

        if !Map.has_key?(params, "subject") do 
            conn 
                |> put_status(:unprocessable_entity)
                |> json(%{ "error" => "missing field, :subject"})
        end

        recipients = params["to"]
        subject = params["subject"]

        cond do
            Map.has_key?(params, "message") -> 
                prep_mail_text_payload(recipients, params["message"], subject)

            Map.has_key?(params, "message_file") -> 
                prep_mail_file_payload(recipients, params["message_file"], subject)

            true -> 
                conn 
                |> put_status(:unprocessable_entity)
                |> json(%{ "error" => "missing field, must have either :message, or :message_file"})
        end
        
        message = params["message"]

        conn
            |> put_status(:ok)
            |> json(%{ "success" => "you did it"})
    end

    def prep_mail_text_payload(recipients, message, subject) do
        url = "https://api.mailgun.net/v3/emails.thatctoguy.com/messages"
        headers = ["Content-Type": "application/x-www-form-urlencoded"]
        params = ["from=info@thatctoguy.com", "subject=" <> subject, "text=" <> message]
        auth = {"api", System.get_env("MAILGUN_API_KEY")}

        recipients
            |> Enum.map(&(send_message &1, url, headers, params, auth))
        
    end

    def prep_mail_file_payload(recipients, filename, subject) do
        url = "https://api.mailgun.net/v3/emails.thatctoguy.com/messages"
        headers = ["Content-Type": "application/x-www-form-urlencoded"]
        params = ["from=info@thatctoguy.com", "subject=" <> subject, "text=" <> filename]
        auth = {"api", System.get_env("MAILGUN_API_KEY")}

        recipients
            |> Enum.map(&(send_message &1, url, headers, params, auth))
    end



    def send_message(recipient, url, headers, params, auth) do

        body = Enum.join(params ++ ["to=" <> recipient], "&")

        content = [body: body, headers: headers, basic_auth: auth]

        IO.inspect content

        # response = HTTPotion.post! url, content

        # IO.inspect response
    end



end




