
defmodule EmailServerWeb.Mailer do
    use EmailServerWeb, :controller

    def send_mail(conn, params) do
        IO.inspect params

        #Check our inputs to make sure theyre valid
        
        #TODO can we shrink these checks to be more readable?

        #Do we have email recipients?
        if !Map.has_key?(params, "to") do 
            conn 
                |> put_status(:unprocessable_entity)
                |> json(%{ "error" =>  "missing field, :to"}) 
        end

        #Do we have an email subject?
        if !Map.has_key?(params, "subject") do 
            conn 
                |> put_status(:unprocessable_entity)
                |> json(%{ "error" => "missing field, :subject"})
        end

        #First set of valid inputs. 
        #Below: we can still fail, but otherwise we have all other necessary information
        recipients = params["to"]
        subject = params["subject"]

        #TODO this is not optimal. we are double returning conn responses. figure out how to prevent this
        cond do
            Map.has_key?(params, "message") -> 
                prep_mail_text_payload(conn, recipients, params["message"], subject)

            Map.has_key?(params, "message_file") -> 
                prep_mail_file_payload(conn, recipients, params["message_file"], subject)

            true -> 
                conn 
                    |> put_status(:unprocessable_entity)
                    |> json(%{ "error" => "missing field, must have either :message, or :message_file"})
        end
    end

    def prep_mail_text_payload(conn, recipients, message, subject) do
        url = "https://api.mailgun.net/v3/emails.thatctoguy.com/messages"
        headers = ["Content-Type": "application/x-www-form-urlencoded"]
        params = ["from=info@thatctoguy.com", "subject=" <> subject, "text=" <> message]
        auth = {"api", System.get_env("MAILGUN_API_KEY")}

        recipients
            |> Enum.map(&(send_message &1, url, headers, params, auth))

        conn
            |> put_status(:ok)
            |> json(%{ "success" => "you did it"})
        
    end


    def prep_mail_file_payload(conn, recipients, filename, subject) do
        contents = File.read filename
        
        case contents do
            {:ok, body} -> 
                
                url = "https://api.mailgun.net/v3/emails.thatctoguy.com/messages"
                headers = ["Content-Type": "application/x-www-form-urlencoded"]
                params = ["from=Group 5 CC project<info@thatctoguy.com>", "subject=" <> subject, "html=" <> body]
                auth = {"api", System.get_env("MAILGUN_API_KEY")}

                recipients
                    |> Enum.map(&(send_message &1, url, headers, params, auth))

            {:error, error} -> 
                conn 
                    |> put_status(:not_found)
                    |> json(%{ "error" => "file not found"})
        end

        conn
            |> put_status(:ok)
            |> json(%{ "success" => "you did it, messages sent."})
        
    end



    #Dirty work of sending this message
    def send_message(recipient, url, headers, params, auth) do

        body = Enum.join(params ++ ["to=" <> recipient], "&")
        content = [body: body, headers: headers, basic_auth: auth]

        Task.start(
            fn -> 
                content = HTTPotion.post!(url, content) 
                IO.puts "operation result for recipient: " <> recipient
                IO.inspect content["status_code"]
            end
        )
    end



end




