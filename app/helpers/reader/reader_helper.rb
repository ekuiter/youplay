module Reader::ReaderHelper

  def reader_actions
    {
        t('reader.read') => reader_path,
        t('reader.update') => reader_update_path,
        t('reader.subscribe.button') => reader_subscribe_path,
        t('reader.manage_hidden') => reader_hidden_path
    }
  end

end
