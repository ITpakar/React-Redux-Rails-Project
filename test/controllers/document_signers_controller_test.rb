require 'test_helper'

class DocumentSignersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document_signer = document_signers(:one)
  end

  test "should get index" do
    get document_signers_url
    assert_response :success
  end

  test "should get new" do
    get new_document_signer_url
    assert_response :success
  end

  test "should create document_signer" do
    assert_difference('DocumentSigner.count') do
      post document_signers_url, params: { document_signer: { document_id: @document_signer.document_id, signed: @document_signer.signed, signed_at: @document_signer.signed_at, user_id: @document_signer.user_id } }
    end

    assert_redirected_to document_signer_path(DocumentSigner.last)
  end

  test "should show document_signer" do
    get document_signer_url(@document_signer)
    assert_response :success
  end

  test "should get edit" do
    get edit_document_signer_url(@document_signer)
    assert_response :success
  end

  test "should update document_signer" do
    patch document_signer_url(@document_signer), params: { document_signer: { document_id: @document_signer.document_id, signed: @document_signer.signed, signed_at: @document_signer.signed_at, user_id: @document_signer.user_id } }
    assert_redirected_to document_signer_path(@document_signer)
  end

  test "should destroy document_signer" do
    assert_difference('DocumentSigner.count', -1) do
      delete document_signer_url(@document_signer)
    end

    assert_redirected_to document_signers_path
  end
end
