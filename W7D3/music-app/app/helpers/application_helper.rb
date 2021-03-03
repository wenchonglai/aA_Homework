module ApplicationHelper
  def method_missing(method_name, *children, **options)
    if method_name.to_s.start_with?("to_")
      tag = method_name.to_s.split("to_")[1].to_sym
      hash = {}
      hash[tag] = { children: children, **options }
      self.to_html(hash)
    end
  end

  def form_auth
    "<input type=\"hidden\" name=\"authenticity_token\" value=\"#{form_authenticity_token}\">".html_safe
  end

  def form_delete(url, text="delete")
    "<form action=\"#{url}\" method=\"post\">
      <input type=\"hidden\" name=\"_method\" value=\"delete\">
      #{form_auth}
      <input type=\"submit\" value=\"#{text}\">
    </form>".html_safe
  end

  def to_html(hash)
    return hash if hash.is_a?(String)

    attrs = []
    children = []
    styles = []

    tag_name = hash.keys.first
    elem_hash = hash[tag_name]

    elem_hash.each do |k, v|
      if k == :children
        (v.is_a?(Array) ? v : [v]).each do |child_hash|
          children << to_html(child_hash)
        end
      elsif k == :style
        v.each do |style_k, style_v|
          styles << "#{style_k.to_s.sub('_', '-')}: #{style_v}"
        end
      elsif k == :class_name
        attrs << "class=\"#{v.is_a?(Array) ? v.join(" ") : v}\""
      else
        attrs << "#{k}=\"#{v}\""
      end
    end

    "<#{tag_name} #{attrs.join(" ")} style=\"#{styles.join("; ")}\">\n#{children.join("\n")}\n</#{tag_name}>".html_safe
  end

  def to_auth_input
    to_input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
  end

  def to_button(url, method, text, **options)
    children = [to_auth_input, *(options[:children] || []), to_input(type: "submit", value: text, class_name: "clickable")]

    unless [:get, :post].include?(method.to_sym)
      children.unshift(to_input(type: "hidden", name: "_method", value: method.to_s))
    end

    to_form(*children, action: url, method: method.to_sym == :get ? :get : :post)
  end
end


