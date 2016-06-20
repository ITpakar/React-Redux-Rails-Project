class App::DocusignWebhookController < App::ApplicationController
  def update
    body = request.body.read
    status = Hash.from_xml(body)

    envelope_id = status['DocuSignEnvelopeInformation']['EnvelopeStatus']['EnvelopeID']
    signers = status['DocuSignEnvelopeInformation']['EnvelopeStatus']['RecipientStatuses']['RecipientStatus']

    signers.each do |signer|
      email = signer['Email']
      document_signer = DocumentSigner.where(email: email, envelope_id: envelope_id).first
      document_signer.update_attributes(signed: true) if signer["Signed"]
    end

    render json: {}, status: :ok
  end
end