require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document = documents(:one)
  end

  test "should get index" do
    get documents_url
    assert_response :success
  end

  test "should get new" do
    get new_document_url
    assert_response :success
  end

  test "should create document" do
    assert_difference('Document.count') do
      post documents_url, params: { document: { activated: @document.activated, created_by: @document.created_by, file_name: @document.file_name, file_size: @document.file_size, file_type: @document.file_type, file_uploaded_at: @document.file_uploaded_at, parent_id: @document.parent_id, parent_type: @document.parent_type } }
    end

    assert_redirected_to document_path(Document.last)
  end

  test "should show document" do
    get document_url(@document)
    assert_response :success
  end

  test "should get edit" do
    get edit_document_url(@document)
    assert_response :success
  end

  test "should update document" do
    patch document_url(@document), params: { document: { activated: @document.activated, created_by: @document.created_by, file_name: @document.file_name, file_size: @document.file_size, file_type: @document.file_type, file_uploaded_at: @document.file_uploaded_at, parent_id: @document.parent_id, parent_type: @document.parent_type } }
    assert_redirected_to document_path(@document)
  end

  test "should destroy document" do
    assert_difference('Document.count', -1) do
      delete document_url(@document)
    end

    assert_redirected_to documents_path
  end
end
