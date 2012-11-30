module Reader::ReaderHelper

  def reader_actions
    actions = {
        t("reader.update") => reader_update_path,
        t("reader.subscribe.button") => reader_subscribe_path,
        t("reader.manage_hidden") => reader_hidden_path
    }
  end

end
