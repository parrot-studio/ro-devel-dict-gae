require 'appengine-apis/users'
require 'dm-core'

DataMapper.setup(:default, "appengine://auto")

class NilClass
  def blank?
    true
  end
  
  def trim_space
    nil
  end
end

class String
  def blank?
    self !~ /\S/
  end
  
  def trim_space
    self.sub(/^[\s　]*/u, '').sub(/[\s　]*$/u, '')
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def current_user
    AppEngine::Users.current_user
  end
  
  def need_admin
    user = current_user
    unless user
      redirect '/'
    end

    unless admin?(user)
      redirect '/'
    end
  end

  def admin?(user)
    return false unless user
    user.email == 'my gmail address' ? true : false
  end
  
  def to_admin
    redirect '/admin'
  end
  
  def conv_lines(exp)
    return '' if exp.blank?
    ret = ''
    exp.lines.each do |line|
      ret << escape_html(line) << '<br>'
    end
    ret
  end
end
