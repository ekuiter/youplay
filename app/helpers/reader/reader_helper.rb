module Reader::ReaderHelper

  def reader_actions
    [
      { name: t('reader.read'), path: reader_path },
      { name: t('reader.subscribe.button'), path: reader_subscribe_path },
      { name: t('reader.manage_hiding_rules'), path: reader_hiding_rules_path },
      { name: t('reader.manage_hidden'), path: reader_hidden_path }
    ]
  end

end
